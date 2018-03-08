//
//  LoginController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 06/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit
import MaterialActivityIndicator

class LoginController: UIViewController {
    
    var model:Register?
    @IBOutlet weak var officialCheckBox: Checkbox!
    @IBOutlet weak var citizenCheckBox: Checkbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        citizenCheckBox.uncheckedBorderColor = .black
        citizenCheckBox.borderStyle = .circle
        citizenCheckBox.checkedBorderColor = .blue
        citizenCheckBox.checkmarkColor = .blue
        citizenCheckBox.checkmarkStyle = .circle
        
        citizenCheckBox.valueChanged = { (value) in
            print("checkbox value change: \(value)")
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
            print("checkbox value change: \(value)")
            if value == true {
                self.citizenCheckBox.isChecked = false
            }
        }
    
    }

    
    @IBAction func btnClicked(_ sender: Any) {
        
        let indicator = MaterialActivityIndicatorView()
        indicator.startAnimating()
        
        NetworkManager().doServiceCall(serviceType: .registerCitizen, params: ["name": "Test","mobile": "9999999999","districtId": "2"]).then { response -> () in
            print(response)
            self.model =   Register(dictionary: (response as NSDictionary))
            }.catch { (error) in
                print(error.localizedDescription)
            }.always {
                indicator.stopAnimating()
        }
    }
}
