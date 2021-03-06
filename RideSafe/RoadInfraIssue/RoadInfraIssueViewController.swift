//
//  RoadInfraIssueViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 19/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit
import CoreLocation


class RoadInfraIssueViewController: RideSafeViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    @IBOutlet weak var issueTypesLabel: UILabel!
    @IBOutlet weak var lbl_infraIssueText: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var numberOfOffenceSelectedLabel: UILabel!
    @IBOutlet weak var issueDiscriptionTextView: UITextView!
    @IBOutlet weak var issueImageView: UIImageView!
    var imagePicker = UIImagePickerController()

    var selectedInfraIssueList: [DropDownDataSource] = []
    var infraIssueList: [DropDownDataSource] = []
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var issueImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Report Issue".localized
        issueDiscriptionTextView.placeholder = "Describe Issue".localized
        reportButton.setTitle("Report".localized, for: .normal)
        cameraButton.setTitle("Photo".localized, for: .normal)
        numberOfOffenceSelectedLabel.text = "No Offence Selected".localized
        lbl_infraIssueText.text = "Infra Issue".localized
        issueTypesLabel.text = "-Select-".localized

        loadIssueListAsperLanguage()
        addtapGestureOnIssueLabel()
        imagePicker.delegate = self
        setupLocationManager()
        setBackButton()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locVal = manager.location?.coordinate else { return }
        userLocation = locVal
        locationManager.stopUpdatingLocation()
    }
    
    func loadIssueListAsperLanguage() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getRoadInfraCategoryListByLanguage, params: ["language": selectedLanguage])
            }.then { response -> () in
                let roadinfraIssueResponse = RoadinfraIssueResponse(dictionary: response as NSDictionary)
                if let infraIssueList = roadinfraIssueResponse?.responseObject {
                    for infraIssue in infraIssueList {
                        var issueName: String = ""
                        switch self.selectedLanguage {
                            
                        case "H":
                            issueName = infraIssue.hiName!

                        case "E":
                            issueName = infraIssue.enName!

                        case "U":
                            issueName = infraIssue.urName!

                        default:
                            break
                            
                        }
                        let dropDownItem: DropDownDataSource = DropDownDataSource(name: issueName, id: infraIssue.roadInfraIssueCategoryId!, checkMark: false)
                        self.infraIssueList.append(dropDownItem)
                    }
                }
                
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
    
    
    
    private func addtapGestureOnIssueLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openIssueList))
        issueTypesLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func openIssueList() {
        dropdownButtonClicked(dropDownButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dropdownButtonClicked(_ sender: UIButton) {
        let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "DropDownController") as! DropDownController
        vc.dropDownDelgate = self

        var ccc = [DropDownDataSource]()
        if self.selectedInfraIssueList.count > 0 {
            for  var localInfraIssueList in infraIssueList {
                for d in self.selectedInfraIssueList {
                    if d.id == localInfraIssueList.id {
                        localInfraIssueList.checkMark = true
                    }
                }
                ccc.append(localInfraIssueList)
            }
        } else {
            ccc = infraIssueList
        }
        vc.dropDownDataSource = ccc

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openPhotoClicked(_ sender: Any) {
        
        if issueImage == nil {
            return
        }
        
        let zoomableImageViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ZoomableImageViewVC") as! ZoomableImageViewVC
        zoomableImageViewVC.img = issueImage
        zoomableImageViewVC.modalPresentationStyle = .overCurrentContext
        present(zoomableImageViewVC, animated: true, completion: nil)
    }
    
    @IBAction func openCameraClicked(_ sender: Any) {
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
            issueImageView.image = image
            issueImage = image
        }
    }
    
    @IBAction func reportButtonClicked(_ sender: Any) {
        
        if (issueDiscriptionTextView.text?.isEmpty)! || issueImage == nil || selectedInfraIssueList.count == 0 {
            let alert =  UIAlertController(title: "", message: "Infra issue type, Infra issue description and Infra issues image are mandatory", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let image = issueImage {
                NetworkManager().upload(image: image, serviceType: .uploadInfraIssuePicture) .then { string -> Promise<[String:Any]> in
                    
                    NetworkManager().doServiceCall(serviceType: .reportRoadInfraIssue, params: ["lat":"\(self.userLocation.latitude)",
                        "lon": "\(self.userLocation.longitude)",
                        "description": self.issueDiscriptionTextView.text,
                        "categoryIds": self.catagoryIds(),
                        "postedBy": self.citizenId,
                        "uploadedImageURL": string ?? ""])
                    
                    }.then { responce -> () in
                        self.navigationController?.showToast(response: responce)
                        self.navigationController?.popViewController(animated: true)
                    }.catch { error in
                        self.showError(error: error)
                    }
            }
        }
    }
    
}

extension RoadInfraIssueViewController: DropDownDelgate{
    func selectedItems(_ items: [DropDownDataSource]) {
        selectedInfraIssueList = items
        var allIssues = ""
        for issue in selectedInfraIssueList {
            allIssues =  allIssues + issue.name! + ", "
        }
        
        if allIssues != "" {
            issueTypesLabel.text = String(describing: allIssues.prefix(allIssues.count-2))
            numberOfOffenceSelectedLabel.text = "\(items.count) "+"Offence(s) Selected".localized
        } else {
            issueTypesLabel.text = "-Select-".localized
            numberOfOffenceSelectedLabel.text = "No Offence Selected".localized
        }
    }
    
    private func catagoryIds() -> String {
        var ids = ""
        for id in selectedInfraIssueList {
            ids =  ids + id.id! + ","
        }
        return String(describing: ids.dropLast())
    }
}
