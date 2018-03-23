//
//  FODashboardController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 23/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import SWSegmentedControl
import Segmentio

class FODashboardController: UIViewController,MenuCellDelegte {
    
    @IBOutlet weak var sideMenu: SideMenu!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControl: Segmentio!
    
//    lazy var drivingControllr:DrivingIssueController = {
//        let drivingViewControllr = UIStoryboard(name: "FOMain", bundle: nil).instantiateViewController(withIdentifier: "DrivingIssueController") as! DrivingIssueController
//        self.addViewControllerAsChiledViewController(childViewController:drivingViewControllr)
//        return drivingViewControllr
//    }()
//
//    lazy var infraControllr:InfraIssueController = {
//        let infraIssueViewController = UIStoryboard(name: "FOMain", bundle: nil).instantiateViewController(withIdentifier: "InfraIssueController") as! InfraIssueController
//        self.addViewControllerAsChiledViewController(childViewController:infraIssueViewController)
//        return infraIssueViewController
//    }()
//
//    lazy var transportController:TransportController = {
//        let transportViewController = UIStoryboard(name: "FOMain", bundle: nil).instantiateViewController(withIdentifier: "TransportController") as! TransportController
//        self.addViewControllerAsChiledViewController(childViewController:transportViewController)
//        return transportViewController
//    }()
//
//    lazy var policeController:PoliceController = {
//        let policeViewController = UIStoryboard(name: "FOMain", bundle: nil).instantiateViewController(withIdentifier: "PoliceController") as! PoliceController
//        self.addViewControllerAsChiledViewController(childViewController:policeViewController)
//        return policeViewController
//    }()
//
//    private  func addViewControllerAsChiledViewController(childViewController:UIViewController) {
//        addChildViewController(childViewController)
//        view.addSubview(childViewController.view)
//        childViewController.view.frame = view.bounds
//        childViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        childViewController.didMove(toParentViewController: self)
//    }
//
//    private func removeViewControllerAsChiledViewController(childViewController:UIViewController) {
//        childViewController.willMove(toParentViewController: nil)
//        childViewController.view.removeFromSuperview()
//        childViewController.removeFromParentViewController()
//    }
    
      var container: EmbededContainerController!
    
    
    @IBAction func menuClicked(_ sender: UIBarButtonItem) {
        leftConstraint.constant =   leftConstraint.constant == 0 ? -240 : 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    // "DRIVING ISSUE" "INFRA ISSUE" "TRANSPORT" "POLICE"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        segmentedControl.setup(content: [SegmentioItem(title: "DRIVING ISSUE", image: nil),
                                         SegmentioItem(title: "INFRA ISSUE", image: nil),
                                         SegmentioItem(title: "TRANSPORT", image: nil),
                                         SegmentioItem(title: "POLICE", image: nil)],
                               style: .onlyLabel,
                               options: SegmentioOptions(backgroundColor: UIColor.white,
                                                         segmentPosition: .dynamic,
                                                         scrollEnabled: true,
                                                         indicatorOptions: SegmentioIndicatorOptions(
                                                            type: .bottom,
                                                            ratio: 1,
                                                            height: 1,
                                                            color: .blue),
                                                         horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(
                                                            type: SegmentioHorizontalSeparatorType.none, // Top, Bottom, TopAndBottom
                                                            height: 1,
                                                            color: .clear),
                                                         verticalSeparatorOptions: SegmentioVerticalSeparatorOptions(
                                                            ratio: 0.6, // from 0.1 to 1
                                                            color: .gray),
                                                         imageContentMode: UIViewContentMode.center,
                                                         labelTextAlignment: .center,
                                                         labelTextNumberOfLines: 0,
                                                         segmentStates: SegmentioStates(
                                                            defaultState: SegmentioState( backgroundColor: .clear,
                                                                                          titleFont: UIFont.boldSystemFont(ofSize: 14),
                                                                                          titleTextColor: .darkGray),
                                                            selectedState: SegmentioState(backgroundColor: .clear,
                                                                                          titleFont: UIFont.boldSystemFont(ofSize: 14),
                                                                                          titleTextColor: .darkGray),
                                                            highlightedState: SegmentioState( backgroundColor: UIColor.clear,
                                                                                              titleFont: UIFont.boldSystemFont(ofSize: 14),
                                                                                              titleTextColor: .darkGray)
                                ),
                                                         animationDuration: 0.1))
        segmentedControl.selectedSegmentioIndex = 0
        
        segmentedControl.valueDidChange = {[weak self] segmentio, segmentIndex in
            switch segmentIndex {
            case 0:
                self?.switchToDrivingIssueTab()
            case 1:
                self?.switchToInfraIssueTab()
            case 2:
                self?.switchToTransportTab()
            case 3:
                self?.switchToPoliceTab()
            default:
                break
            }
        }
        switchToDrivingIssueTab()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container"{
            container = segue.destination as! EmbededContainerController
            //For adding animation to the transition of containerviews you can use container's object property
            // animationDurationWithOptions and pass in the time duration and transition animation option as a tuple
            // Animations that can be used
            // .transitionFlipFromLeft, .transitionFlipFromRight, .transitionCurlUp
            // .transitionCurlDown, .transitionCrossDissolve, .transitionFlipFromTop
            container.animationDurationWithOptions = (0.5, .transitionCrossDissolve)
        }
    }
    
    func switchToDrivingIssueTab() {
        container!.segueIdentifierReceivedFromParent("drivingIssue")
    }
    
    func switchToInfraIssueTab() {
        container!.segueIdentifierReceivedFromParent("InfraIssue")

    }
    
    func switchToTransportTab() {
        container!.segueIdentifierReceivedFromParent("transport")

    }
    
    func switchToPoliceTab() {
        container!.segueIdentifierReceivedFromParent("police")

    }
    
    
    private func setupUI() {
        sideMenu.menuCellDelegte = self
        self.navigationController?.navigationBar.isHidden = false
        self.view.bringSubview(toFront: self.sideMenu)
        
    }
    func cellCllicked(action:SliderActions?) {
        
        guard let action = action else { return  }
        let str =  UIStoryboard(name: "Main", bundle: nil)
        var vc : UIViewController?
        switch action {
        case .Profile:
            vc = str.instantiateViewController(withIdentifier: "MyProfile") as! MyProfile
            
        case .Report:
            vc = str.instantiateViewController(withIdentifier: "MyReport") as! MyReport
            
        case .Setting:
            vc = str.instantiateViewController(withIdentifier: "SettingController") as! SettingController
            
        case .About:
            vc = str.instantiateViewController(withIdentifier: "AboutRideSafe") as! AboutRideSafe
            
        case .Share:
            let text = "Hi! Please Download Ride Safe app from this link:"
            let image = #imageLiteral(resourceName: "logo_large")
            let myWebsite = NSURL(string:"http://139.59.81.101:8080/RideSafeapp/ridesafe.apk")!
            let shareAll = [text , image , myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            
        case .Logout:
            
            showAlert(message: "Are you sure you want to Logout?", handler: { (action) in
                self.clearUserDefault()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginController = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                self.navigationController?.pushViewController(loginController, animated: true)
                self.navigationController?.viewControllers = [loginController]
            })
            
        }
        
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.menuClicked(UIBarButtonItem())
    }
    
}
