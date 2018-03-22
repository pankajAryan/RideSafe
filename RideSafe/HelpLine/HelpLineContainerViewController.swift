//
//  HelpLineContainerViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 15/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import SWSegmentedControl

class HelpLineContainerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentedController: SWSegmentedControl!
    var helpLineViewController: HelplineAdministrationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Emergency Directory"
        segmentedController.setTitle("ADMINISTRATION", forSegmentAt: 0)
        segmentedController.setTitle("MVD", forSegmentAt: 1)
        helpLineViewController = storyboard?.instantiateViewController(withIdentifier: "HelplineAdministrationViewController") as? HelplineAdministrationViewController
        self.containerView.addSubview((helpLineViewController?.view)!)
        self.addChildViewController(helpLineViewController!)
        setBackButton()
    }

    func switchtoAdministrationTab() {
        helpLineViewController?.selectedSegmented = 0
        helpLineViewController?.helpLineTableView.reloadData()
    }
    
    func switchMVDTab() {
        helpLineViewController?.selectedSegmented = 1
        helpLineViewController?.helpLineTableView.reloadData()
    }
    
    @IBAction func selectedSegmentedController(_ sender: SWSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            switchtoAdministrationTab()
        } else {
            switchMVDTab()
        }
    }

}
