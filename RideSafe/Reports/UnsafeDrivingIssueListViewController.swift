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
    
    func reOpenDrivingIssueByCitizen (index: IndexPath, msg : String?) {
        
        let drivingIssue: MyDrivingIssueReport = self.myDrivingIssueReportList[index.row]
        
        let param = [ "drivingIssueId":drivingIssue.drivingIssueId ?? "",
                      "status": "REOPEN",
                      "action": msg ?? "",
                      "updatedBy":drivingIssue.updatedBy ?? ""
        ]
        
        NetworkManager().doServiceCall(serviceType: .reOpenDrivingIssueByCitizen, params: param).then { response -> () in
            self.showToast(response: response)
            self.loadData()
            }.catch{ error in
                self.showError(error: error)
        }
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
            cell.vehicleNumberLable.text = "\(cell.vehicleNumberLable.text!) (\(vehicleType))"
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
        
        cell.ratingButton.isHidden = true
        cell.ratingButton.isUserInteractionEnabled = false
        cell.reopenButton.isHidden = true

        if myDrivingIssue.status?.uppercased() == "RESOLVED"   {
            
            cell.statusImageView.image = #imageLiteral(resourceName: "ic_status_resolved")

            cell.ratingButton.isHidden = false
            cell.reopenButton.isHidden = false

            if let rating = myDrivingIssue.rating , rating.count > 0 {
                cell.ratingButton.setTitle("  Rating: " + myDrivingIssue.rating! + " ★  ", for: .normal)
                cell.ratingButton.isUserInteractionEnabled = false
            }
            else {
                cell.ratingButton.isUserInteractionEnabled = true
            }
        }
        else if myDrivingIssue.status?.uppercased() == "VOID" {
            cell.statusImageView.image = #imageLiteral(resourceName: "ic_status_void")
            cell.ratingButton.isHidden = true
            cell.reopenButton.isHidden = false
        }
        else {
            cell.statusImageView.image = #imageLiteral(resourceName: "ic_status_pending")
            cell.ratingButton.isHidden = true
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
        issueMapViewController.postedByName = drivingIssue.postedByName
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
        
        let alert = UIAlertController(title: "", message: "Enter message!", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "enter message"
        }
        
        alert.addAction(UIAlertAction(title: "RE-OPEN", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
           
            self.reOpenDrivingIssueByCitizen(index: index, msg: textField?.text)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
