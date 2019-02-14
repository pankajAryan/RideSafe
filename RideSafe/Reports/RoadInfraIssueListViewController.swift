//
//  RoadInfraIssueListViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 23/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit

class RoadInfraIssueListViewController: RideSafeViewController {

    @IBOutlet weak var roadInfraIssueTableView: UITableView!
    var myRoadInfraIssuesList: [MyRoadInfraIssue] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.roadInfraIssueTableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCellIdentifier")
        roadInfraIssueTableView.tableFooterView = UIView()
        roadInfraIssueTableView.estimatedRowHeight = 464
        roadInfraIssueTableView.rowHeight = UITableViewAutomaticDimension

        loadData()
    }

    func loadData() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getCitizenRoadInfraIssueList, params: ["citizenId": citizenId])
            }.then { response -> () in
                let myRoadInfraIssueResponse = MyRoadInfraIssueResponse(dictionary: response as NSDictionary)
                let myRoadInfraIssueList = myRoadInfraIssueResponse?.responseObject
                self.reloadData(myRoadInfraIssues: myRoadInfraIssueList!)
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
    func reloadData(myRoadInfraIssues: [MyRoadInfraIssue]) {
        self.myRoadInfraIssuesList = myRoadInfraIssues
        roadInfraIssueTableView.reloadData()
    }
}

extension RoadInfraIssueListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showNoRecod(myRoadInfraIssuesList.count == 0, viewOn: tableView)
        return self.myRoadInfraIssuesList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ReportTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCellIdentifier") as! ReportTableViewCell?)!
        let myRoadInfraIssue: MyRoadInfraIssue = self.myRoadInfraIssuesList[indexPath.row]
        
        cell.vehicleNumberLable.text = ""
        cell.vehicleDiscriptionLabel.text = myRoadInfraIssue.description
        cell.tagsLabel.text = myRoadInfraIssue.categoryName
        cell.dateLabel.text = myRoadInfraIssue.createdOn
        cell.statusLabel.text = (myRoadInfraIssue.status ?? "").uppercased().localized
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.callButton.isHidden = true

        cell.ratingButton.isHidden = true
        cell.ratingButton.isUserInteractionEnabled = false
        cell.reopenButton.isHidden = true

        if myRoadInfraIssue.status?.uppercased()  ==  "RESOLVED" {
            cell.statusImageView.image = #imageLiteral(resourceName: "ic_status_resolved")
            cell.reopenButton.isHidden = false
            cell.ratingButton.isHidden = false
            cell.ratingButton.isUserInteractionEnabled = true
        }else if myRoadInfraIssue.status?.uppercased()  ==  "VOID" {
            cell.statusImageView.image = #imageLiteral(resourceName: "ic_status_void")
            cell.reopenButton.isHidden = false
        }else{
            cell.statusImageView.image = #imageLiteral(resourceName: "ic_status_pending")
        }
        
        cell.issueImageView.sd_setImage(with: URL(string: myRoadInfraIssue.uploadedImageURL!), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


extension RoadInfraIssueListViewController: ReportCellDelegate {
    
    func openMapViewForRowIndex(index: IndexPath) {
        
        let myRoadInfraIssue: MyRoadInfraIssue = self.myRoadInfraIssuesList[index.row]

        let issueMapViewController: IssueMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "IssueMapViewController") as! IssueMapViewController
        issueMapViewController.issueLatitude = (myRoadInfraIssue.lat! as NSString).doubleValue
        issueMapViewController.issueLongitude = (myRoadInfraIssue.lon! as NSString).doubleValue
        issueMapViewController.postedByName = myRoadInfraIssue.postedByName
        self.navigationController?.pushViewController(issueMapViewController, animated: true)
    }
    
    func showActionForRowIndex(index: IndexPath) {
        let myRoadInfraIssue: MyRoadInfraIssue = self.myRoadInfraIssuesList[index.row]
        
        if let actionListArray = myRoadInfraIssue.action, actionListArray == ""  {
            showAlert(title: "Action Taken", message: "No Action has been taken yet!")
        } else {
            showAlert(title: "Action Taken", message: myRoadInfraIssue.action ?? "")
        }
    }
    
    func makeCall(index: IndexPath) {
        let myRoadInfraIssue: MyRoadInfraIssue = self.myRoadInfraIssuesList[index.row]

        if let phoneNumber = myRoadInfraIssue.postedByMobile {
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
    }
    
    func reopenIssue(index: IndexPath) {
    }
}
