//
//  EducationContainerViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 14/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import SWSegmentedControl

class EducationContainerViewController: UIViewController {

    @IBOutlet weak var educationSegmentedControl: SWSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    var educationVideoViewController: EducationVideoViewController?
    var educationPDFVideoController: EducationPDFViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Road Safety Education"
        educationSegmentedControl.setTitle("VIDEOS", forSegmentAt: 0)
        educationSegmentedControl.setTitle("PDF", forSegmentAt: 1)
        educationVideoViewController = storyboard?.instantiateViewController(withIdentifier: "EducationVideoViewController") as? EducationVideoViewController
        educationPDFVideoController = storyboard?.instantiateViewController(withIdentifier: "EducationPDFViewController") as? EducationPDFViewController
        // Do any additional setup after loading the view.
        switchtoVideoTab()
        setBackButton()

    }
    
    func switchtoVideoTab() {
        
        educationPDFVideoController?.removeFromParentViewController()
        educationPDFVideoController?.view.removeFromSuperview()
        
        self.containerView.addSubview((educationVideoViewController?.view)!)
        self.addChildViewController(educationVideoViewController!)
        
    }
    
    func switchToPDFTab() {
        educationVideoViewController?.removeFromParentViewController()
        educationVideoViewController?.view.removeFromSuperview()
        self.containerView.addSubview((educationPDFVideoController?.view)!)
        self.addChildViewController(educationPDFVideoController!)
    }
    
    @IBAction func segmentedChanged(_ sender: SWSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            switchtoVideoTab()
        } else {
            switchToPDFTab()
        }
    }
    
    
}
