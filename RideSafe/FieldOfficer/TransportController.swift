//
//  TransportController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 23/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class TransportController: RideSafeViewController {
    
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
        
        NetworkManager().doServiceCall(serviceType: .getFellowFieldOfficialList, params: ["fieldOfficialId" : citizenId,"departmentId": "3"]).then { response -> () in
            self.fieldOfficers =  FieldOfficerList(dictionary: response as NSDictionary)?.responseObject
            self.recordTable.reloadData()
        }
        .catch { (error) in
            self.showError(error: error)
        }
    }
}

extension TransportController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fieldOfficers?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FOContactCell") as? FOContactCell {
            cell.configureCell(contact: fieldOfficers?[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

