//
//  MenuCell.swift
//  sidebarmenu
//
//  Created by Devesh on 11/03/18.
//  Copyright © 2018 __SELF___. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var sideText: UILabel!
    @IBOutlet weak var sideImage: UIImageView!
    var action:SliderActions?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
}
