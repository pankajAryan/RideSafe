//
//  TransportCommissionerPopupVC.swift
//  JK RideSafe
//
//  Created by Rahul Chaudhary on 19/02/19.
//  Copyright © 2019 Mobiquel. All rights reserved.
//

import UIKit

class TransportCommissionerPopupVC: UIViewController {

    @IBOutlet weak var view_popupBGView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view_popupBGView.layer.cornerRadius = 5.0
    }
    
    @IBAction func closeBtnAction(sender: UIButton) {
       dismiss(animated: true, completion: nil)
    }
}
