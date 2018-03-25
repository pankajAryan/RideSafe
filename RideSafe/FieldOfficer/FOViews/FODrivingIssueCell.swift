//
//  FODrivingIssueCell.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 24/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class FODrivingIssueCell: UITableViewCell {

    @IBOutlet weak var vehiclelabel: UILabel!
    @IBOutlet weak var borberView: UIView!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var decriptionlabel: UILabel!
    @IBOutlet weak var catagoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var reportedBy: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var phoneNumber = ""
    var actionTakenNote : String?
    var senderVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
    }
    @IBAction func actionTaken(_ sender: UIButton) {
        
        if let note = actionTakenNote {
            let alert = UIAlertController(title: "Action Taken!", message: note, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            senderVC?.present(alert, animated: true, completion: nil)

        }
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
