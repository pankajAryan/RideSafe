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
    
    func setBackButton(){
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "emergency")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "emergency")
    }
    
    func showActivityIndicator() {
        SwiftLoader.show(animated: true)
    }
    
    func hideActivityIndicator() {
        SwiftLoader.hide()
    }
}


