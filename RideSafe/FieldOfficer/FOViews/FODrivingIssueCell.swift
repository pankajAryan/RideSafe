//
//  FODrivingIssueCell.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 24/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

protocol FODrivingIssueCellDelegate: class {
    
    func openMapViewForRowIndex(index: IndexPath)
    func showActionForRowIndex(index: IndexPath)
}

class FODrivingIssueCell: UITableViewCell {

    @IBOutlet weak var drivingIssurating: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var vehiclelabel: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var decriptionlabel: UILabel!
    @IBOutlet weak var catagoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reportedBy: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
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
