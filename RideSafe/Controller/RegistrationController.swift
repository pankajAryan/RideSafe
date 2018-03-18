//
//  RegistrationController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 13/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit
import UIDropDown

class RegistrationController: UIViewController {
    
    var phoneNumber = String()
    @IBOutlet weak var district: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var name: UITextField!
    private var selectedDistrictID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDistrict()
        mobileNumber.text = phoneNumber
    }
    
    private func getDistrict() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getDistrictList, params: ["startIndex": "-1","searchString": "",
                                                                                   "length": "10","sortBy": "NAME",
                                                                                   "order": "A","status": "T"])
            }.then { response -> () in
                let json4Swift_Base = DistrictResponse(dictionary: response as NSDictionary)
                let dictList = json4Swift_Base?.responseObject?.districtList
                SharedSettings.shared.districtResponse = json4Swift_Base
                self.makeDropDow(dictList)
                
            }.catch { (error) in
        }
    }
    
    private func makeDropDow(_ dictList: [District]?) {
        let drop = UIDropDown(frame: self.district.frame)
        drop.animationType = .Classic
        drop.hideOptionsWhenSelect = true
        drop.tableHeight = 300
        drop.placeholder = "Select your district..."
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
    
    @IBAction func completeRegistration(_ sender: UIButton) {
        firstly{
            NetworkManager().doServiceCall(serviceType: .registerCitizen, params: ["name": name.text!,"mobile": self.mobileNumber.text!,"districtId": selectedDistrictID])
            }.then { response -> () in
                self.gotodashBoard()
            }.catch { (error) in
        }
    }
    
    private func gotodashBoard() {
        let str =  UIStoryboard(name: "Main", bundle: nil)
        let vc = str.instantiateViewController(withIdentifier: "dashboard") as! DashboardController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
