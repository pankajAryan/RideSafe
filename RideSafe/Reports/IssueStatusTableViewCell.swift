//
//  IssueStatusTableViewCell.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 19/04/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class IssueStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var updatedByLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
