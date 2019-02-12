//
//  AboutRideSafe.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 13/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import CoreLocation

class AboutRideSafe: RideSafeViewController {

    @IBOutlet weak var lbl_version: UILabel!
    @IBOutlet weak var txt_about: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About RideSafe"
        txt_about.text = "about_app".localized
        setBackButton()
    }
}

