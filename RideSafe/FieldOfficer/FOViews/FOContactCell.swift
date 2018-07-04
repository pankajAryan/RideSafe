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
    
    func configureCell(contact:FieldOfficer?) {

        number = contact?.mobile ?? ""
        
        let myAttribute1 = [ NSAttributedStringKey.foregroundColor: UIColor(red: 13.0/255.0, green: 68.0/255.0, blue: 152.0/255.0, alpha: 1.0), NSAttributedStringKey.font :  UIFont(name: "Poppins-Medium", size: 16) ]
        let myAttribute2 = [ NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font :  UIFont(name: "Poppins-Medium", size: 12) ]
        
        let myAttrString = NSMutableAttributedString(string: contact?.name ?? "", attributes: myAttribute1)
        
        if let designation = contact?.designation, designation.count > 0 {
            myAttrString.append(NSMutableAttributedString(string: "\nDesignation: "+designation, attributes: myAttribute2))
        }
        
        if let districtName = contact?.districtName, districtName.count > 0 {
            myAttrString.append(NSMutableAttributedString(string: "\nDistrict: "+districtName, attributes: myAttribute2))
        }
        
        if let mobile = contact?.mobile, mobile.count > 0 {
            myAttrString.append(NSMutableAttributedString(string:"\nPh. "+mobile, attributes: myAttribute2))
        }
        
        nameLabel.attributedText = myAttrString;
    }
}
