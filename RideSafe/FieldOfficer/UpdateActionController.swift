//
//  UpdateActionController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 25/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import UIDropDown

class UpdateActionController: UIViewController {

    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var actionTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageUploaded: UIImageView!
    var uploadedImage:UIImage?
    var phoneNumber = ""
    var issueStatus = ""
    
    @IBOutlet weak var pendingRadioButton: Checkbox!
    @IBOutlet weak var resolveRadioButton: Checkbox!
    var drivingIssue: DrivingIssueForFieldOfficial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update Action, Case # \(drivingIssue?.drivingIssueId ?? "")"
        self.imageUploaded?.image = uploadedImage
        self.descriptionLabel.text = drivingIssue?.description
        self.dateLabel.text = drivingIssue?.createdOn
        self.nameLabel.text = drivingIssue?.postedByName
        self.phoneNumber = drivingIssue?.postedByMobile ?? ""
        self.actionTextView.placeholder = "Action Taken"
        self.actionTextView.text = drivingIssue?.action
        self.updateButton.isHidden = drivingIssue?.status?.uppercased() == "PENDING" ? false : true
        self.actionTextView.isEditable = drivingIssue?.status?.uppercased() == "PENDING" ?  true : false
        setBackButton()
        setupUI()
    }
    
    private func setupUI() {
        pendingRadioButton.uncheckedBorderColor = .black
        pendingRadioButton.borderStyle = .circle
        pendingRadioButton.checkedBorderColor = .blue
        pendingRadioButton.checkmarkColor = .blue
        pendingRadioButton.checkmarkStyle = .circle
        
        pendingRadioButton.valueChanged = {[unowned self] (value) in
            if value == true {
                self.resolveRadioButton.isChecked = false
                self.issueStatus = "VOID"
            }
        }
        
        resolveRadioButton.uncheckedBorderColor = .black
        resolveRadioButton.borderStyle = .circle
        resolveRadioButton.checkedBorderColor = .blue
        resolveRadioButton.checkmarkColor = .blue
        resolveRadioButton.checkmarkStyle = .circle
        
        resolveRadioButton.valueChanged = {[unowned self] (value) in
            if value == true {
                self.pendingRadioButton.isChecked = false
                self.issueStatus = "RESOLVED"
                
            }
        }
    }
    
    @IBAction func directionClicked(_ sender: UIButton) {
    }
    @IBAction func updateClicked(_ sender: UIButton) {
        NetworkManager().doServiceCall(serviceType: .updateDrivingIssue, params: [
            "drivingIssueId": (drivingIssue?.drivingIssueId)!,
            "category":(drivingIssue?.category)!,
            "status":issueStatus,
            "action":actionTextView.text,
            "updatedBy":citizenId
            ]).then { (response) -> () in
                self.showToast(response: response)
            }.then { _ in
                self.navigationController?.popViewController(animated: true)
            }.catch { (error) in
                self.showError(error: error)
        }
    }
}
