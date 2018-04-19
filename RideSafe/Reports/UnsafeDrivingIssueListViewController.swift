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
        
        cell.vehicleNumberLable.text = "Vehicle: " + (myDrivingIssue.vehicleNumber ?? "")
        if let vehicleType = myDrivingIssue.vehicleType {
            cell.vehicleNumberLable.text = "\(cell.vehicleNumberLable.text!) (\(vehicleType))".uppercased()
        }
        cell.vehicleDiscriptionLabel.text = myDrivingIssue.description
        cell.tagsLabel.text = myDrivingIssue.categoryName
        cell.dateLabel.text = myDrivingIssue.createdOn
        cell.statusLabel.text = myDrivingIssue.status
        cell.delegate = self
        cell.indexPath = indexPath
        cell.selectionStyle = .none
        
        if let actionListArray = myDrivingIssue.actionList, actionListArray.count > 0  {
            cell.actionButton.isHidden = false
        } else {
            cell.actionButton.isHidden = true
        }
        
        cell.ratingButton.isUserInteractionEnabled = true

        
        if myDrivingIssue.status?.uppercased() == "RESOLVED"   {
            if let rating = myDrivingIssue.rating , rating.count > 0 {
                cell.reopenButton.isHidden = true
                cell.ratingButton.isHidden = false
                cell.ratingButton.setTitle(" ★  " + myDrivingIssue.rating!, for: .normal)
                cell.ratingButton.isUserInteractionEnabled = false
            }
            else {
                cell.ratingButton.isHidden = false
                cell.ratingButton.isUserInteractionEnabled = true
                cell.reopenButton.isHidden = false
            }
        }
        else if myDrivingIssue.status?.uppercased() == "VOID" {
            cell.ratingButton.isHidden = true
            cell.reopenButton.isHidden = false
        }
        else {
            cell.ratingButton.isHidden = true
            
            cell.reopenButton.isHidden = true
        }
        
        cell.issueImageView.sd_setImage(with: URL(string: myDrivingIssue.uploadedImageURL!), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
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
        
        let issueStatusListVC = storyboard?.instantiateViewController(withIdentifier: "IssueStatusTableVC") as? IssueStatusTableVC
        issueStatusListVC?.actionArray = drivingIssue.actionList
        issueStatusListVC?.title = "Case # \(drivingIssue.drivingIssueId ?? "") - Actions"
        self.navigationController?.pushViewController(issueStatusListVC!, animated: true)
    }
    
    func makeCall(index: IndexPath) {
        let drivingIssue: MyDrivingIssueReport = self.myDrivingIssueReportList[index.row]
        
        if let phoneNumber = drivingIssue.updatedByMobile {
            if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func showRatingFor(index: IndexPath) {
        let drivingIssue: MyDrivingIssueReport = self.myDrivingIssueReportList[index.row]
        
        let ratingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RatingController") as! RatingController
        ratingController.drivingIssueId = drivingIssue.drivingIssueId ?? ""
        ratingController.startRating = drivingIssue.rating ?? ""
        
        ratingController.modalPresentationStyle = .overCurrentContext
        ratingController.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(ratingController, animated: true, completion: nil)
    }
    
    func reopenIssue(index: IndexPath) {
        let drivingIssue: MyDrivingIssueReport = self.myDrivingIssueReportList[index.row]
        
        let param = [ "drivingIssueId":drivingIssue.drivingIssueId ?? "",
                      "status": drivingIssue.status ?? "",
                      "action":drivingIssue.action ?? "",
                      "updatedBy":drivingIssue.updatedBy ?? ""
        ]
        
        NetworkManager().doServiceCall(serviceType: .reOpenDrivingIssueByCitizen, params: param).then { response -> () in
            self.showToast(response: response)
            }.catch{ error in
                self.showError(error: error)
        }
    }
}
