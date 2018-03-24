//
//  InfraIssueController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 23/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class InfraIssueController: UIViewController {
    @IBOutlet weak var recordTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension InfraIssueController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
