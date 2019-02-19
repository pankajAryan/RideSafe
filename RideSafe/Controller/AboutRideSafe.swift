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
    @IBOutlet weak var lbl_headingText: UILabel!
    @IBOutlet weak var txt_about: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About App".localized
        txt_about.text = "about_app".localized
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        lbl_version.text = "Version".localized+": "+appVersion!
        lbl_headingText.text = "Power to prevent accidents now in your hands!".localized

        setBackButton()
    }
}

