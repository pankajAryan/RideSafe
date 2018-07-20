//
//  DrivingIssueController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 24/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import MapKit
import PromiseKit

class DrivingIssueController: RideSafeViewController {
    
    @IBOutlet weak var recordTable: UITableView!
    var drivingIssue:[DrivingIssueForFieldOfficial]?
    
    var heightOfAssignedToButton : CGFloat = 0.0
    var refreshControl = UIRefreshControl()
    var timer: Timer?

    private func showNoRecordView() {
        let norecordView = UINib(nibName: "NoRecord", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        norecordView.frame = self.view.frame
        self.view.addSubview( norecordView)
    }
    
    @objc fileprivate func fetchIssuesForOfficials() {
        var service: ServiceType = .getDrivingIssueListForFieldOfficial
        heightOfAssignedToButton = 0.0
        
        let user = UserType.Citizen.getTokenUserType(userType: self.userType)
        if user == .EscalationOfficial {            
            service = .getDrivingIssueListForEscalationOfficer
            heightOfAssignedToButton = 17.0
        }
        
        NetworkManager().doServiceCall(serviceType: service, params: ["fieldOfficialId" : citizenId], showLoader: false).then { response -> () in
            self.drivingIssue = DrivingIssueListForFieldOfficial(dictionary: response as NSDictionary)?.responseObject
            
            self.refreshControl.endRefreshing()

            if (self.drivingIssue?.count)! > 0 {
                self.recordTable.delegate = self
                self.recordTable.dataSource = self
                self.recordTable.reloadData()
            } else {
                self.showNoRecordView()
            }
            }.catch { error in
                self.showError(error: error)
        }
    }
    
    @objc func timerFuncCallForRefreshDrivingIssue() {
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTable.estimatedRowHeight = 300
        recordTable.rowHeight = UITableViewAutomaticDimension
        RegisterForPushNotification()
        
        // pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(fetchIssuesForOfficials), for: UIControlEvents.valueChanged)
        recordTable.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    func RegisterForPushNotification() {
        var service: ServiceType = .registerFieldOfficialPushNotificationId
        var paramsKey = "fieldOfficialId"
        
        let user = UserType.Citizen.getTokenUserType(userType: self.userType)
        if user == .EscalationOfficial {
            service = .registerEscalationOfficialPushNotificationId
            paramsKey = "escalationOfficialId"
        }
        
        firstly {
            NetworkManager().doServiceCall(serviceType: service, params: [paramsKey: citizenId, "notificationId":  deviceID,"deviceOS" : "iOS"], showLoader: false)
            }.then { [unowned self] response -> () in
                let sresponse =  RegisterCitizenPushNotification.init(dictionary: response as NSDictionary)
                if self.isForceUpdateRequired(for: sresponse?.responseObject?.appVersion) == true {
                    self.showForceUpdateAlert(handler: { (action) in
                        self.launchAppStore()
                    })
                }
            }.catch { (error) in
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchIssuesForOfficials()
        
        timer?.invalidate()
        timer = nil
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchIssuesForOfficials), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer?.invalidate()
        timer = nil
    }
}

extension DrivingIssueController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = drivingIssue?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FODrivingIssueCell") as? FODrivingIssueCell {
            let issue = drivingIssue?[indexPath.row]
            cell.uploadedImage.sd_setImage(with: URL(string: (issue?.uploadedImageURL)!), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            
            cell.vehiclelabel.text = "Vehicle: " + (issue?.vehicleNumber ?? "")
            if let vehicleType = issue?.vehicleType {
                cell.vehiclelabel.text = "\(cell.vehiclelabel.text!) (\(vehicleType))"
            }
            
            if let actionListArray = issue?.actionList, actionListArray.count > 0  {
                cell.actionButton.isHidden = false
            } else {
                cell.actionButton.isHidden = true
            }
            
            cell.decriptionlabel.text = issue?.description
            cell.catagoryLabel.text = issue?.categoryName
            cell.dateLabel.text = issue?.createdOn
            cell.reportedBy.text = issue?.postedByName
            cell.phoneNumber = issue?.postedByMobile ?? ""
            cell.actionTakenNote = issue?.action
            cell.senderVC = self
            cell.delegate = self
            cell.indexPath = indexPath

            if let rating = issue?.rating, rating.count > 0 {
                cell.ratingLabel.text = "Rating: " + rating
            } else {
                cell.ratingLabel.text = "Not Rated "
            }
            
            cell.statusLabel.text = issue?.status

            if issue?.status?.uppercased()  ==  "PENDING" {
                cell.statusImageView.image = #imageLiteral(resourceName: "ic_status_pending")
            }else if issue?.status?.uppercased()  ==  "RESOLVED" {
                cell.statusImageView.image = #imageLiteral(resourceName: "ic_status_resolved")
            }else if issue?.status?.uppercased()  ==  "VOID" {
                cell.statusImageView.image = #imageLiteral(resourceName: "ic_status_void")
            }else{
                cell.statusImageView.image = #imageLiteral(resourceName: "ic_status_pending")
            }
            
            if let updatedByName = issue?.updatedByName, updatedByName.count > 0 {
                
                let myAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font :  UIFont.boldSystemFont(ofSize: 12), NSAttributedStringKey.underlineStyle: 1] as [NSAttributedStringKey : Any]
                
                let myAttrString = NSMutableAttributedString(string:"Assigned To: "+updatedByName, attributes: myAttribute)
                
                cell.assignedToButton.isHidden = false
                cell.assignedToButton.setAttributedTitle(myAttrString, for: .normal)
            } else {
                cell.assignedToButton.isHidden = true
            }
            
            cell.constrains_heightOfAssignedToButton.constant = heightOfAssignedToButton
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = UserType.Citizen.getTokenUserType(userType: self.userType)
        if user == .EscalationOfficial {
           return
        }
        
        let cell = tableView.cellForRow(at: indexPath) as? FODrivingIssueCell
        if let vc = UIStoryboard(name: "FOMain", bundle: nil).instantiateViewController(withIdentifier: "UpdateActionController") as? UpdateActionController {
            vc.uploadedImage = cell?.uploadedImage.image
            vc.drivingIssue = drivingIssue?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension DrivingIssueController: FODrivingIssueCellDelegate {
    
    func openMapViewForRowIndex(index: IndexPath) {
        let issue = drivingIssue?[index.row]
        let issueMapViewController: DrivingIssueMapVC = UIStoryboard.init(name: "FOMain", bundle: nil).instantiateViewController(withIdentifier: "DrivingIssueMapVC") as! DrivingIssueMapVC
        issueMapViewController.drivingCaseId = issue?.drivingIssueId

        self.navigationController?.pushViewController(issueMapViewController, animated: true)
    }
    
    func showActionForRowIndex(index: IndexPath) {
        let issue = drivingIssue?[index.row]

        let issueStatusListVC = UIStoryboard.init(name: "Reports", bundle: nil).instantiateViewController(withIdentifier: "IssueStatusTableVC") as? IssueStatusTableVC
        issueStatusListVC?.actionArray = issue?.actionList
        issueStatusListVC?.title = "Case # \(issue?.drivingIssueId ?? "") - Actions"
        self.navigationController?.pushViewController(issueStatusListVC!, animated: true)
    }
    
    func assignedActionForRowIndex(index: IndexPath) {
        let issue = drivingIssue?[index.row]

        if let phoneNumber = issue?.updatedByMobile {
            if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
