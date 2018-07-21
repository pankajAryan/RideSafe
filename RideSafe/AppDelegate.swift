//
//  AppDelegate.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 06/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate//, MessagingDelegate
{
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    // for handling notification
    var  remoteNitificationPayloadDict : [AnyHashable : Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        if let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]  {
            remoteNitificationPayloadDict = remoteNotif as? [AnyHashable : Any]
        }
        
        setRootVC()

        registerForPushNotificationAndAnalytics(application)
        
        return true
    }
    
    private func setRootVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        UserDefaults.standard.bool(forKey:UserDefaultsKeys.isUserLogedin.rawValue) == true ? showRootVC(root: .Dashboard) : showRootVC(root: .Login)
    }
    
    func showRootVC(root:RootController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController:UIViewController?
        switch root {
        case .Dashboard:
            
            let usertype =  getuserType()
            switch usertype {
            case .Citizen:
                initialViewController = storyboard.instantiateViewController(withIdentifier: "dashboard") as? DashboardController
                
            case.Official, .FieldOfficial, .EscalationOfficial:
                let storyboard = UIStoryboard(name: "FOMain", bundle: nil)
                initialViewController = storyboard.instantiateViewController(withIdentifier: "FODashboardController") as? FODashboardController
                
            case .none:
                return
            }
            
        case .Login:
            initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginController") as? LoginController
        }
        
        guard let initialVC = initialViewController else { return  }
        let navController = storyboard.instantiateViewController(withIdentifier: "RideSafeNavigationController") as! RideSafeNavigationController
        navController.viewControllers = [initialVC]
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func getuserType() -> UserType {
        if let usertype = UserDefaults.standard.string(forKey: UserDefaultsKeys.userType.rawValue) {
            if usertype != "C" {
                return UserType.Official
            }
        }
        return UserType.Citizen
    }
    
    private func registerForPushNotificationAndAnalytics(_ application: UIApplication) {
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
//        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    

    //MARK:- Push Notification Delegates
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")

        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "DeviceToken")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

        handlePushNotification(payloadDict:userInfo,application: application)
    }
    
    func handlePushNotification(payloadDict : [AnyHashable : Any], application: UIApplication) {
        
        switch application.applicationState {
            
        case .active:
            
            let vc = (window?.rootViewController)!
 
            let user = UserType.Citizen.getTokenUserType(userType: vc.userType)
            if user == .none {
                return
            }
            
            let apsDict = payloadDict["aps"] as? [AnyHashable : Any]
           
//            {"aps":{"alert":"Test notification","badge":1,"sound":"default"},"type":"Success"}

            let alert = UIAlertController(title:"", message: apsDict?["alert"] as? String ?? "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (act) in
                alert.dismiss(animated: true, completion: nil)
            }))

            alert.addAction(UIAlertAction(title: "Show", style: .default, handler: { (act) in
                self.handlePushFlow(payloadDict:payloadDict)
            }))
            
            vc.present(alert, animated: true, completion: nil)
            break
        case .inactive:
            handlePushFlow(payloadDict:payloadDict)
            break
        case .background:
            
            handlePushFlow(payloadDict:payloadDict)
            break
        }
    }
    
    func handlePushFlow(payloadDict : [AnyHashable : Any]) {
        
        if let key = payloadDict["type"] as? String {
            switch key {
            case "my_reports":
                gotoMyReportsScreen()
                break
            case "notification":
                //just open the app
                gotoHomeScreen()
                break
            case "alert":
                gotoAlertScreen()
                break
            default:
                break
            }
        }
    }
    
    func gotoMyReportsScreen() {
        
        let vc = (window?.rootViewController)!
        let user = UserType.Citizen.getTokenUserType(userType: vc.userType)
        if user == .Citizen {
            
            if let nav = window?.rootViewController as? UINavigationController, let dash = nav.viewControllers.first as? DashboardController  {
                
                let reportVC = UIStoryboard.init(name: "Reports", bundle: nil).instantiateViewController(withIdentifier: "ReportsContainerViewController")
                //pop till root
                dash.navigationController?.popToRootViewController(animated: true)
                //push
                dash.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
    }
    
    func gotoAlertScreen() {
        
        let vc = (window?.rootViewController)!
        let user = UserType.Citizen.getTokenUserType(userType: vc.userType)
        if user == .Citizen {
            
            if let nav = window?.rootViewController as? UINavigationController, let dash = nav.viewControllers.first as? DashboardController  {
                
                let notificationViewController = UIStoryboard.init(name: "Notification", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
                //pop till root
                dash.navigationController?.popToRootViewController(animated: true)
                //push
                dash.navigationController?.pushViewController(notificationViewController, animated: true)
            }
        }
    }
    
    func gotoHomeScreen() {
        
        if let nav = window?.rootViewController as? UINavigationController  {
            //pop till root
            nav.popToRootViewController(animated: true)
        }
    }
}


