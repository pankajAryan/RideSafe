//
//  DropDownController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 15/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

protocol DropDownDelgate:class {
    func selectedItems(_ items:[DropDownDataSource])
}

class DropDownController: UITableViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var doneBtn: UIBarButtonItem!

    var dropDownDataSource:[DropDownDataSource]?
    weak var dropDownDelgate:DropDownDelgate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        navItem.title = "Select item".localized
        doneBtn.title = "Done".localized
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dropDownDataSource else { return 0  }
        showNoRecod(dataSource.count == 0, viewOn: tableView)
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        let model = dropDownDataSource?[indexPath.row]
        cell.textLabel?.text = model?.name ?? "no name"
        cell.accessoryType = model?.checkMark == true ? .checkmark : .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.init(name: "Poppins-Medium", size: 14.0)!
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType =  cell?.accessoryType == .checkmark ? .none :.checkmark
        
        dropDownDataSource![indexPath.row].checkMark = !dropDownDataSource![indexPath.row].checkMark

    }
    
    @IBAction func DoneButtonClicked(_ sender: UIBarButtonItem) {
        let selectedValues = dropDownDataSource?.filter{ $0.checkMark == true }
        self.dropDownDelgate?.selectedItems(selectedValues!)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

struct DropDownDataSource   {
    var name:String?
    var id:String?
    var checkMark = false
}
