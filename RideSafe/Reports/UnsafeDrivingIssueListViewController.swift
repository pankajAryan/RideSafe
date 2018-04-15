//
//  UnsafeDrivingIssueListViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 23/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit

class UnsafeDrivingIssueListViewController: RideSafeViewController {

    @IBOutlet weak var unsafeDrivingIssueTableView: UITableView!
    var myDrivingIssueReportList: [MyDrivingIssueReport] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        unsafeDrivingIssueTableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCellIdentifier")
        unsafeDrivingIssueTableView.tableFooterView = UIView()
        unsafeDrivingIssueTableView.estimatedRowHeight = 464
        unsafeDrivingIssueTableView.rowHeight = UITableViewAutomaticDimension

        loadData()
    }

    func loadData() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getCitizenDrivingIssueList, params: ["citizenId": citizenId])
            }.then { response -> () in
                let myDrivingIssueReportResponse = MyDrivingIssueReportResponse(dictionary: response as NSDictionary)
                let myDrivingIssueList = myDrivingIssueReportResponse?.responseObject
                self.reloadData(myDrivingIssueList: myDrivingIssueList!)
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
    func reloadData(myDrivingIssueList: [MyDrivingIssueReport]) {
        self.myDrivingIssueReportList = myDrivingIssueList
        unsafeDrivingIssueTableView.reloadData()
    }
}


extension UnsafeDrivingIssueListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myDrivingIssueReportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReportTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCellIdentifier") as! ReportTableViewCell?)!
        let myDrivingIssue: MyDrivingIssueReport = self.myDrivingIssueReportList[indexPath.row]
        
        cell.vehicleNumberLable.text = "Vehicle: " + myDrivingIssue.vehicleNumber!
        cell.vehicleDiscriptionLabel.text = myDrivingIssue.description
        cell.tagsLabel.text = myDrivingIssue.categoryName
        cell.dateLabel.text = myDrivingIssue.createdOn
        cell.statusLabel.text = myDrivingIssue.status
        cell.delegate = self
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        
        if myDrivingIssue.action?.count == 0 {
            cell.actionButton.isHidden = true
        }
        
//        if myDrivingIssue.status == "RESOLVED" {
//            cell.resolvedStatusImageView.image = #imageLiteral(resourceName: "radio_on")
//            cell.voidstatusImageView.image = #imageLiteral(resourceName: "radio")
//        } else if myDrivingIssue.status == "VOID" {
//            cell.resolvedStatusImageView.image = #imageLiteral(resourceName: "radio")
//            cell.voidstatusImageView.image = #imageLiteral(resourceName: "radio_on")
//        } else {
//            cell.resolvedStatusImageView.image = #imageLiteral(resourceName: "radio")
//            cell.voidstatusImageView.image = #imageLiteral(resourceName: "radio")
//        }
        
        cell.issueImageView.sd_setImage(with: URL(string: myDrivingIssue.uploadedImageURL!), placeholderImage: UIImage(named: "placeholder.png"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension UnsafeDrivingIssueListViewController: ReportCellDelegate {
    func openMapViewForRowIndex(index: IndexPath) {
        
        let drivingIssue: MyDrivingIssueReport = self.myDrivingIssueReportList[index.row]

        let issueMapViewController: IssueMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "IssueMapViewController") as! IssueMapViewController
        issueMapViewController.issueLatitude = (drivingIssue.lat! as NSString).doubleValue
        issueMapViewController.issueLongitude = (drivingIssue.lon! as NSString).doubleValue
        
        self.navigationController?.pushViewController(issueMapViewController, animated: true)
    }
    
    func showActionForRowIndex(index: IndexPath) {
        let drivingIssue: MyDrivingIssueReport = self.myDrivingIssueReportList[index.row]

        showAlert(title: "Action Taken", message: drivingIssue.action!)
    }
    
    
}
