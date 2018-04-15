//
//  FOMyProfileController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 05/04/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class FOMyProfileController: RideSafeViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var designation: UITextField!
    @IBOutlet weak var department: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Official Profile"
        getMyProfileData(citizenId: citizenId)
        setBackButton()
    }
    
    fileprivate func getMyProfileData(citizenId:String) {
        NetworkManager().doServiceCall(serviceType: .getFieldOfficialById, params: ["fieldOfficialId" : citizenId]).then { (response) -> () in
            let foProfile = FieldOfficialProfileResponse(dictionary: response as NSDictionary)?.responseObject
            self.mobile.text = foProfile?.mobile
            self.fullName.text = foProfile?.name
            self.designation.text =  foProfile?.designation
            self.department.text =  foProfile?.departmentName
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
    
}
