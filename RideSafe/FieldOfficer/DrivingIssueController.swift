//
//  DrivingIssueController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 24/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class DrivingIssueController: UIViewController {
    
    @IBOutlet weak var recordTable: UITableView!
    var drivingIssue:[DrivingIssueForFieldOfficial]?
    
    private func showNoRecordView() {
        let norecordView = UINib(nibName: "NoRecord", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        norecordView.frame = self.view.bounds
        self.view.addSubview( norecordView)
    }
    
    fileprivate func fetchIssuesForOfficials() {
        NetworkManager().doServiceCall(serviceType: .getDrivingIssueListForFieldOfficial, params: ["fieldOfficialId" : citizenId]).then { response -> () in
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
            cell.uploadedImage.sd_setImage(with: URL(string: (issue?.uploadedImageURL)!), completed: nil)
            cell.decriptionlabel.text = issue?.description
            cell.catagoryLabel.text = issue?.categoryName
            cell.dateLabel.text = issue?.createdOn
            cell.statusImage.image = issue?.statusImage
            cell.statusLabel.text = issue?.status
            cell.reportedBy.text = issue?.postedByName
            cell.phoneNumber = issue?.postedByMobile ?? ""
            cell.vehiclelabel.text = issue?.vehicleType
            cell.actionTakenNote = issue?.action
            cell.senderVC = self
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