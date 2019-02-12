//
//  MyProfile.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 13/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import UIDropDown
import PromiseKit

class MyProfile: RideSafeViewController {

    @IBOutlet weak var districtField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var nameFiled: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    private var selectedDistrictID:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        self.title = "My profile".localized
        getDistrict()
    }
    
    fileprivate func getMyProfileData(citizenId:String) {
        NetworkManager().doServiceCall(serviceType: .getCitizenProfile, params: ["citizenId" : citizenId]).then { (response) -> () in
            let citizenProfile = CitizenProfile(dictionary: response as NSDictionary)
            let citizen = citizenProfile?.responseObject
            self.mobileNumberField.text = citizen?.mobile
            self.nameFiled.text = citizen?.name
            self.selectedDistrictID = citizen?.districtId ?? "no district"
            let dictList =  SharedSettings.shared.districtResponse?.responseObject
            self.makeDropDow(dictList)
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
    private func getDistrict() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getDistrictList, params: ["startIndex": "-1","searchString": "",
                                                                                   "length": "10","sortBy": "NAME",
                                                                                   "order": "A","status": "T"])
            }.then { response -> () in
                let json4Swift_Base = DistrictResponse(dictionary: response as NSDictionary)
                SharedSettings.shared.districtResponse = json4Swift_Base
            }.then { () -> () in
                self.getMyProfileData(citizenId: self.citizenId)
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
    private func makeDropDow(_ dictList: [District]?) {
        
        let frm = self.districtField.superview?.convert(self.districtField.frame, to: scrollView)
        let drop = UIDropDown(frame: frm!)
        drop.animationType = .Classic
        drop.hideOptionsWhenSelect = true
        drop.tableHeight = 100
        drop.font = "Poppins-Medium"
        drop.fontSize = 14.0
        drop.optionsFont = "Poppins-Regular"
        drop.optionsSize = 14.0
        drop.borderColor = .white
        drop.placeholder = getDistrictName(from: dictList)?.name ?? "Select your district"
        
        var districtNames = [String]()
        for i in dictList! {
            districtNames.append(i.name!)
        }
        drop.options = districtNames
        
        drop.didSelect { (option, index) in
            self.selectedDistrictID = (dictList?[index].districtId)!
        }
        self.scrollView.addSubview(drop)
    }
    
    @IBAction func updateProfile(_ sender: UIButton) {
        NetworkManager().doServiceCall(serviceType: .updateCitizenProfile, params: ["citizenId": citizenId, "name": nameFiled.text!,"districtId": selectedDistrictID]).then { response -> () in
            self.navigationController?.showToast(response: response)
            self.navigationController?.popViewController(animated: true)
            }.catch { (error) in
                self.showError(error: error)
        }
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
