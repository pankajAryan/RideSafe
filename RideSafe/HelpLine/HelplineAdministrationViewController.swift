//
//  HelplineAdministrationViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 15/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit

class HelplineAdministrationViewController: RideSafeViewController {

    @IBOutlet weak var helpLineTableView: UITableView!
    var mvdDirectoryList:[Directory] = []
    var administrationDirectoryList: [Directory] = []
    var policeDirectoryList: [Directory] = []
    var selectedSegmented:Int = 0
    var districId:String? = "4"
    @IBOutlet weak var noRecordShowLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helpLineTableView.tableFooterView = UIView()
    }
    
    func loadData() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getDepartmentDirectoryListByDepartment, params: ["department": "Administration", "districtId": districId!])
            }.then { response -> Promise<[String:Any]> in
                let directoryResponse = DirectoryResponse(dictionary: response as NSDictionary)
                self.administrationDirectoryList = (directoryResponse?.responseObject)!
                return NetworkManager().doServiceCall(serviceType: .getDepartmentDirectoryListByDepartment, params: ["department": "MVD", "districtId": self.districId!])
            }.then { response -> Promise<[String:Any]> in
                let directoryResponse = DirectoryResponse(dictionary: response as NSDictionary)
                self.mvdDirectoryList = (directoryResponse?.responseObject)!
                return NetworkManager().doServiceCall(serviceType: .getDepartmentDirectoryListByDepartment, params: ["department": "Police", "districtId": self.districId!])
            }.then { response -> () in
                let directoryResponse = DirectoryResponse(dictionary: response as NSDictionary)
                self.policeDirectoryList = (directoryResponse?.responseObject)!
                self.helpLineTableView.reloadData()
            }.catch { (error) in
                self.showError(error: error)
        }
    }
}


extension HelplineAdministrationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegmented == 0 {
            if self.administrationDirectoryList.count == 0 {
                noRecordShowLabel.alpha = 1.0
            } else {
                noRecordShowLabel.alpha = 0.0
            }
            return self.administrationDirectoryList.count
        } else if selectedSegmented == 1 {
            if self.mvdDirectoryList.count == 0 {
                noRecordShowLabel.alpha = 1.0
            } else {
                noRecordShowLabel.alpha = 0.0
            }
            return self.mvdDirectoryList.count
        }else {
            if self.policeDirectoryList.count == 0 {
                noRecordShowLabel.alpha = 1.0
            } else {
                noRecordShowLabel.alpha = 0.0
            }
            return self.policeDirectoryList.count
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HelpLineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HelpLineTableViewCellIdentifier") as! HelpLineTableViewCell
        var directory: Directory
        if selectedSegmented == 0 {
            directory = self.administrationDirectoryList[indexPath.row]
        } else  if selectedSegmented == 1 {
            directory = self.mvdDirectoryList[indexPath.row]
        }else{
            directory = self.policeDirectoryList[indexPath.row]
        }
        
        cell.nameLabel.text = directory.name
        cell.designationNameLabel.text = directory.designation
        cell.phoneNumberLabel.text = "Ph. \(String(describing: directory.contactNumber!))"
        cell.phoneNumber = directory.contactNumber!
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112.0   
    }
}
