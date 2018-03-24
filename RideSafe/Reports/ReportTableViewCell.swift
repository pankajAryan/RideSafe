//
//  ReportTableViewCell.swift
//  RideSafe
//
//  Created by Anand Mishra on 23/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    @IBOutlet weak var issueImageView: UIImageView!
    @IBOutlet weak var vehicleNumberLable: UILabel!
    @IBOutlet weak var vehicleDiscriptionLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pendingImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func navigationButtonClicked(_ sender: Any) {
    }
    
    @IBAction func actionClicked(_ sender: Any) {
    }
    
}
