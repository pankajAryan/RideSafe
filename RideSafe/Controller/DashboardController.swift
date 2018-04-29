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

class DashboardController: RideSafeViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var vehicleNumber: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var vehicleThirdField: UITextField!
    @IBOutlet weak var vehicleSecondField: UITextField!
    @IBOutlet weak var vehicleFirstField: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var drivingIssuesLabel: UILabel!
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
    
    var isFirstCallToPushNotificationAPI = true
    
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var helpLineLabel: UILabel!
    @IBOutlet weak var emegencyLabel: UILabel!
    @IBOutlet weak var reportInfraLabel: UILabel!
    @IBOutlet weak var reportButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupVehicleTypeDropDown()
        addtappinggestureRecognizerOnDrivingIssueLabel()
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFirstTimeLaunch.rawValue) == false {
            showWelcomeAlert()
        }
        imagePicker.delegate = self
        setupUI()
        setLocalizedText()

        NotificationCenter.default.addObserver(self, selector: #selector(fcmTokeUpdated), name: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
    }
    
    @objc func fcmTokeUpdated() {
        NotificationCenter.default.removeObserver(self)
        RegisterForCitizenPushNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RegisterForCitizenPushNotification()
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
        
        vehicleFirstField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        vehicleSecondField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        vehicleThirdField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
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
        
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        switch textField{
        case vehicleFirstField:
            if text?.count == 2 {
            vehicleSecondField.becomeFirstResponder()
            }
        case vehicleSecondField:
            if text?.count == 3 {
            vehicleThirdField.becomeFirstResponder()
            }
        case vehicleThirdField:
            if text?.count == 4 {
                vehicleThirdField.resignFirstResponder()
            }
        default:
            break
        }
        
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
                                                                                                     "language": selectedLanguage], showLoader: isFirstCallToPushNotificationAPI)
            }.then { [unowned self] response -> () in
                self.writeJSONTo(fileName: FileNames.response.rawValue, data: response)

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
    
    private func showWelcomeAlert() {
        if let vc = UIStoryboard(name: "WelcomeAlert", bundle: nil).instantiateViewController(withIdentifier: "WelcomeAlertController") as? WelcomeAlertController {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "isFirstTimeLaunch")
        }
    }
    
    @objc func tapFunction() {
        makeDrivingIssuesCatagory()
    }
    
    @IBAction func reportButtonClicked(_ sender: UIButton) {
        uploadImage()
    }
    
    
    private func clearInputFields() {
        descriptionText.resignFirstResponder()
        vehicleFirstField.text = ""
        vehicleSecondField.text = ""
        vehicleThirdField.text = " "
        vehicleType = ""
        drivingIssues = []
        descriptionText.text = ""
        descriptionText.placeholder = "Describe Issues".localized
        drivingIssuesLabel.text = "Select Driving Issues".localized
       // cameraButton.setBackgroundImage(#imageLiteral(resourceName: "camera"), for: .normal)
        selectedImage.image = #imageLiteral(resourceName: "camera")
        imageUrl = nil
        locationManager.stopUpdatingLocation()
        vehicleTypeView.options = []
        vehicleTypeView.placeholder = "Select Vehicle Type".localized
    }
    
    func reportIssues() {
        NetworkManager().doServiceCall(serviceType: .reportDrivingIssue, params: ["lat":"\(userLocation.latitude)",
            "lon": "\(userLocation.longitude)",
            "description": descriptionText.text,
            "categoryIds": catagoryIds(),
            "postedBy": citizenId,
            "uploadedImageURL": self.imageUrl ?? "",
            "vehicleNumber": vehicleFirstField.text! + vehicleSecondField.text! + vehicleThirdField.text! ,
            "vehicleType": vehicleType])
            .then { response -> () in
                self.clearInputFields()
                self.showToast(response: response)
            }.catch { error in
                self.showError(error: error)
        }
    }
    
    func uploadImage() {
        
        if (vehicleFirstField.text?.isEmpty)! || (vehicleSecondField.text?.isEmpty)! || (vehicleThirdField.text?.isEmpty)! || vehicleType.count == 0 || drivingIssues.count == 0 {
            let alert =  UIAlertController(title: "", message: "Veicle No,Vehicle type and Driving issues are mandatory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let image = selectedImage.image {
                NetworkManager().upload(image: image, serviceType: .uploadDrivingIssuePicture) .then { string -> () in
                    self.imageUrl = string
                    }.catch { error in
                        //self.showError(error: error)
                    }.always {
                        NetworkReachabilityManager()!.isReachable ? self.reportIssues() : self.sendSMS()
                }
            }
        }
    }
    
    
    func sendSMS() {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
          let body  = "JHQP3:lat: " + "\(userLocation.latitude)" + ":lon:" + "\(userLocation.longitude)" + ":desc:" + descriptionText.text + ":categoryIds:" + catagoryIds() + ":vehicleNumber:" + vehicleFirstField.text! + vehicleSecondField.text! + vehicleThirdField.text! + ":vehicleType:" + vehicleType
            controller.body = body
            controller.recipients = ["9220592205"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func meuClicked(_ sender: UIBarButtonItem) {
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
        } else {
            drivingIssuesLabel.text = "Select Driving Issues".localized
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
}

extension DashboardController {
    @IBAction func cameraClicked(_ sender: UIButton) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Add Photo!", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let galleryAction: UIAlertAction = UIAlertAction(title: "Choose From Gallery", style: .default) { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
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
        vehicleFirstField.placeholder = "Eg: JK".localized
        vehicleSecondField.placeholder = "Eg: 01C".localized
        vehicleThirdField.placeholder = "Eg: 1234".localized
        vehicleNumber.text = "Vehicle Number".localized
        vehicleTypeView.placeholder = "Select Vehicle Type".localized
        drivingIssuesLabel.text = "Select Driving Issues".localized
        descriptionText.placeholder = "Describe issue".localized
         educationLabel.text = "Education".localized
         helpLineLabel.text = "Help Line".localized
         emegencyLabel.text = "Emergency Contacts".localized
         reportInfraLabel.text = "Road Infra".localized
//        shareLiveLocationLabel.text =  "Share Live Location".localized
         reportButton.setTitle("Report".localized, for: .normal)
        cameraButton.setTitle("Photo".localized, for: .normal)
        makeVehicleDropDown()

    }
}

extension DashboardController:MFMessageComposeViewControllerDelegate {
     func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }

//    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
//        //... handle sms screen actions
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//
//    override func viewWillDisappear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
//    }
}
