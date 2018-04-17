//
//  NotificationViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 11/04/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit
import SDWebImage
import SafariServices

class NotificationViewController: RideSafeViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    var notificationList: [Notification] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notifications"
        notificationTableView.tableFooterView = UIView()
        notificationTableView.estimatedRowHeight = 464
        notificationTableView.rowHeight = UITableViewAutomaticDimension
        loadData()
        setBackButton()
    }
    
    func loadData() {
        let usrType = userType == "C" ? "Citizen" : "Official"
        firstly{
            NetworkManager().doServiceCall(serviceType: .getNotificationListForUserType, params: ["userType": usrType])
            }.then { response -> () in
                let notificationResponse = NotificationResponse(dictionary: response as NSDictionary)
                let notificationList = notificationResponse?.responseObject
                self.reloadData(notificationList: notificationList!)
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
    @IBAction func linkDidTap(_ sender: UIButton) {
        if let url = URL(string: (sender.titleLabel?.text)!) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true)
        }
    }
    
    func reloadData(notificationList: [Notification]) {
        self.notificationList = notificationList
        notificationTableView.reloadData()
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:NotificationTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCellIDentifier") as! NotificationTableViewCell?)!
        let notification: Notification = self.notificationList[indexPath.row]
        
        cell.notificationLabel.text = notification.title!
        cell.notificationDescriptionLabel.text = notification.description
        cell.notificationDateLabel.text = notification.createdOn
        
        if let linkString = notification.link, linkString.count > 0 {
            cell.linkButton.setTitle(linkString, for: .normal)
            cell.linkButton.isHidden = false
            cell.linkIcon.isHidden = false
        }
        else {
            cell.linkButton.isHidden = true
            cell.linkIcon.isHidden = true
        }
        
        if (notification.imageURL?.count)! > 0 {
        
        cell.notificationImageView.sd_setImage(with: URL(string: notification.imageURL!), placeholderImage: UIImage(named: "placeholder.png"))
            cell.notificationImageHeightConstraint.constant = 150
            
        } else {
            cell.notificationImageHeightConstraint.constant = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
