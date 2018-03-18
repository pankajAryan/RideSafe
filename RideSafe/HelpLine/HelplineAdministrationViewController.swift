//
//  HelplineAdministrationViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 15/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit

class HelplineAdministrationViewController: UIViewController {

    @IBOutlet weak var helpLineTableView: UITableView!
    var mvdDirectoryList:[Directory] = []
    var administrationDirectoryList: [Directory] = []
    var selectedSegmented:Int = 0
    var districId:String? = "4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helpLineTableView.tableFooterView = UIView()
        loadData()
    }
    
    func loadData() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getDepartmentDirectoryListByDepartment, params: ["department": "Administration", "districtId": districId!])
            }.then { response -> Promise<[String:Any]> in
                let directoryResponse = DirectoryResponse(dictionary: response as NSDictionary)
                self.administrationDirectoryList = (directoryResponse?.responseObject)!
                return NetworkManager().doServiceCall(serviceType: .getDepartmentDirectoryListByDepartment, params: ["department": "MVD", "districtId": self.districId!])
            }.then { response -> () in 
                let directoryResponse = DirectoryResponse(dictionary: response as NSDictionary)
                self.mvdDirectoryList = (directoryResponse?.responseObject)!
                self.helpLineTableView.reloadData()
                }.catch { (error) in
        }
    }
    
    
    
}


extension HelplineAdministrationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegmented == 0 {
            return self.administrationDirectoryList.count
        } else {
            return self.mvdDirectoryList.count
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HelpLineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HelpLineTableViewCellIdentifier") as! HelpLineTableViewCell
        var directory: Directory
        if selectedSegmented == 0 {
            directory = self.administrationDirectoryList[indexPath.row]
        } else {
            directory = self.mvdDirectoryList[indexPath.row]
        }
        cell.nameLabel.text = directory.name
        cell.designationNameLabel.text = directory.departmentName
        cell.phoneNumberButton.setTitle(directory.contactNumber, for: .normal)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}
