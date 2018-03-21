//
//  DashboardController.swift
//  sidebarmenu
//
//  Created by Devesh on 11/03/18.
//  Copyright © 2018 __SELF___. All rights reserved.
//

import UIKit
import UIDropDown
import CoreLocation
import PromiseKit

class DashboardController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var vehicleThirdField: UITextField!
    @IBOutlet weak var vehicleSecondField: UITextField!
    @IBOutlet weak var vehicleFirstField: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var drivingIssuesLabel: UILabel!
    @IBOutlet weak var vehicleTypeView: UIView!
    @IBOutlet weak var tableViewleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenu: SideMenu!
    @IBOutlet weak var cameraButton: UIButton!
    var dropDown = UIDropDown()
    var vehicleType = ""
    var drivingIssues:[DropDownDataSource] = []
    var imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var imageUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionText.placeholder = "Describe Issues"
        setupLocationManager()
        setupVehicleTypeDropDown()
        addtappinggestureRecognizerOnDrivingIssueLabel()
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFirstTimeLaunch.rawValue) == false {
            showWelcomeAlert()
        }
        imagePicker.delegate = self
        setupUI()
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
                                                                                                     "language": selectedLanguage])
            }.then { response -> () in
                self.writeJSONTo(fileName: FileNames.response.rawValue, data: response)
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
        descriptionText.placeholder = "Describe Issues"
        drivingIssuesLabel.text = "Select Driving Issues"
        cameraButton.setBackgroundImage(nil, for: .normal)
        imageUrl = nil
        locationManager.stopUpdatingLocation()
        dropDown.options = []
        dropDown.placeholder = "Select Vehicle Type"
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
        }
    }
    
    func uploadImage() {
        
        if (vehicleFirstField.text?.isEmpty)! || (vehicleSecondField.text?.isEmpty)! || (vehicleThirdField.text?.isEmpty)! || vehicleType.count == 0 || drivingIssues.count == 0 {
            let alert =  UIAlertController(title: "", message: "Veicle No,Vehicle type and Driving issues are mandatory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let image = cameraButton.currentBackgroundImage {
                NetworkManager().upload(image: image) .then { string -> () in
                    self.imageUrl = string
                    }.catch { error in
                    }.always {
                        self.reportIssues()
                }
            }
        }
    }
    
    
    @IBAction func meuClicked(_ sender: UIBarButtonItem) {
        tableViewleadingConstraint.constant = tableViewleadingConstraint.constant == 0 ? -240 : 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func roadInfraClicked(_ sender: UIButton) {
    }
    @IBAction func shareLiveLocationClicked(_ sender: UIButton) {
    }
    @IBAction func emergencyClicked(_ sender: UIButton) {
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
            vc = str.instantiateViewController(withIdentifier: "MyReport") as! MyReport
            
        case .Setting:
            vc = str.instantiateViewController(withIdentifier: "SettingController") as! SettingController
            
        case .About:
            vc = str.instantiateViewController(withIdentifier: "AboutRideSafe") as! AboutRideSafe
            
        case .Share: break
        case .Logout:
            clearUserDefault()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginController = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            self.navigationController?.pushViewController(loginController, animated: true)
            self.navigationController?.viewControllers = [loginController]
        }
        
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.meuClicked(UIBarButtonItem())
    }
}

extension DashboardController: DropDownDelgate{
    func selectedItems(_ items: [DropDownDataSource]) {
        drivingIssues = items
        var allIssues = ""
        for issue in drivingIssues {
            allIssues =  allIssues + issue.name! + ","
        }
        drivingIssuesLabel.text = String(describing: allIssues.dropLast())
        if drivingIssuesLabel.text == "" {
            drivingIssuesLabel.text = "Select Driving Issues"
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " "
        {
            return false
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        
        switch textField {
        case vehicleFirstField:
            return newString.length <= 2
        case vehicleSecondField:
            return  newString.length <= 3
            
        case vehicleThirdField:
            return newString.length <= 4
        default:
            return  true
        }
    }
    
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
            cameraButton.setBackgroundImage(image, for: .normal)
        }
    }
}

extension DashboardController {
    private func makeVehicleDropDown() {
        dropDown = UIDropDown(frame: vehicleTypeView.frame)
        dropDown.borderColor = .clear
        dropDown.textColor = UIColor.darkGray
        dropDown.hideOptionsWhenSelect = true
        dropDown.animationType = .Classic
        dropDown.tableHeight = 180
        dropDown.placeholder = "Select Vehicle Type"
        dropDown.options = ["Taxi", "Tempo", "Mini Bus", "Bus"]
        dropDown.textAlignment = NSTextAlignment.left
        
        dropDown.didSelect { [unowned self] (option, index) in
            self.vehicleType = option
        }
        self.view.addSubview(dropDown)
        
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
            
            }.catch { error in }
    }
}
