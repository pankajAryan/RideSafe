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
import CoreLocation
import PromiseKit

class ShareLiveLocationOfFieldOfficer:NSObject, CLLocationManagerDelegate {
    
    var timer: Timer?
    var locationManager = CLLocationManager()
    
    var fieldOfficialId:String {
        get {
            guard let fieldOfficialId = UserDefaults.standard.string(forKey: UserDefaultsKeys.citizenId.rawValue) else { return "" }
            return fieldOfficialId
        }
    }
    
    func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func sotpSendingLocationManager() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locVal = manager.location?.coordinate else { return }
        locationManager.stopUpdatingLocation()
        
        if self.timer != nil {
            let latitude: String = String(locVal.latitude)
            let longitude: String = String(locVal.longitude)
            self.updateServerWithLiveLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed")
    }
    
    private func updateServerWithLiveLocation(latitude: String, longitude: String) {
        
        firstly {
            NetworkManager().doServiceCall(serviceType: .recordFieldOfficialLocation, params: ["fieldOfficialId": fieldOfficialId,
                                                                                             "lat":  latitude,
                                                                                             "lon": longitude], showLoader: false)
            }.then { response -> () in
                print(response)
            }.catch { (error) in
                
        }
    }
    
}

class FODashboardController: RideSafeViewController,MenuCellDelegte {
    
    @IBOutlet weak var sideMenu: SideMenu!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControl: Segmentio!
    
    var container: EmbededContainerController!

    let shareLiveLocationOfFieldOfficer = ShareLiveLocationOfFieldOfficer()

    @IBAction func menuClicked(_ sender: UIBarButtonItem) {
        leftConstraint.constant =   leftConstraint.constant == 0 ? -240 : 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func fetchLiveLocation() {
        
        let user = UserType.Citizen.getTokenUserType(userType: self.userType)
        if user == .FieldOfficial {
            shareLiveLocationOfFieldOfficer.setupLocationManager()
        }else{// stop
            shareLiveLocationOfFieldOfficer.sotpSendingLocationManager()
        }
    }
    
    // "DRIVING ISSUE" "INFRA ISSUE" "TRANSPORT" "POLICE"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = UserType.Citizen.getTokenUserType(userType: self.userType)
        
        if user == .FieldOfficial {// 30 second
            shareLiveLocationOfFieldOfficer.timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(fetchLiveLocation), userInfo: nil, repeats: true)
            fetchLiveLocation()
        }
       
        setupUI()
        let yellowColor = UIColor(red: 245.0/255.0, green: 193.0/255.0, blue: 68.0/255.0, alpha: 1)
        segmentedControl.setup(content: [SegmentioItem(title: "DRIVING ISSUE", image: nil),
                                         SegmentioItem(title: "TRANSPORT", image: nil)],
                               style: .onlyLabel,
                               options: SegmentioOptions(backgroundColor: UIColor.white,
                                                         segmentPosition: .dynamic,
                                                         scrollEnabled: true,
                                                         indicatorOptions: SegmentioIndicatorOptions(
                                                            type: .bottom,
                                                            ratio: 1,
                                                            height: 2,
                                                            color: yellowColor),
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
                                                                                          titleFont: UIFont(name: "Poppins-Medium", size: 14.0)!,
                                                                                          titleTextColor: .darkText),
                                                            selectedState: SegmentioState(backgroundColor: .clear,
                                                                                          titleFont: UIFont(name: "Poppins-Medium", size: 14.0)!,
                                                                                          titleTextColor: .darkText),
                                                            highlightedState: SegmentioState( backgroundColor: UIColor.clear,
                                                                                              titleFont: UIFont(name: "Poppins-Medium", size: 14.0)!,
                                                                                              titleTextColor: .darkText)
                                ),
                                                         animationDuration: 0.1))
        segmentedControl.selectedSegmentioIndex = 0
        
        segmentedControl.valueDidChange = {[weak self] segmentio, segmentIndex in
            switch segmentIndex {
            case 0:
                self?.switchToDrivingIssueTab()
            case 1:
                self?.switchToTransportTab()
            case 2:
                self?.switchToPoliceTab()
            case 3:
                self?.switchToAdministrationTab()
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
    
    func switchToAdministrationTab() {
        container!.segueIdentifierReceivedFromParent("Administration")
    }
    
    private func setupUI() {
        sideMenu.menuCellDelegte = self
        self.navigationController?.navigationBar.isHidden = false
        self.view.bringSubview(toFront: self.sideMenu)
        let logo = UIImage(named: "top_logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
    }
    func cellCllicked(action:SliderActions?) {
        
        guard let action = action else { return  }
        let str =  UIStoryboard(name: "Main", bundle: nil)
        var vc : UIViewController?
        switch action {
        case .Profile:
            let str =  UIStoryboard(name: "FOMyProfile", bundle: nil)
            vc = str.instantiateViewController(withIdentifier: "FOMyProfileController") as! FOMyProfileController
            
        case .Report: break
        case .Setting: break
        case .Tutorial: break
        case .About:
            vc = str.instantiateViewController(withIdentifier: "AboutRideSafe") as! AboutRideSafe
            
        case .Share:
            let text = "Hi! Checkout JK RideSafe app here:\n\(kAppStoreURL)"
            let image = #imageLiteral(resourceName: "logo_large")
            let myWebsite = NSURL(string:kAppStoreURL)!
            let shareAll = [text , image , myWebsite] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
            
        case .Logout:
            
            showAlert(message: "Are you sure you want to Logout?".localized, handler: { (action) in
                
                let service =  self.userType.uppercased() != "E" ? ServiceType.logoutFieldOfficial : ServiceType.logoutEscalationOfficial
                let key = self.userType.uppercased() != "E" ? "fieldOfficialId" : "escalationOfficialId"
                NetworkManager().doServiceCall(serviceType: service, params: [key : self.citizenId]).then { (response) -> () in
                    self.clearUserDefault()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginController = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                    self.navigationController?.viewControllers = [loginController]
                    }.catch{ error in
                        self.showError(error: error)
                }
            })
            
        }
        
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.menuClicked(UIBarButtonItem())
    }
    
}
