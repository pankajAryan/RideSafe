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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
