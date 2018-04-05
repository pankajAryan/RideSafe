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

    private func showNoRecordView() {
        let norecordView = UINib(nibName: "NoRecord", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        norecordView.frame = self.view.bounds
        self.view.addSubview( norecordView)
    }
    
    fileprivate func fetchIssuesForOfficials() {
        NetworkManager().doServiceCall(serviceType: .getRoadInfraIssueListForFieldOfficial, params: ["fieldOfficialId" : citizenId]).then { response -> () in
            self.infraIssues = InfraIssuesListForFieldOfficer(dictionary: response as NSDictionary)?.responseObject
            self.recordTable.reloadData()

//            if (self.infraIssues?.count)! > 0 {
//                self.recordTable.delegate = self
//                self.recordTable.dataSource = self
//                self.recordTable.reloadData()
//            } else {
//                self.showNoRecordView()
//            }
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

            cell.resolvedStatusImageView.image = #imageLiteral(resourceName: "radio")
            cell.voidstatusImageView.image = #imageLiteral(resourceName: "radio")

            if issue?.status == "RESOLVED" {
                cell.resolvedStatusImageView.image = #imageLiteral(resourceName: "radio_on")
            } else if issue?.status == "VOID" {
                cell.voidstatusImageView.image = #imageLiteral(resourceName: "radio_on")
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
        let issue = infraIssues?[index.row]
        let issueMapViewController: IssueMapViewController = UIStoryboard.init(name: "Reports", bundle: nil).instantiateViewController(withIdentifier: "IssueMapViewController") as! IssueMapViewController
        issueMapViewController.issueLatitude = ((issue?.lat)! as NSString).doubleValue
        issueMapViewController.issueLongitude = ((issue?.lon)! as NSString).doubleValue
        self.navigationController?.pushViewController(issueMapViewController, animated: true)
    }
    
}
