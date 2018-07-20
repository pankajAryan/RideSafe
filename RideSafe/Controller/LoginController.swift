//
//  LoginController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 06/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit

class LoginController: RideSafeViewController {

    @IBOutlet weak var otpView: UIStackView!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var otpText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnClicked(_ sender: Any) {
        if self.otpView.isHidden {
            generateOtp(phonNo:mobileNumber.text!)
        } else {
            verifyOtp(mobileNo: mobileNumber.text!, otp: otpText.text!)
        }
    }
    
    private func generateOtp(phonNo:String) {
        if (mobileNumber.text?.count)! < 10 {
            showAlert(message: "Please enter valid mobile number")
            return
        }
        firstly {
            NetworkManager().doServiceCall(serviceType: .generateOtp, params: ["phoneNo" : phonNo])
            }.then { response -> () in
                self.showToast(response: response)
                UIView.animate(withDuration: 0.3, animations: {
                    self.otpView.isHidden = false
                    self.otpText.becomeFirstResponder()
                    self.otpView.layoutIfNeeded()
                    self.submitButton.setTitle("VERIFY OTP", for: .normal)
                })
            }.catch { error in
                self.showError(error: error)
        }
    }
    
    
    private func verifyOtp(mobileNo:String,otp:String) {
        firstly {
            NetworkManager().doServiceCall(serviceType: .verifyOtp, params: ["mobileNumber": mobileNo ,"otp": otp ])
            }.then { response -> () in
                
                self.showToast(response: response)
                self.writeJSONTo(fileName: FileNames.response.rawValue, data: response)
                let verifyResponseObj = VerifyOTPResponse(dictionary: response as NSDictionary)?.responseObject
                
                var _citizenid: String?

                if verifyResponseObj?.citizenId != nil, (verifyResponseObj?.citizenId?.count)! > 0 {
                    _citizenid = verifyResponseObj?.citizenId
                } else if verifyResponseObj?.fieldOfficialId != nil, (verifyResponseObj?.fieldOfficialId?.count)! > 0 {
                    _citizenid = verifyResponseObj?.fieldOfficialId
                } else if verifyResponseObj?.escalationOfficialId != nil, (verifyResponseObj?.escalationOfficialId?.count)! > 0 {
                    _citizenid = verifyResponseObj?.escalationOfficialId
                }
                
                let usertype = verifyResponseObj?.userType
                if let user_type = usertype, let id = _citizenid {
                    UserDefaults.standard.set(id, forKey: UserDefaultsKeys.citizenId.rawValue)
                    UserDefaults.standard.set(user_type, forKey: UserDefaultsKeys.userType.rawValue)
                    if let token = verifyResponseObj?.token {
                        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.token.rawValue)
                    }
                    
                    if verifyResponseObj?.escalationLevel != nil, (verifyResponseObj?.escalationLevel?.count)! > 0 {
                        UserDefaults.standard.set(verifyResponseObj?.escalationLevel, forKey: UserDefaultsKeys.escalationLevel.rawValue)
                    }
                    
                    UserDefaults.standard.synchronize()
                }
                verifyResponseObj?.isRegistered == "T" ? self.gotoDashboard() : self.gotoRegistrationPage()
                
            }.catch { error   in
                self.showError(error: error)
        }
    }
    
    private func gotoDashboard() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isUserLogedin.rawValue)
        UserDefaults.standard.synchronize()

        let delegate =  UIApplication.shared.delegate as! AppDelegate
        if  delegate.getuserType() == .Citizen {
            let str =  UIStoryboard(name: "Main", bundle: nil)
            let vc = str.instantiateViewController(withIdentifier: "dashboard") as! DashboardController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let str =  UIStoryboard(name: "FOMain", bundle: nil)
            let vc = str.instantiateViewController(withIdentifier: "FODashboardController") as! FODashboardController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func gotoRegistrationPage() {
        let str =  UIStoryboard(name: "Main", bundle: nil)
        let vc = str.instantiateViewController(withIdentifier: "RegistrationController") as! RegistrationController
        vc.phoneNumber = mobileNumber.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func resendOTP(_ sender: UIButton) {
        firstly{
            NetworkManager().doServiceCall(serviceType: .resendOtp, params: ["phoneNo" : mobileNumber.text!])
            }.then { (response) -> () in
                self.showToast(response: response)
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
}

extension LoginController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mobileNumber {
            
            let newString = textField.text! + string
            if newString.count > 10 {
                return false
            }
            
            if otpView.isHidden == false {
                UIView.animate(withDuration: 0.3, animations: {
                    self.otpView.isHidden = true
                    self.submitButton.setTitle("NEXT", for: .normal)
                    self.otpText.text = ""
                })
            }
        } else if textField == otpText {
                let maxLength = 4
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
        }
        
        return true
    }
}

