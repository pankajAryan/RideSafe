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
                UIView.animate(withDuration: 0.3, animations: {
                    self.otpView.isHidden = false
                })
            }.catch { error in
        }
    }
    
    
    private func verifyOtp(mobileNo:String,otp:String) {
        firstly {
            NetworkManager().doServiceCall(serviceType: .verifyOtp, params: ["mobileNumber": mobileNo ,"otp": otp ])
            }.then { response -> () in
               self.writeJSONTo(fileName: "VerifyOTPResponse", data: response)
                self.gotoRegistrationPage()
            }.catch { error in
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
            }.catch { (error) in
        }
    }
    
}

