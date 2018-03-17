//
//  MyProfile.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 13/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import UIDropDown

class MyProfile: UIViewController {

    @IBOutlet weak var districtField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var nameFiled: UITextField!
    private var selectedDistrictID:String = ""

    fileprivate func getMyProfileData(citizenId:String) {
         NetworkManager().doServiceCall(serviceType: .getCitizenProfile, params: ["citizenId" : citizenId]).then { (response) -> () in
            let citizenProfile = CitizenProfile(dictionary: response as NSDictionary)
            let citizen = citizenProfile?.responseObject
            self.mobileNumberField.text = citizen?.mobile
            self.nameFiled.text = citizen?.name
            self.selectedDistrictID = citizen?.districtId ?? "no citizen id"
            // self.districtField.text
            let dictList =  SharedSettings.shared.districtResponse?.responseObject?.districtList
            self.makeDropDow(dictList)
            }.catch { (error) in
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        self.title = "My profile"
        retriveJSONFrom(fileName: "VerifyOTPResponse").then { response -> () in
         let citizenid =  VerifyOTPResponse(dictionary: response as NSDictionary)?.responseObject?.citizenId
            if let id = citizenid {
                self.getMyProfileData(citizenId: id)
            }
        }
    }
    
    private func makeDropDow(_ dictList: [District]?) {
        let drop = UIDropDown(frame: self.districtField.frame)
        drop.animationType = .Classic
        drop.hideOptionsWhenSelect = true
        drop.tableHeight = 300
        drop.placeholder = getDistrictName(from: dictList)?.name ?? "no district found"
        var districtNames = [String]()
        for i in dictList! {
            districtNames.append(i.name!)
        }
        drop.options = districtNames
        
        drop.didSelect { (option, index) in
            self.selectedDistrictID = (dictList?[index].districtId)!
        }
        self.view.addSubview(drop)
    }
    
    @IBAction func updateProfile(_ sender: UIButton) {
    }
    
    
    func getDistrictName(from districts:[District]?) -> District? {
      return  districts?.filter { $0.districtId == self.selectedDistrictID } .first
    }
}

extension MyProfile: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
            return true
    }
    
    
}
