//
//  EducationContainerViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 14/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import SWSegmentedControl

class EducationContainerViewController: RideSafeViewController {

    @IBOutlet weak var educationSegmentedControl: SWSegmentedControl!
    @IBOutlet weak var containerView: UIView!
    var educationVideoViewController: EducationVideoViewController?
    var educationPDFVideoController: EducationPDFViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Road Safety Education".localized
        educationSegmentedControl.setTitle("Videos".localized, forSegmentAt: 0)
        educationSegmentedControl.setTitle("PDFs".localized, forSegmentAt: 1)
        educationSegmentedControl.font = UIFont.init(name: "Poppins-Medium", size: 14.0)!
        educationSegmentedControl.titleColor = UIColor.white
        educationSegmentedControl.unselectedTitleColor = UIColor.white
        educationSegmentedControl.backgroundColor = UIColor.init(red: 0.79, green: 0.24, blue: 0.16, alpha: 1.0)
        educationVideoViewController = storyboard?.instantiateViewController(withIdentifier: "EducationVideoViewController") as? EducationVideoViewController
        educationPDFVideoController = storyboard?.instantiateViewController(withIdentifier: "EducationPDFViewController") as? EducationPDFViewController
        // Do any additional setup after loading the view.
        switchtoVideoTab()
        setBackButton()

    }
    
    func switchtoVideoTab() {
        educationPDFVideoController?.removeFromParentViewController()
        educationPDFVideoController?.view.removeFromSuperview()
        educationVideoViewController?.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        self.containerView.addSubview((educationVideoViewController?.view)!)
        self.addChildViewController(educationVideoViewController!)
    }
    
    func switchToPDFTab() {
        educationVideoViewController?.removeFromParentViewController()
        educationVideoViewController?.view.removeFromSuperview()
        educationPDFVideoController?.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
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
