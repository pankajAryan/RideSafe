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

class RideSafeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UIViewController {
    
    func setBackButton() {
        let leftButton = UIButton(type: .custom)
        leftButton.frame = CGRect(origin: .zero, size: CGSize(width: 44, height: 34))
        leftButton.addTarget(self, action: #selector(leftButtonClicked), for: .touchUpInside)
       leftButton.setImage(#imageLiteral(resourceName: "icn_back"), for: .normal)
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
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
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
    
    
    func showError(error:Error) {
        if  error is CustomError {
            self.showAlert(message: (error as! CustomError).errorMessage)
        } else {
            // handle error
        }
    }
    
    
    func clearUserDefault() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isUserLogedin.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.citizenId.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userType.rawValue)
    }
    
    var citizenId:String {
        get {
            guard let citizenId = UserDefaults.standard.string(forKey: UserDefaultsKeys.citizenId.rawValue) else { return "" }
            return citizenId
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
           return  UIDevice.current.identifierForVendor!.uuidString
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

enum UserType {
    case Citizen
    case Official
}



