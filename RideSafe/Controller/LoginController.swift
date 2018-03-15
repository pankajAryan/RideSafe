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
                let data  = VerifyOTPResponse(dictionary: response as NSDictionary)
                
                
                if let theJSONData = try? JSONSerialization.data(withJSONObject: response,options: []) {
                        let theJSONText = String(data: theJSONData,encoding: .ascii)
                        print("JSON string = \(theJSONText!)")
                    if let json = theJSONText {
                         self.write(text: json, to: "VerifyOTPJSON")
                    }
                  
                }
               
                
                self.gotoRegistrationPage()
            }.catch { error in
        }
    }
    
    func write(text: String, to fileNamed: String, folder: String = "verifyotpresponse") {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        guard let writePath = NSURL(fileURLWithPath: path).appendingPathComponent(folder) else { return }
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed + ".json")
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
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

