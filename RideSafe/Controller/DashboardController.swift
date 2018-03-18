//
//  DashboardController.swift
//  sidebarmenu
//
//  Created by Devesh on 11/03/18.
//  Copyright © 2018 __SELF___. All rights reserved.
//

import UIKit
import UIDropDown
import SwiftLocation
import CoreLocation
import PromiseKit

class DashboardController: UIViewController {
    
    @IBOutlet weak var vehicleThirdField: UITextField!
    @IBOutlet weak var vehicleSecondField: UITextField!
    @IBOutlet weak var vehicleFirstField: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var drivingIssuesLabel: UILabel!
    @IBOutlet weak var vehicleTypeView: UIView!
    @IBOutlet weak var tableViewleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenu: SideMenu!
    var vehicleType = ""
    var drivingIssues:[DropDownDataSource] = []
    
    private var currentLocation:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Locator.requestAuthorizationIfNeeded()
        sideMenu.menuCellDelegte = self
        self.navigationController?.navigationBar.isHidden = false
        makeVehicleDropDown()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        drivingIssuesLabel.addGestureRecognizer(tapGesture)
        self.view.bringSubview(toFront: self.sideMenu)
    }
    
    @objc func tapFunction() {
        makeDrivingIssuesCatagory()
    }
    
    @IBAction func reportButtonClicked(_ sender: UIButton) {
        getLoation().then { location -> () in
            self.reportIssues(location: location)
            }.catch { error in
                print(error)
        }
    }
    
    private func makeVehicleDropDown() {
        let dropDown = UIDropDown(frame: vehicleTypeView.frame)
        dropDown.hideOptionsWhenSelect = true
        dropDown.animationType = .Classic
        dropDown.tableHeight = 180
        dropDown.placeholder = "Select Vehicle Type"
        dropDown.options = ["Taxi", "Tempo", "Mini Bus", "Bus"]
        dropDown.didSelect { [unowned self] (option, index) in
            self.vehicleType = option
        }
        self.view.addSubview(dropDown)
    }
    
    private func makeDrivingIssuesCatagory() {
        let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "DropDownController") as! DropDownController
        vc.dropDownDelgate = self
        var drivingissues = [DropDownDataSource]()
        
        retriveJSONFrom(fileName: "VerifyOTPResponse").then { response -> () in
            let sresponse =  VerifyOTPResponse.init(dictionary: response as NSDictionary)
            SharedSettings.shared.verifyOTPResponse = sresponse
            let drivingIssuesCatList = sresponse?.responseObject?.drivingIssueCategoryList
            if let drivingIssues = drivingIssuesCatList {
                for drivingIssu in drivingIssues {
                    drivingissues.append(DropDownDataSource(name: drivingIssu.enName, id: drivingIssu.drivingIssueCategoryId, checkMark: false))
                }
            }
            vc.dropDownDataSource = drivingissues
            self.navigationController?.pushViewController(vc, animated: true)
            
            }.catch { error in }
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
    
    func getLoation() -> Promise<CLLocation> {
        
        return Promise {fulfill,reject in
            Locator.currentPosition(accuracy: .room, onSuccess: { loc -> (Void) in
                fulfill(loc)
            }) { (err, loc) -> (Void) in
                reject(err)
            }
        }
    }
    
    
    func reportIssues(location:CLLocation) {
        NetworkManager().doServiceCall(serviceType: .reportDrivingIssue, params: ["lat":"\(location.coordinate.latitude)",
            "lon": "\(location.coordinate.longitude)",
            "description": descriptionText.text,
            "categoryIds": catagoryIds(),
            "postedBy": SharedSettings.shared.verifyOTPResponse?.responseObject?.citizenId ?? "",
            "uploadedImageURL": "h.png",
            "vehicleNumber": vehicleFirstField.text! + vehicleSecondField.text! + vehicleThirdField.text! ,
            "vehicleType": vehicleType])
            .then { response -> () in
                
            }.catch { error in
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
            vc = str.instantiateViewController(withIdentifier: "MyReport") as! MyReport
            
        case .Setting:
            vc = str.instantiateViewController(withIdentifier: "SettingController") as! SettingController
            
        case .About:
            vc = str.instantiateViewController(withIdentifier: "AboutRideSafe") as! AboutRideSafe
            
        case .Share: break
        case .Logout:  break
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
    }
    
    private func catagoryIds() -> String {
        var ids = ""
        for id in drivingIssues {
            ids =  ids + id.id! + ""
        }
        return String(describing: ids.dropLast())
    }
}
