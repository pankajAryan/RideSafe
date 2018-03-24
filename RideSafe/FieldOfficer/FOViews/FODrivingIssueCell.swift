//
//  FODrivingIssueCell.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 24/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class FODrivingIssueCell: UITableViewCell {

    @IBOutlet weak var borberView: UIView!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var decriptionlabel: UILabel!
    @IBOutlet weak var catagoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var reportedBy: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var phoneNumber = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    @IBAction func callReporter(_ sender: UIButton) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
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
