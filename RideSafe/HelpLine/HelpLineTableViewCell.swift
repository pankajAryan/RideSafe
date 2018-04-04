//
//  HelpLineTableViewCell.swift
//  RideSafe
//
//  Created by Anand Mishra on 17/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class HelpLineTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationNameLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    var phoneNumber: String!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func phoneButtonClicked(_ sender: Any) {
        if let url = URL(string: "tel://\(String(describing: phoneNumber!))") {
            UIApplication.shared.open(url)
        }
    }
    
}
