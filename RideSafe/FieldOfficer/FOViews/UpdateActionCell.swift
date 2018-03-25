//
//  UpdateActionCell.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 25/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import UIDropDown

class UpdateActionCell: UITableViewCell {

    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var actionTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageUploaded: UIImageView!
    var phoneNumber = ""
    var issueStatus = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func directionClicked(_ sender: UIButton) {
    }
    @IBAction func updateClicked(_ sender: UIButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
