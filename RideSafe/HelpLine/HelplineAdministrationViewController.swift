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
    var selectedSegmented:Int = 0
    var districId:String? = "4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helpLineTableView.tableFooterView = UIView()
    }
    
    func loadData() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getDepartmentDirectoryListByDepartment, params: ["department": "MVD", "districtId": self.districId!])
            }.then { response -> () in
                let directoryResponse = DirectoryResponse(dictionary: response as NSDictionary)
                self.mvdDirectoryList = (directoryResponse?.responseObject)!
                self.helpLineTableView.reloadData()
            }.catch { (error) in
                self.showError(error: error)
        }
    }
}


extension HelplineAdministrationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showNoRecod( mvdDirectoryList.count == 0, viewOn: tableView)
        return self.mvdDirectoryList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:HelpLineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HelpLineTableViewCellIdentifier") as! HelpLineTableViewCell
        var directory : Directory = self.mvdDirectoryList[indexPath.row]
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
