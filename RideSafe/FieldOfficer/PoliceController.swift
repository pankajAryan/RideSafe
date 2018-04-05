//
//  PoliceController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 23/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class PoliceController: RideSafeViewController {

@IBOutlet weak var recordTable: UITableView!
var fieldOfficers:[FieldOfficer]?

override func viewDidLoad() {
    super.viewDidLoad()
    
    self.recordTable.register(UINib(nibName: "FOContactCell", bundle: nil), forCellReuseIdentifier: "FOContactCell")
    recordTable.tableHeaderView = UIView()
    recordTable.tableFooterView = UIView()
    recordTable.estimatedRowHeight = 200
    recordTable.rowHeight = UITableViewAutomaticDimension
    recordTable.backgroundColor = .clear
    recordTable.separatorStyle = .none
    
    NetworkManager().doServiceCall(serviceType: .getFellowFieldOfficialList, params: ["fieldOfficialId" : citizenId,"departmentId": "2"]).then { response -> () in
        self.fieldOfficers =  FieldOfficerList(dictionary: response as NSDictionary)?.responseObject
        self.recordTable.reloadData()
    }
}
}

extension PoliceController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fieldOfficers?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FOContactCell") as? FOContactCell {
            let contact = fieldOfficers?[indexPath.row]
            cell.nameLabel.text = contact?.name
            cell.number = contact?.mobile ?? ""
            cell.phoneNumber.text = "Ph. \(contact?.mobile ?? "")"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
