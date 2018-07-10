//
//  FODrivingIssueCell.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 24/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

@objc protocol FODrivingIssueCellDelegate: class {
    
    func openMapViewForRowIndex(index: IndexPath)
    func showActionForRowIndex(index: IndexPath)
    @objc optional func assignedActionForRowIndex(index: IndexPath)

}

class FODrivingIssueCell: UITableViewCell {

    @IBOutlet weak var vehiclelabel: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var decriptionlabel: UILabel!
    @IBOutlet weak var catagoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reportedBy: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var assignedToButton: UIButton!

    @IBOutlet weak var constrains_heightOfAssignedToButton: NSLayoutConstraint!

    var phoneNumber = ""
    var actionTakenNote : String?
    var senderVC: UIViewController?
    
    var indexPath: IndexPath!
    weak var delegate: FODrivingIssueCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
    }
    @IBAction func directionClicked(_ sender: UIButton) {
        delegate?.openMapViewForRowIndex(index: indexPath)
    }
    
    @IBAction func actionTaken(_ sender: UIButton) {
        
        delegate?.showActionForRowIndex(index: indexPath)
    }
    
    @IBAction func assignedAction(_ sender: UIButton) {
        
        delegate?.assignedActionForRowIndex!(index: indexPath)
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

}
