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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
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
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//
//        // TODO: If necessary send token to application server.
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }

}
