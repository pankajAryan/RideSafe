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
    
    func readFileFromBundle() {
        func loadJson(filename fileName: String) -> [String: Any]? {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let dictionary = object as? [String: Any] {
                        return dictionary
                    }
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            return nil
        }
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


