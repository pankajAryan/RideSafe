//
//  InfraIssueController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 23/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class InfraIssueController: RideSafeViewController {
    
    @IBOutlet weak var recordTable: UITableView!
     var infraIssues:[InfraIssuesForFieldOfficer]?
    
    fileprivate func fetchIssuesForOfficials() {
        NetworkManager().doServiceCall(serviceType: .getRoadInfraIssueListForFieldOfficial, params: ["fieldOfficialId" : citizenId]).then { response -> () in
            self.infraIssues = InfraIssuesListForFieldOfficer(dictionary: response as NSDictionary)?.responseObject
            self.recordTable.reloadData()
            }.catch { error in
                self.showError(error: error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordTable.estimatedRowHeight = 300
        recordTable.rowHeight = UITableViewAutomaticDimension
        fetchIssuesForOfficials()
    }
}
extension InfraIssueController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showNoRecod( infraIssues != nil ? infraIssues!.count == 0 : true, viewOn: tableView)
        if let count = infraIssues?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FODrivingIssueCell") as? FODrivingIssueCell {
            let issue = infraIssues?[indexPath.row]
            cell.uploadedImage.sd_setImage(with: URL(string: (issue?.uploadedImageURL)!), completed: nil)
            cell.decriptionlabel.text = issue?.description
            cell.catagoryLabel.text = issue?.categoryName
            cell.dateLabel.text = issue?.createdOn
            cell.statusLabel.text = issue?.status
            cell.reportedBy.text = issue?.postedByName
            cell.phoneNumber = issue?.postedByMobile ?? ""
            cell.delegate = self
            cell.indexPath = indexPath
            
            if let action = issue?.action, action.count > 0 {
                cell.actionButton.isHidden = false
            } else {
                cell.actionButton.isHidden = true
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension InfraIssueController: FODrivingIssueCellDelegate {
    
    func openMapViewForRowIndex(index: IndexPath) {
        
        return
        
        let issue = infraIssues?[index.row]
        let issueMapViewController: DrivingIssueMapVC = UIStoryboard.init(name: "FOMain", bundle: nil).instantiateViewController(withIdentifier: "DrivingIssueMapVC") as! DrivingIssueMapVC
        issueMapViewController.drivingCaseId = issue?.roadInfraIssueId
        self.navigationController?.pushViewController(issueMapViewController, animated: true)
    }
    
    func showActionForRowIndex(index: IndexPath) {
        let issue = infraIssues?[index.row]
        showAlert(title: "Action Taken", message: issue?.action ?? "")
    }
}
