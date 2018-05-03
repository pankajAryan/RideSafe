//
//  UpdateActionController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 25/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import UIDropDown

class UpdateActionController: RideSafeViewController {

    @IBOutlet weak var dropDownView: UIDropDown!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var actionTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var catagoryLabel: UILabel!
    @IBOutlet weak var imageUploaded: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var issueStatusStackView: UIStackView!
    @IBOutlet weak var issueUpdateUiContainer: UIView!
    @IBOutlet weak var updateButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var updateButtonheightConstraint: NSLayoutConstraint!
    
    var uploadedImage:UIImage?
    var phoneNumber = ""
    var issueStatus = ""
    
    @IBOutlet weak var callingButton: UIButton!

    var drivingIssue: DrivingIssueForFieldOfficial?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update Action, Case # \(drivingIssue?.drivingIssueId ?? "")"
        self.imageUploaded?.image = uploadedImage
        
        vehicleLabel.text = "Vehicle: " + (drivingIssue?.vehicleNumber ?? "")
        if let vehicleType = drivingIssue?.vehicleType {
            vehicleLabel.text = "\(vehicleLabel.text!) (\(vehicleType))".uppercased()
        }
        
        catagoryLabel.text = drivingIssue?.categoryName
        self.descriptionLabel.text = drivingIssue?.description
        self.dateLabel.text = (drivingIssue?.createdOn)! + " |"
        self.nameLabel.text = drivingIssue?.postedByName
        self.phoneNumber = drivingIssue?.postedByMobile ?? ""

        if let actionListArray = drivingIssue?.actionList, actionListArray.count > 0  {
            actionButton.isHidden = false
        } else {
            actionButton.isHidden = true
        }
        statusLabel.text = drivingIssue?.status
        
        setBackButton()

        let user = UserType.Citizen.getTokenUserType(userType: self.userType)
        if user == .FieldOfficial {
            self.actionTextView.placeholder = "Action Taken"
            self.actionTextView.text = ""
            self.makeDropDow(["PENDING", "VOID", "RESOLVED"])
        }
        else {
            issueUpdateUiContainer.isHidden = true
            updateButton.isHidden = true
            updateButtonBottomConstraint.constant = 0
            updateButtonheightConstraint.constant = 0
        }
    }
    
    private func makeDropDow(_ statusArray: [String]) {

            dropDownView.textColor = UIColor.darkText
            dropDownView.tint = UIColor.clear
            dropDownView.optionsTextColor = UIColor.darkText
            dropDownView.hideOptionsWhenSelect = true
            dropDownView.animationType = .Classic
            dropDownView.tableHeight = 150
            dropDownView.placeholder = "Select Vehicle Type".localized
            dropDownView.options = statusArray
            dropDownView.textAlignment = NSTextAlignment.left
            dropDownView.font = "Poppins-Medium"
            dropDownView.fontSize = 14.0
            dropDownView.optionsFont = "Poppins-Regular"
            dropDownView.optionsSize = 14.0
            dropDownView.borderColor = .clear
            
            dropDownView.didSelect { [unowned self] (option, index) in
                self.issueStatus = option
            }
    }
    
    @IBAction func callClicked(_ sender: UIButton) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func commentClicked(_ sender: UIButton) {
        
        let issueStatusListVC = UIStoryboard.init(name: "Reports", bundle: nil).instantiateViewController(withIdentifier: "IssueStatusTableVC") as? IssueStatusTableVC
        issueStatusListVC?.actionArray = drivingIssue?.actionList
        issueStatusListVC?.title = "Case # \(drivingIssue?.drivingIssueId ?? "") - Actions"
        self.navigationController?.pushViewController(issueStatusListVC!, animated: true)
    }
    
    @IBAction func directionClicked(_ sender: UIButton) {
        
        let issueMapViewController: IssueMapViewController = UIStoryboard.init(name: "Reports", bundle: nil).instantiateViewController(withIdentifier: "IssueMapViewController") as! IssueMapViewController
        issueMapViewController.issueLatitude = ((drivingIssue?.lat)! as NSString).doubleValue
        issueMapViewController.issueLongitude = ((drivingIssue?.lon)! as NSString).doubleValue
        
        self.navigationController?.pushViewController(issueMapViewController, animated: true)

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
