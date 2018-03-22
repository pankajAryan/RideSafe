//
//  RoadInfraIssueViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 19/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit

class RoadInfraIssueViewController: UIViewController {

    @IBOutlet weak var issueTypesLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var issueDiscriptionTextView: UITextView!
    @IBOutlet weak var issueImageView: UIImageView!
    var selectedInfraIssueList: [DropDownDataSource] = []
    var infraIssueList: [DropDownDataSource] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIssueListAsperLanguage()
    }
    
    func loadIssueListAsperLanguage() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getRoadInfraCategoryListByLanguage, params: ["language": selectedLanguage])
            }.then { response -> () in
                let roadinfraIssueResponse = RoadinfraIssueResponse(dictionary: response as NSDictionary)
                if let infraIssueList = roadinfraIssueResponse?.responseObject {
                    for infraIssue in infraIssueList {
                        var issueName: String = ""
                        switch self.selectedLanguage {
                            
                        case "H":
                            issueName = infraIssue.urName!

                        case "E":
                            issueName = infraIssue.enName!

                        case "U":
                            issueName = infraIssue.urName!

                        default:
                            break
                            
                        }
                        let dropDownItem: DropDownDataSource = DropDownDataSource(name: issueName, id: infraIssue.roadInfraIssueCategoryId!, checkMark: false)
                        self.infraIssueList.append(dropDownItem)
                    }
                }
                
            }.catch { (error) in
        }
    }
    
    
    
    
    private func addtapGestureOnIssueLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openIssueList))
        issueTypesLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func openIssueList() {
        dropdownButtonClicked(dropDownButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dropdownButtonClicked(_ sender: UIButton) {
        let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "DropDownController") as! DropDownController
        vc.dropDownDelgate = self
        vc.dropDownDataSource = infraIssueList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openCameraClicked(_ sender: Any) {
    }
    @IBAction func reportButtonClicked(_ sender: Any) {
    }
    
}

extension RoadInfraIssueViewController: DropDownDelgate{
    func selectedItems(_ items: [DropDownDataSource]) {
        selectedInfraIssueList = items
        var allIssues = ""
        for issue in selectedInfraIssueList {
            allIssues =  allIssues + issue.name! + ","
        }
        issueTypesLabel.text = String(describing: allIssues.dropLast())
        if issueTypesLabel.text == "" {
            issueTypesLabel.text = "Select Driving Issues"
        }
    }
    
    private func catagoryIds() -> String {
        var ids = ""
        for id in selectedInfraIssueList {
            ids =  ids + id.id! + ","
        }
        return String(describing: ids.dropLast())
    }
}
