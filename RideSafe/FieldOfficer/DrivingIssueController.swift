//
//  DrivingIssueController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 24/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import MapKit

class DrivingIssueController: RideSafeViewController {
    
    @IBOutlet weak var recordTable: UITableView!
    var drivingIssue:[DrivingIssueForFieldOfficial]?
    
    private func showNoRecordView() {
        let norecordView = UINib(nibName: "NoRecord", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        norecordView.frame = self.view.frame
        self.view.addSubview( norecordView)
    }
    
    fileprivate func fetchIssuesForOfficials() {
        var service: ServiceType = .getDrivingIssueListForFieldOfficial
        
        let user = UserType.Citizen.getTokenUserType(userType: self.userType)
        if user == .EscalationOfficial {
            guard let escLevel = UserDefaults.standard.string(forKey: UserDefaultsKeys.escalationLevel.rawValue) else { return }

            if escLevel == "1" {
                service = .getDrivingIssueListForEscalationLevel1
            }
            else {
                service = .getDrivingIssueListForEscalationLevel2
            }
        }
        
        NetworkManager().doServiceCall(serviceType: service, params: ["fieldOfficialId" : citizenId]).then { response -> () in
            self.drivingIssue = DrivingIssueListForFieldOfficial(dictionary: response as NSDictionary)?.responseObject
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTable.estimatedRowHeight = 300
        recordTable.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchIssuesForOfficials()
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
                cell.vehiclelabel.text = "\(cell.vehiclelabel.text!) (\(vehicleType))".uppercased()
            }
            
            if let actionListArray = issue?.actionList, actionListArray.count > 0  {
                cell.actionButton.isHidden = false
            } else {
                cell.actionButton.isHidden = true
            }
            
            cell.decriptionlabel.text = issue?.description
            cell.catagoryLabel.text = issue?.categoryName
            cell.dateLabel.text = issue?.createdOn
            cell.statusLabel.text = issue?.status
            cell.reportedBy.text = issue?.postedByName
            cell.phoneNumber = issue?.postedByMobile ?? ""
            cell.actionTakenNote = issue?.action
            cell.senderVC = self
            cell.delegate = self
            cell.indexPath = indexPath
            if let rating = issue?.rating, rating.count > 0 {
                cell.ratingButton.isHidden = false
                cell.ratingButton.setTitle("  Rating: " + rating + " ★  ", for: .normal)
            } else {
                cell.ratingButton.isHidden = true
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        let issueMapViewController: IssueMapViewController = UIStoryboard.init(name: "Reports", bundle: nil).instantiateViewController(withIdentifier: "IssueMapViewController") as! IssueMapViewController
        issueMapViewController.issueLatitude = ((issue?.lat)! as NSString).doubleValue
        issueMapViewController.issueLongitude = ((issue?.lon)! as NSString).doubleValue
        
        for drivingLocation in (issue?.drivingCaseLocationList)! {
            let location: CLLocation = CLLocation.init(latitude: ((drivingLocation.lat)! as NSString).doubleValue, longitude: ((drivingLocation.lon)! as NSString).doubleValue)
            issueMapViewController.locationArray.append(location)
        }
        self.navigationController?.pushViewController(issueMapViewController, animated: true)
    }
    
    func showActionForRowIndex(index: IndexPath) {
        let issue = drivingIssue?[index.row]

        let issueStatusListVC = UIStoryboard.init(name: "Reports", bundle: nil).instantiateViewController(withIdentifier: "IssueStatusTableVC") as? IssueStatusTableVC
        issueStatusListVC?.actionArray = issue?.actionList
        issueStatusListVC?.title = "Case # \(issue?.drivingIssueId ?? "") - Actions"
        self.navigationController?.pushViewController(issueStatusListVC!, animated: true)
    }
}
