//
//  RoadInfraIssueViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 19/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class RoadInfraIssueViewController: UIViewController {

    @IBOutlet weak var issueTypesLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var issueDiscriptionTextView: UITextView!
    @IBOutlet weak var issueImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func loadIssueListAsperLanguage() {
        
    }
    
    private func addtapGestureOnIssueLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openIssueList))
        issueTypesLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func openIssueList() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dropdownButtonClicked(_ sender: Any) {
    }
    @IBAction func openCameraClicked(_ sender: Any) {
    }
    @IBAction func reportButtonClicked(_ sender: Any) {
    }
    
}
