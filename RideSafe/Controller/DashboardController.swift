//
//  DashboardController.swift
//  sidebarmenu
//
//  Created by Devesh on 11/03/18.
//  Copyright © 2018 __SELF___. All rights reserved.
//

import UIKit
import UIDropDown

class DashboardController: UIViewController, MenuCellDelegte {
    
    @IBOutlet weak var vehicleTypeView: UIView!
    @IBOutlet weak var tableViewleadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenu: SideMenu!
    var vehicleType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu.menuCellDelegte = self
        self.navigationController?.navigationBar.isHidden = false
        self.view.bringSubview(toFront: self.sideMenu)
        makeVehicleDropDown()

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
           self.makeDrivingIssuesCatagory()

        }
        self.view.addSubview(dropDown)
    }
    
    func makeDrivingIssuesCatagory() {
        let vc = UIStoryboard(name: "DropDown", bundle: nil).instantiateViewController(withIdentifier: "DropDownController") as! DropDownController
        vc.dropDownDelgate = self
        vc.dropDownDataSource = [DropDownDataSource(name: "a", id: "1", checkMark: false),
                                 DropDownDataSource(name: "b", id: "2", checkMark: false),
                                 DropDownDataSource(name: "c", id: "3", checkMark: false),
                                 DropDownDataSource(name: "d", id: "4", checkMark: false),
                                 DropDownDataSource(name: "e", id: "5", checkMark: false),
                                 DropDownDataSource(name: "f", id: "6", checkMark: false),
                                 DropDownDataSource(name: "g", id: "7", checkMark: false),
                                 DropDownDataSource(name: "h", id: "8", checkMark: false)]
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    }
    @IBAction func educationClicked(_ sender: UIButton) {
    }
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
        print(items)
    }
}
