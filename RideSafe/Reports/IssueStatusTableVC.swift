//
//  IssueStatusTableVC.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 19/04/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class IssueStatusTableVC: RideSafeViewController, UITableViewDelegate, UITableViewDataSource {

    var statusArray: [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButton()
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueStatusTableViewCell", for: indexPath) as! IssueStatusTableViewCell

        return cell
    }
}
