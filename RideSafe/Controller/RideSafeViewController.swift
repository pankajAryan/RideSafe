//
//  RideSafeViewController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 13/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class RideSafeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension UIViewController {
    
    func setBackButton() {
        let leftButton = UIButton(type: .custom)
        leftButton.frame = CGRect(origin: .zero, size: CGSize(width: 44, height: 34))
        leftButton.addTarget(self, action: #selector(leftButtonClicked), for: .touchUpInside)
       leftButton.setImage(#imageLiteral(resourceName: "emergency"), for: .normal)
        leftButton.contentHorizontalAlignment = .left
        leftButton.contentVerticalAlignment = .center
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)

    }
    
   @objc func leftButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
}


