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
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 4.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func phoneButtonClicked(_ sender: Any) {
    }
    
}
