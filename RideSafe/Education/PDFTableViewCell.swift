//
//  PDFTableViewCell.swift
//  RideSafe
//
//  Created by Anand Mishra on 17/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class PDFTableViewCell: UITableViewCell {

    @IBOutlet weak var pdfIconImageView: UIImageView!
    @IBOutlet weak var pdfTitleLabel: UILabel!
    @IBOutlet weak var pdfDateLabel: UILabel!
    @IBOutlet weak var pdfDiscription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
