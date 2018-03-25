//
//  FOContactCell.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 24/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class FOContactCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var numberbtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var number = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 4
        self.selectionStyle = .none
    }

    @IBAction func dialNumber(_ sender: UIButton) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
