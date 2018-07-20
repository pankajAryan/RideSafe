//
//  RideSafeViewController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 13/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit
import Toast_Swift
import Alamofire

class RideSafeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Poppins-Medium", size: 16)!]
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        setBackgroundImage()
    }
    
    private func setBackgroundImage() {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = #imageLiteral(resourceName: "form_bg")
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
    }
    
    func checkRechability() -> Bool {
        let reachabilityManager = NetworkReachabilityManager()
        var status = false
        reachabilityManager?.startListening()
        reachabilityManager?.listener = { _ in
            if let isNetworkReachable = reachabilityManager?.isReachable,
                isNetworkReachable == true {
                //Internet Available
                status = true
                
            } else {
                //Internet Not Available"
               status = false
            }
        }
        return status
    }
    
}

extension UIViewController {
    
    func setBackButton() {
        let leftButton = UIButton(type: .custom)
        leftButton.frame = CGRect(origin: .zero, size: CGSize(width: 44, height: 34))
        leftButton.addTarget(self, action: #selector(leftButtonClicked), for: .touchUpInside)
       leftButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        leftButton.contentHorizontalAlignment = .left
        leftButton.contentVerticalAlignment = .center
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
   @objc func leftButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func writeJSONTo(fileName:String,data:Any) {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let fileUrl = documentDirectoryUrl.appendingPathComponent( fileName + ".json")
        do {
            print("file url is:",fileUrl)
            let data = try JSONSerialization.data(withJSONObject: data, options: [])
            try  data.write(to: fileUrl, options: [])
        } catch{
            print(error)
        }
    }
    
    func retriveJSONFrom(fileName:String) -> Promise<[String:Any]> {
        return  Promise { fulfill, reject in
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName + ".json")
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                guard let content =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return }
                fulfill(content)
            } catch{
                reject(error)
            }
        }
    }
    
}

extension UIViewController {
    
    
    func showToast(response:[String:Any]) {
          self.view.makeToast(response["errorMessage"] as? String, duration: 3.0, position: .bottom)
    }
    
    func showToast(message:String) {
        self.view.makeToast(message, duration: 3.0, position: .bottom)
    }
    
   
    func showAlert(title: String = "", message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message:String ,handler:((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "YES", style: .default, handler: handler)
        let dismissAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        alert.addAction(actionButton)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showForceUpdateAlert(handler:((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "", message: "We released a much improved version of the RideSafe app. To continue using RideSafe, Please update the app.", preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "Go To AppStore", style: .default, handler: handler)
        alert.addAction(actionButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(error:Error) {
        if  error is CustomError {
            let rideSafeError = error as! CustomError
            if rideSafeError.errorCode == "2" {
                // Logout
                self.clearUserDefault()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginController = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                DispatchQueue.main.async {
                    self.navigationController?.viewControllers = [loginController]
                    self.showAlert(message: "Invalid Access! You are logged out.") //(error as! CustomError).errorMessage
                }
            }
            else {
                self.showAlert(message: (error as! CustomError).errorMessage)
            }
        } else {
            self.showAlert(message: "Something went wrong with the request, please try again later.")
        }
    }
    
    
    func clearUserDefault() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isUserLogedin.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.citizenId.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userType.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.token.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.escalationLevel.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    var citizenId:String {
        get {
            guard let citizenId = UserDefaults.standard.string(forKey: UserDefaultsKeys.citizenId.rawValue) else { return "" }
            return citizenId
        }
    }
    
    var token:String {
        get {
            guard let token = UserDefaults.standard.string(forKey: UserDefaultsKeys.token.rawValue) else { return "" }
            return token
        }
    }
    
    var userType:String {
        get {
            guard let usertype = UserDefaults.standard.string(forKey: UserDefaultsKeys.userType.rawValue) else { return "" }
            return usertype
        }
    }
    
    var selectedLanguage:String {
        get {
             return UserDefaults.standard.string(forKey: Localization.selectedLanguage.rawValue) ?? "E"
        }
    }
    
    var deviceID:String {
        get {
            return UserDefaults.standard.string(forKey: "DeviceToken") ?? ""
        }
    }
}

extension UIImage {
    var jpegRepresentationData: Data? {
        return UIImageJPEGRepresentation(self, 1.0)
    }
}

enum RootController {
    case Dashboard
    case Login
}

enum UserType: String {
    case Citizen            = "citizen"
    case FieldOfficial      = "field_official"
    case Official           = "official"
    case EscalationOfficial = "escalation_official"
    case none               = ""
    
    func getTokenUserType(userType: String) -> UserType {
        switch userType {
        case "C":
            return .Citizen
        case "F":
            return .FieldOfficial
        case "E":
            return .EscalationOfficial
        case "O":
            return .Official
        default:
            return .none
        }
    }
}



