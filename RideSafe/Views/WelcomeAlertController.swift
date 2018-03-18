//
//  WelcomeAlertController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 18/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class WelcomeAlertController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    @IBAction func okClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
