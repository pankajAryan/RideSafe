//
//  LoginController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 06/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit

class LoginController: UIViewController {
    
    
    @IBOutlet weak var officialCheckBox: Checkbox!
    @IBOutlet weak var citizenCheckBox: Checkbox!
    @IBOutlet weak var otpView: UIStackView!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var otpText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        citizenCheckBox.uncheckedBorderColor = .black
        citizenCheckBox.borderStyle = .circle
        citizenCheckBox.checkedBorderColor = .blue
        citizenCheckBox.checkmarkColor = .blue
        citizenCheckBox.checkmarkStyle = .circle
        
        citizenCheckBox.valueChanged = { (value) in
            if value == true {
                self.officialCheckBox.isChecked = false
            }
        }
        
        officialCheckBox.uncheckedBorderColor = .black
        officialCheckBox.borderStyle = .circle
        officialCheckBox.checkedBorderColor = .blue
        officialCheckBox.checkmarkColor = .blue
        officialCheckBox.checkmarkStyle = .circle
        
        officialCheckBox.valueChanged = { (value) in
            if value == true {
                self.citizenCheckBox.isChecked = false
                
            }
        }
    }
    
    
    @IBAction func btnClicked(_ sender: Any) {
        if self.otpView.isHidden {
            generateOtp(phonNo:mobileNumber.text!)
        } else {
            verifyOtp(mobileNo: mobileNumber.text!, otp: otpText.text!)
        }
    }
    
    private func generateOtp(phonNo:String) {
        firstly {
            NetworkManager().doServiceCall(serviceType: .generateOtp, params: ["phoneNo" : phonNo])
            }.then { response -> () in
                self.showToast(response: response)
                UIView.animate(withDuration: 0.3, animations: {
                    self.otpView.isHidden = false
                    self.submitButton.setTitle("VERIFY OTP", for: .normal)
                })
            }.catch { error in
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

                if verifyResponseObj?.citizenId != nil {
                    _citizenid = verifyResponseObj?.citizenId
                } else if  verifyResponseObj?.fieldOfficialId != nil {
                    _citizenid = verifyResponseObj?.fieldOfficialId
                } else {
                    _citizenid = verifyResponseObj?.escalationOfficialId

                }
                let usertype = verifyResponseObj?.userType
                if let user_type = usertype, let id = _citizenid {
                    UserDefaults.standard.set(id, forKey: UserDefaultsKeys.citizenId.rawValue)
                    UserDefaults.standard.set(user_type, forKey: UserDefaultsKeys.userType.rawValue)
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
        }
    }
    
}

