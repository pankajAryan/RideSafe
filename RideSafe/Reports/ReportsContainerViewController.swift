//
//  ReportsContainerViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 23/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import SWSegmentedControl

class ReportsContainerViewController: RideSafeViewController {

    @IBOutlet weak var reportSegmentController: SWSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    var unsafeDrivingIssueListViewController: UnsafeDrivingIssueListViewController?
    var roadInfraIssueListViewController: RoadInfraIssueListViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Reports"
        reportSegmentController.setTitle("UNSAFE DRIVING", forSegmentAt: 0)
        reportSegmentController.setTitle("ROAD INFRA", forSegmentAt: 1)
        
        unsafeDrivingIssueListViewController = storyboard?.instantiateViewController(withIdentifier: "UnsafeDrivingIssueListViewController") as? UnsafeDrivingIssueListViewController
        roadInfraIssueListViewController = storyboard?.instantiateViewController(withIdentifier: "RoadInfraIssueListViewController") as? RoadInfraIssueListViewController

        switchtoUnsafeDrivingIssueTab()
        // Do any additional setup after loading the view.
    }

    func switchtoUnsafeDrivingIssueTab() {
        roadInfraIssueListViewController?.removeFromParentViewController()
        roadInfraIssueListViewController?.view.removeFromSuperview()
        unsafeDrivingIssueListViewController?.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        self.containerView.addSubview((unsafeDrivingIssueListViewController?.view)!)
        self.addChildViewController(unsafeDrivingIssueListViewController!)
        
    }
    
    func switchToRoadInfraIssueTab() {
        unsafeDrivingIssueListViewController?.removeFromParentViewController()
        unsafeDrivingIssueListViewController?.view.removeFromSuperview()
        roadInfraIssueListViewController?.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        self.containerView.addSubview((roadInfraIssueListViewController?.view)!)
        self.addChildViewController(roadInfraIssueListViewController!)
    }
    
    @IBAction func reportSegementClicked(_ sender: SWSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            switchtoUnsafeDrivingIssueTab()
        } else {
            switchToRoadInfraIssueTab()
        }
    }
}
