//
//  ReportTableViewCell.swift
//  RideSafe
//
//  Created by Anand Mishra on 23/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

protocol ReportCellDelegate: class {

    func openMapViewForRowIndex(index: IndexPath)
    func showActionForRowIndex(index: IndexPath)
    func showRatingFor(index: IndexPath)
    func reopenIssue(index: IndexPath)
    func makeCall(index: IndexPath)
}

class ReportTableViewCell: UITableViewCell {
    @IBOutlet weak var issueImageView: UIImageView!
    @IBOutlet weak var vehicleNumberLable: UILabel!
    @IBOutlet weak var vehicleDiscriptionLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var reopenButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var statusImageView: UIImageView!

    var indexPath: IndexPath!
    weak var delegate: ReportCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 5.0
        let color = UIColor.init(red: 0.702, green: 0.220, blue: 0.267, alpha: 1.0)
        let attributedTitle = NSAttributedString(string: "Reopen",
                                                 attributes: [NSAttributedStringKey.foregroundColor : color, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13),NSAttributedStringKey.underlineColor : color, NSAttributedStringKey.underlineStyle : NSNumber.init(value: 1)])
        reopenButton.setAttributedTitle(attributedTitle, for: .normal)
    }

    @IBAction func giveFeedBackClicked(_ sender: UIButton) {
        delegate?.showRatingFor(index: indexPath)
    }
    
    @IBAction func navigationButtonClicked(_ sender: Any) {
        delegate?.openMapViewForRowIndex(index: indexPath)
    }
    
    @IBAction func actionClicked(_ sender: Any) {
        delegate?.showActionForRowIndex(index: indexPath)
    }
    @IBAction func reopenIssue(_ sender: UIButton) {
        delegate?.reopenIssue(index: indexPath)
    }
    @IBAction func callDidTap(_ sender: Any) {
        delegate?.makeCall(index: indexPath)
    }
    
}
