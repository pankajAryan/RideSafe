//
//  IssueStatusTableVC.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 19/04/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class IssueStatusTableVC: UITableViewController {

    var statusArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueStatusTableViewCell", for: indexPath) as! IssueStatusTableViewCell

        return cell
    }
 
}
