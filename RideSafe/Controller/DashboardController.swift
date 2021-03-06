//
//  DashboardController.swift
//  sidebarmenu
//
//  Created by Devesh on 11/03/18.
//  Copyright © 2018 __SELF___. All rights reserved.
//

import UIKit
import MessageUI
import UIDropDown
import CoreLocation
import PromiseKit
import Alamofire
import Firebase

class ShareLiveLocationOfCitizen:NSObject, CLLocationManagerDelegate {
    
    var timer: Timer?
    var locationManager = CLLocationManager()
    var drivingIssueId : String?

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
            NetworkManager().doServiceCall(serviceType: .recordCitizenLocation, params: ["drivingIssueId": drivingIssueId ?? "",
                                                                                               "lat":  latitude,
                                                                                               "lon": longitude], showLoader: false)
            }.then { response -> () in
                print(response)
                
                if let errorCode = response["errorCode"] as? String, errorCode == "-1"   {
                    self.sotpSendingLocationManager()
                }
                
            }.catch { (error) in
        }
    }
}

class DashboardController: RideSafeViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var vehicleNumber: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    var selectedImageForReport : UIImage?
    
    @IBOutlet weak var vehicleFirstField: UITextField!
    @IBOutlet weak var tbl_vehicleList: UITableView!
    @IBOutlet weak var constraint_heightOfVehicleTbl: NSLayoutConstraint!
    var arr_vehicleList:[Dictionary<String,Any>] = []

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var drivingIssuesLabel: UILabel!
    @IBOutlet weak var numberOfOffenceSelectedLabel: UILabel!
    @IBOutlet weak var vehicleTypeView: UIDropDown!
    @IBOutlet weak var tableViewleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenu: SideMenu!
    @IBOutlet weak var cameraButton: UIButton!

    var vehicleType = ""
    var drivingIssues:[DropDownDataSource] = []
    var imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var imageUrl:String?
    var postedByType:String?

    var isFirstCallToPushNotificationAPI = true
    
    var drivingIssuePendingCount : String?
    var roadInfraPendingCount : String?
    
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var helpLineLabel: UILabel!
    @IBOutlet weak var emegencyLabel: UILabel!
    @IBOutlet weak var reportInfraLabel: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    
    var menuBtnCenter : CGPoint?
    
    var menuButton : ExpandingMenuButton!
    
    var shareLiveLocationOfCitizen : ShareLiveLocationOfCitizen?

    @objc func fetchLiveLocation() {
        
        let user = UserType.Citizen.getTokenUserType(userType: self.userType)
        if user == .Citizen {
            shareLiveLocationOfCitizen?.setupLocationManager()
        }else{// stop
            shareLiveLocationOfCitizen?.sotpSendingLocationManager()
        }
    }
    
    func startLocationSending (drivingIssueId: String?) {
        
        // destroy old instance
        shareLiveLocationOfCitizen?.sotpSendingLocationManager()
        shareLiveLocationOfCitizen = nil
        
        //create new
        shareLiveLocationOfCitizen = ShareLiveLocationOfCitizen()
        shareLiveLocationOfCitizen?.drivingIssueId = drivingIssueId
        shareLiveLocationOfCitizen?.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchLiveLocation), userInfo: nil, repeats: true)
        fetchLiveLocation()
    }
    
    @objc func setCenter() {
        menuBtnCenter = CGPoint(x:self.view.bounds.width-40, y: self.view.bounds.height-95 - 40)
        menuButton.center = menuBtnCenter!
        menuButton.isHidden = false
    }
    
    func configureExpandingMenuButton() {
        
        let widthHeight : CGFloat = 50.0
        let menuButtonSize: CGSize = CGSize(width: widthHeight, height: widthHeight)
        
        if menuButton != nil {
            menuButton.removeFromSuperview()
            menuButton = nil
        }
        
        menuButton = ExpandingMenuButton.init(frame: CGRect.init(x: self.view.bounds.width-40, y: self.view.bounds.height-95 - 40, width: widthHeight, height: widthHeight), image: #imageLiteral(resourceName: "plus"), highlightedImage: #imageLiteral(resourceName: "plus"), rotatedImage: #imageLiteral(resourceName: "plus"), rotatedHighlightedImage: #imageLiteral(resourceName: "plus"))
        
        
        if menuBtnCenter == nil {
            menuButton.isHidden = true
            perform(#selector(setCenter), with: nil, afterDelay: 0.2)
        }else{
            menuButton.center = menuBtnCenter!
        }
        //end hack
        self.menuButton.bottomViewColor = UIColor.clear
        self.menuButton.menuButton.backgroundColor = UIColor.red

        self.menuButton.menuButton.layer.cornerRadius = widthHeight/2
        self.menuButton.menuButton.layer.shadowColor = UIColor.black.cgColor
        self.menuButton.menuButton.layer.shadowRadius = 2
        self.menuButton.menuButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.menuButton.menuButton.layer.shadowOpacity = 0.3
        
        self.view.addSubview(menuButton)
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: "  \("Share Live Location".localized)  ", image: #imageLiteral(resourceName: "live_share"), highlightedImage: #imageLiteral(resourceName: "live_share"), backgroundImage: #imageLiteral(resourceName: "live_share"), backgroundHighlightedImage:#imageLiteral(resourceName: "live_share")) { () -> Void in
            self.emergencyClicked(UIButton())
        }
        
        item1.titleColor = UIColor.white
        item1.titleButton?.backgroundColor = UIColor.black
        item1.frontImageView.backgroundColor = UIColor.white
       
        item1.titleButton?.layer.cornerRadius = 2
        item1.titleButton?.layer.masksToBounds = true
        
        item1.frontImageView.layer.cornerRadius = widthHeight/2
        item1.frontImageView.layer.shadowColor = UIColor.black.cgColor
        item1.frontImageView.layer.shadowRadius = 2
        item1.frontImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        item1.frontImageView.layer.shadowOpacity = 0.3
        
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: "  \("Pending Infra Issue".localized) (\(roadInfraPendingCount ?? "0"))  ", image: #imageLiteral(resourceName: "road_infra"), highlightedImage:#imageLiteral(resourceName: "road_infra"), backgroundImage: #imageLiteral(resourceName: "road_infra"), backgroundHighlightedImage:#imageLiteral(resourceName: "road_infra")) { () -> Void in
            
            let vc = UIStoryboard.init(name: "Reports", bundle: nil).instantiateViewController(withIdentifier: "ReportsContainerViewController") as! ReportsContainerViewController
            vc.selectedSegment = 1//road infra
            self.navigationController?.pushViewController(vc, animated: true)
        }
        item2.titleColor = UIColor.white
        item2.titleButton?.backgroundColor = UIColor.black
        item2.frontImageView.backgroundColor = UIColor.white

        item2.titleButton?.layer.cornerRadius = 2
        item2.titleButton?.layer.masksToBounds = true
        
        item2.frontImageView.layer.cornerRadius = widthHeight/2
        item2.frontImageView.layer.shadowColor = UIColor.black.cgColor
        item2.frontImageView.layer.shadowRadius = 2
        item2.frontImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        item2.frontImageView.layer.shadowOpacity = 0.3
        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: "  \("Pending Driving Issue".localized) (\(drivingIssuePendingCount ?? "0"))  ", image: #imageLiteral(resourceName: "driving_issue"), highlightedImage: #imageLiteral(resourceName: "driving_issue"), backgroundImage: #imageLiteral(resourceName: "driving_issue"), backgroundHighlightedImage:#imageLiteral(resourceName: "driving_issue")) { () -> Void in
            
            let vc = UIStoryboard.init(name: "Reports", bundle: nil).instantiateViewController(withIdentifier: "ReportsContainerViewController") as! ReportsContainerViewController
            vc.selectedSegment = 0//driving issue
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        item3.titleColor = UIColor.white
        item3.titleButton?.backgroundColor = UIColor.black
        item3.frontImageView.backgroundColor = UIColor.white
        
        item3.titleButton?.layer.cornerRadius = 2
        item3.titleButton?.layer.masksToBounds = true
        
        item3.frontImageView.layer.cornerRadius = widthHeight/2
        item3.frontImageView.layer.shadowColor = UIColor.black.cgColor
        item3.frontImageView.layer.shadowRadius = 2
        item3.frontImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        item3.frontImageView.layer.shadowOpacity = 0.3
        
        menuButton.addMenuItems([item1, item2, item3])
        
        menuButton.didPresentMenuItems = { (menu) -> Void in
            print("MenuItems will present.")
        }
        
        menuButton.didDismissMenuItems = { (menu) -> Void in
            print("MenuItems dismissed.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureExpandingMenuButton()
        setupLocationManager()
        setupVehicleTypeDropDown()
        addtappinggestureRecognizerOnDrivingIssueLabel()
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isNotFirstLaunch.rawValue) == false {
            showTutorial()
        }
        imagePicker.delegate = self
        setupUI()
        setLocalizedText()
        
        tbl_vehicleList.layer.borderColor = UIColor.black.cgColor
        tbl_vehicleList.layer.borderWidth = 0.5
        tbl_vehicleList.layer.cornerRadius = 2.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(fcmTokeUpdated), name: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
        
        perform(#selector(DashboardController.showTransportCommissionerPopupVC), with: nil, afterDelay: 1)
    }
    
    @objc func showTransportCommissionerPopupVC () {
        if !UserDefaults.standard.bool(forKey: "firstTimeCitizenAppLaunch") {
            UserDefaults.standard.set(true, forKey: "firstTimeCitizenAppLaunch")
            let transportCommissionerPopupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransportCommissionerPopupVC") as? TransportCommissionerPopupVC
            transportCommissionerPopupVC!.modalPresentationStyle = .overCurrentContext
            present(transportCommissionerPopupVC!, animated: true, completion: nil)
        }
    }
    
    @objc func fcmTokeUpdated() {
        NotificationCenter.default.removeObserver(self)
        RegisterForCitizenPushNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RegisterForCitizenPushNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handlePushFlow()
    }
    
    func handlePushFlow () {
        
        let delegate =  UIApplication.shared.delegate as! AppDelegate
        if let dict = delegate.remoteNitificationPayloadDict {
            delegate.handlePushFlow(payloadDict: dict)
            delegate.remoteNitificationPayloadDict = nil //// after handling, remove the dict
        }
    }
    
    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    private func setupVehicleTypeDropDown() {
        vehicleTypeView.backgroundColor = UIColor.clear
        makeVehicleDropDown()
    }
    private func addtappinggestureRecognizerOnDrivingIssueLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        drivingIssuesLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        sideMenu.menuCellDelegte = self
        self.navigationController?.navigationBar.isHidden = false
        self.view.bringSubview(toFront: self.sideMenu)
        let logo = UIImage(named: "top_logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        setRightButton()
    }
    
    private func setRightButton() {
        let rightButton = UIButton(type: .custom)
        rightButton.frame = CGRect(origin: .zero, size: CGSize(width: 44, height: 34))
        rightButton.addTarget(self, action: #selector(openNotification), for: .touchUpInside)
        rightButton.setImage(#imageLiteral(resourceName: "icn_notification"), for: .normal)
        
        rightButton.contentHorizontalAlignment = .right
        rightButton.contentVerticalAlignment = .center
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc func openNotification() {
        let notificationViewController: NotificationViewController = UIStoryboard.init(name: "Notification", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locVal = manager.location?.coordinate else { return }
        userLocation = locVal
        locationManager.stopUpdatingLocation()

    }
    
    func RegisterForCitizenPushNotification() {
        firstly {
            NetworkManager().doServiceCall(serviceType: .registerCitizenPushNotificationId, params: ["citizenId": citizenId,
                                                                                                     "notificationId":  deviceID,
                                                                                                     "language": selectedLanguage, "deviceOS" : "iOS"
], showLoader: isFirstCallToPushNotificationAPI)
            }.then { [unowned self] response -> () in
                self.writeJSONTo(fileName: FileNames.response.rawValue, data: response)

                if let responseDict = response as? Dictionary<String,Any>, let responseObject = responseDict["responseObject"] as? Dictionary<String,Any>  {
                    
                    self.drivingIssuePendingCount = responseObject["drivingIssuePendingCount"] as? String
                    self.roadInfraPendingCount = responseObject["roadInfraPendingCount"] as? String
                    
                    self.configureExpandingMenuButton()
                }

                if self.isFirstCallToPushNotificationAPI == true {
                    self.isFirstCallToPushNotificationAPI = false
                    self.retriveJSONFrom(fileName: FileNames.response.rawValue).then { response -> () in
                        let sresponse =  RegisterCitizenPushNotification.init(dictionary: response as NSDictionary)
                        if self.isForceUpdateRequired(for: sresponse?.responseObject?.appVersion) == true {
                            self.showForceUpdateAlert(handler: { (action) in
                                self.launchAppStore()
                            })
                        }
                    }
                }
            }.catch { (error) in
        }
    }
    
    private func showTutorial() {
        //TODO: tutorial code

        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isNotFirstLaunch.rawValue)
    }
    
    @objc func tapFunction() {
        makeDrivingIssuesCatagory()
    }
    
    @IBAction func reportButtonClicked(_ sender: UIButton) {
        
        if validateInputs() {
            
            let alert =  UIAlertController(title: "", message: "Are you a passenger in the vehicle ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { handler -> () in
                self.postedByType = "Passenger"
                self.uploadImage()
            }
            ))
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler:{ handler -> () in
                self.postedByType = "Reporter"
                self.uploadImage()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func clearInputFields() {
        descriptionText.resignFirstResponder()
        vehicleFirstField.text = ""
        vehicleType = ""
        drivingIssues = []
        descriptionText.text = ""
        descriptionText.placeholder = "Describe Issues".localized
        drivingIssuesLabel.text = "Select Driving Issues".localized
        numberOfOffenceSelectedLabel.text = "No Offence Selected".localized
        selectedImage.image = #imageLiteral(resourceName: "camera")
        selectedImageForReport = nil
        imageUrl = nil
        locationManager.stopUpdatingLocation()
        vehicleTypeView.options = ["Taxi".localized, "Tempo".localized, "Mini Bus".localized, "Bus".localized]
        vehicleTypeView.placeholder = "Select Vehicle Type".localized
    }
    
    func reportIssues() {
        NetworkManager().doServiceCall(serviceType: .reportDrivingIssue, params: ["lat":"\(userLocation.latitude)",
            "lon": "\(userLocation.longitude)",
            "description": descriptionText.text,
            "categoryIds": catagoryIds(),
            "postedBy": citizenId,
            "uploadedImageURL": self.imageUrl ?? "",
            "vehicleNumber": vehicleFirstField.text!,
            "vehicleType": vehicleType,
            "postedByType" : postedByType ?? "" ])
            .then { response -> () in
                self.clearInputFields()
                self.showToast(response: response)
                
                if self.postedByType == "Passenger" {
                    self.startLocationSending(drivingIssueId: response["responseObject"] as? String ?? "" )
                }else{
                    // destroy current one instance if any 
                    self.shareLiveLocationOfCitizen?.sotpSendingLocationManager()
                    self.shareLiveLocationOfCitizen = nil
                }
                
            }.catch { error in
                self.showError(error: error)
        }
    }
    
    func validateInputs() -> Bool
    {
        var isValid = true
        var str = "Invalid input"

        if let vehicleNum = vehicleFirstField.text, vehicleNum.count <= 7 {
            isValid = false
            str = "Vehicle number has to be 8-10 characters long!"
        }else if vehicleType.count == 0 {
            isValid = false
            str = "Please select vehicle type!"
        }else if drivingIssues.count == 0 {
            isValid = false
            str = "Please select atleast one Issue!"
        }
        
        if !isValid {
            let alert =  UIAlertController(title: "", message: str, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }
        
       return isValid
    }
    
    func uploadImage() {
        
        if let image = selectedImageForReport {
            NetworkManager().upload(image: image, serviceType: .uploadDrivingIssuePicture) .then { string -> () in
                self.imageUrl = string
                }.catch { error in
                    //self.showError(error: error)
                }.always {
                    NetworkReachabilityManager()!.isReachable ? self.reportIssues() : self.sendSMS()
            }
        }else{
            NetworkReachabilityManager()!.isReachable ? self.reportIssues() : self.sendSMS()
        }
    }
    
    func sendSMS() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
          let body  = "lat:" + "\(userLocation.latitude)" + ":lon:" + "\(userLocation.longitude)" + ":desc:" + descriptionText.text + ":categoryIds:" + catagoryIds() + ":vehicleNumber:" + vehicleFirstField.text! + ":vehicleType:" + vehicleType
            controller.body = body
            controller.recipients = ["9246400200"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func meuClicked(_ sender: UIBarButtonItem) {
        sideMenu.reloadData()
        tableViewleadingConstraint.constant = tableViewleadingConstraint.constant == 0 ? -240 : 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func roadInfraClicked(_ sender: UIButton) {
        let roadInfraIssueViewController: RoadInfraIssueViewController = UIStoryboard.init(name: "RoadInfraIssue", bundle: nil).instantiateViewController(withIdentifier: "RoadInfraIssueViewController") as! RoadInfraIssueViewController
        self.navigationController?.pushViewController(roadInfraIssueViewController, animated: true)
        
    }

    
    @IBAction func emergencyClicked(_ sender: UIButton) {
        let emergencyContactViewController: EmergencyContactViewController = UIStoryboard.init(name: "EmergencyContact", bundle: nil).instantiateViewController(withIdentifier: "EmergencyContactViewController") as! EmergencyContactViewController
        self.navigationController?.pushViewController(emergencyContactViewController, animated: true)
    }
    
    @IBAction func helpLineClicked(_ sender: UIButton) {
        let helpLineContainerViewController: HelpLineContainerViewController = UIStoryboard.init(name: "HelpLine", bundle: nil).instantiateViewController(withIdentifier: "HelpLineContainerViewController") as! HelpLineContainerViewController
        self.navigationController?.pushViewController(helpLineContainerViewController, animated: true)
    }
    
    @IBAction func educationClicked(_ sender: UIButton) {
        let educationContainerController: EducationContainerViewController = UIStoryboard.init(name: "Education", bundle: nil).instantiateViewController(withIdentifier: "EducationContainerViewController") as! EducationContainerViewController
        self.navigationController?.pushViewController(educationContainerController, animated: true)
    }
    
    @IBAction func vehicleTextFieldValueChanged(_ sender: UITextField) {
        
        if let txt = sender.text, txt.count < 4 {
            return
        }
        
        if  !NetworkReachabilityManager()!.isReachable  {
            return
        }
        
        firstly {
            NetworkManager().doServiceCall(serviceType: .getVehicleDetailsForSearchedVehicleNo, params: ["vehicleSearchString": sender.text ?? ""], showLoader: false)
            }.then { [unowned self] response -> () in
                
                if let responseObject = response["responseObject"] as? [Dictionary<String,Any>]  {
                    
                    self.showVehicleList(array: responseObject)
                }
            }.catch { error in
                self.showError(error: error)
        }
    }
    
    func showVehicleList(array:[Dictionary<String,Any>]?) {
        
        if array != nil && array!.count > 0 {
            arr_vehicleList = array!
            tbl_vehicleList.reloadData()
            hideVehicleList(isHide: false)
        }else{
            arr_vehicleList = []
            tbl_vehicleList.reloadData()
            hideVehicleList(isHide: true)
        }
    }
    
    func hideVehicleList(isHide: Bool) {
        
        UIView.animate(withDuration: 0.25) {
            self.constraint_heightOfVehicleTbl.constant = isHide ? 0.0 : 132.0
            self.view.layoutIfNeeded() // Change to view.layoutIfNeeded()
        }
    }
}

extension DashboardController: MenuCellDelegte {
    func cellCllicked(action: SliderActions?) {
        
        guard let action = action else { return  }
        let str =  UIStoryboard(name: "Main", bundle: nil)
        var vc : UIViewController?
        switch action {
        case .Profile:
            vc = str.instantiateViewController(withIdentifier: "MyProfile") as! MyProfile
            
        case .Report:
            vc = UIStoryboard.init(name: "Reports", bundle: nil).instantiateViewController(withIdentifier: "ReportsContainerViewController")
            
        case .Setting:
            let _vc = str.instantiateViewController(withIdentifier: "SettingController") as! SettingController
            _vc.delegate = self
            vc = _vc
            
        case .Tutorial:
            
            let _vc = str.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialVC
            vc = _vc
            
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
                
                NetworkManager().doServiceCall(serviceType: .logoutCitizen, params: ["citizenId" : self.citizenId]).then { (response) -> () in
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
        self.meuClicked(UIBarButtonItem())
    }
}

extension DashboardController: DropDownDelgate {
    
    func selectedItems(_ items: [DropDownDataSource]) {
        drivingIssues = items
        var allIssues = ""
        for issue in drivingIssues {
            allIssues =  allIssues + issue.name! + ", "
        }

        
        if allIssues != "" {
            drivingIssuesLabel.text = String(describing: allIssues.prefix(allIssues.count-2))
            numberOfOffenceSelectedLabel.text = "\(items.count) "+"Offence(s) Selected".localized
        } else {
            drivingIssuesLabel.text = "Select Driving Issues".localized
            numberOfOffenceSelectedLabel.text = "No Offence Selected".localized
        }
    }
    
    private func catagoryIds() -> String {
        var ids = ""
        for id in drivingIssues {
            ids =  ids + id.id! + ","
        }
        return String(describing: ids.dropLast())
    }
}


extension DashboardController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        if vehicleFirstField != textField {
            return true
        }
        
        let aSet = CharacterSet.alphanumerics.inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}

extension DashboardController {
    
    @IBAction func openPhotoClicked(_ sender: Any) {
        
        if selectedImageForReport == nil {
            return
        }
        
        let zoomableImageViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomableImageViewVC") as! ZoomableImageViewVC
        zoomableImageViewVC.img = selectedImageForReport
        zoomableImageViewVC.modalPresentationStyle = .overCurrentContext
        present(zoomableImageViewVC, animated: true, completion: nil)
    }
    
    @IBAction func cameraClicked(_ sender: UIButton) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Add Photo!".localized, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction: UIAlertAction = UIAlertAction(title: "Take Photo".localized, style: .default) { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let galleryAction: UIAlertAction = UIAlertAction(title: "Choose From Gallery".localized, style: .default) { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(galleryAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image  = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
            selectedImage.image = image
            selectedImageForReport = image
        }
    }
}

extension DashboardController {
    private func makeVehicleDropDown() {
        vehicleTypeView.textColor = UIColor.darkText
        vehicleTypeView.tint = UIColor.clear
        vehicleTypeView.optionsTextColor = UIColor.darkText
        vehicleTypeView.hideOptionsWhenSelect = true
        vehicleTypeView.animationType = .Classic
        vehicleTypeView.tableHeight = 150
        vehicleTypeView.placeholder = "Select Vehicle Type".localized
        vehicleTypeView.options = ["Taxi".localized, "Tempo".localized, "Mini Bus".localized, "Bus".localized]
        vehicleTypeView.textAlignment = NSTextAlignment.left
        vehicleTypeView.font = "Poppins-Medium"
        vehicleTypeView.fontSize = 14.0
        vehicleTypeView.optionsFont = "Poppins-Regular"
        vehicleTypeView.optionsSize = 14.0
        vehicleTypeView.borderColor = .clear

        vehicleTypeView.didSelect { [unowned self] (option, index) in
            self.vehicleType = option
        }
    }
        
    private func makeDrivingIssuesCatagory() {
        let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "DropDownController") as! DropDownController
        vc.dropDownDelgate = self
        var drivingissues = [DropDownDataSource]()

        retriveJSONFrom(fileName: FileNames.response.rawValue).then { response -> () in
            let sresponse =  RegisterCitizenPushNotification.init(dictionary: response as NSDictionary)
            SharedSettings.shared.registerPushNotificationresponse = sresponse?.responseObject
            let drivingIssuesCatList = sresponse?.responseObject?.drivingIssueCategoryList
            if let drivingIssues = drivingIssuesCatList {
                for drivingIssu in drivingIssues {
                    switch self.selectedLanguage {
                    case "H":
                        drivingissues.append(DropDownDataSource(name: drivingIssu.hiName, id: drivingIssu.drivingIssueCategoryId, checkMark: false))
                    case "U":
                        drivingissues.append(DropDownDataSource(name: drivingIssu.urName, id: drivingIssu.drivingIssueCategoryId, checkMark: false))
                    default:
                        drivingissues.append(DropDownDataSource(name: drivingIssu.enName, id: drivingIssu.drivingIssueCategoryId, checkMark: false))
                    }
                }
            }
            
            var ccc = [DropDownDataSource]()
            if self.drivingIssues.count > 0 {
                for  var localDrivingissyes in drivingissues {
                    for d in self.drivingIssues {
                        if d.id == localDrivingissyes.id {
                            localDrivingissyes.checkMark = true
                        }
                    }
                    ccc.append(localDrivingissyes)
                }
            } else {
                ccc = drivingissues
            }
            
            vc.dropDownDataSource = ccc
            self.navigationController?.pushViewController(vc, animated: true)
            
            }.catch { error in
                self.showError(error: error)
        }
    }
}

extension DashboardController:SettingControllerProtocol {
    func language(chnaged: Bool) {
        setLocalizedText()
    }
    
    func setLocalizedText() {
        vehicleFirstField.placeholder = "Eg: JK".localized+" "+"only_letters_digits".localized
        vehicleNumber.text = "Vehicle Number".localized
        vehicleTypeView.placeholder = "Select Vehicle Type".localized
        drivingIssuesLabel.text = "Select Driving Issues".localized
        numberOfOffenceSelectedLabel.text = "No Offence Selected".localized
        descriptionText.placeholder = "Describe issue".localized
        educationLabel.text = "Education".localized
        helpLineLabel.text = "Helpline".localized
        emegencyLabel.text = "Emergency Contacts".localized
        reportInfraLabel.text = "Road Infra".localized
        reportButton.setTitle("Report".localized, for: .normal)
        cameraButton.setTitle("Photo".localized, for: .normal)
        makeVehicleDropDown()
        
    }
}

extension DashboardController:MFMessageComposeViewControllerDelegate {
     func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DashboardController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showNoRecod( arr_vehicleList.count == 0, viewOn: tableView)
        return arr_vehicleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cellID")
            cell?.selectionStyle = .none
        }
        
        cell?.textLabel?.text = "\(arr_vehicleList[indexPath.row]["vehicleNo"] as? String ?? "") - \(arr_vehicleList[indexPath.row]["make"] as? String ?? "")"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vehicleFirstField.text = arr_vehicleList[indexPath.row]["vehicleNo"] as? String ?? ""
        hideVehicleList(isHide: true)
    }
}
