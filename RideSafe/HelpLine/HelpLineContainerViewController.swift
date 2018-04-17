//
//  HelpLineContainerViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 15/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import SWSegmentedControl
import UIDropDown
import PromiseKit

class HelpLineContainerViewController: RideSafeViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var popTableView: UITableView!
    @IBOutlet weak var segmentedController: SWSegmentedControl!
    var helpLineViewController: HelplineAdministrationViewController?
    private var selectedDistrictID:String = ""
    var districtList:[District] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Helpline"
        segmentedController.setTitle("ADMINISTRATION", forSegmentAt: 0)
        segmentedController.setTitle("MVD", forSegmentAt: 1)
        segmentedController.font = UIFont.init(name: "Poppins-Medium", size: 14.0)!

        segmentedController.backgroundColor = UIColor.white
        helpLineViewController = storyboard?.instantiateViewController(withIdentifier: "HelplineAdministrationViewController") as? HelplineAdministrationViewController
        helpLineViewController?.view.frame = CGRect.init(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height)
        self.containerView.addSubview((helpLineViewController?.view)!)
        self.addChildViewController(helpLineViewController!)
        setBackButton()
        getDistrict()
    }
    
    private func setRightButton(_ dictList: [District]?) {
        let rightButton = UIButton(type: .custom)
        rightButton.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 34))
        rightButton.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        rightButton.setTitle(getDistrictName(from: dictList)?.name, for: .normal)
        self.districtList = dictList!
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = UIFont.init(name: "Poppins-Medium", size: 11.0)!
        rightButton.setImage(#imageLiteral(resourceName: "dropdown-1"), for: .normal)
        rightButton.semanticContentAttribute = .forceRightToLeft

        rightButton.contentHorizontalAlignment = .right
        rightButton.contentVerticalAlignment = .center
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc func showDropDown() {
        if self.popTableView.alpha == 0.0 {
            self.popTableView.alpha = 1.0
            self.popTableView.reloadData()
        } else {
            self.popTableView.alpha = 0.0
        }
    }
    
    func getDistrictName(from districts:[District]?) -> District? {
        return  districts?.filter { $0.districtId == self.selectedDistrictID } .first
    }
    
    private func getDistrict() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getDistrictList, params: ["startIndex": "-1","searchString": "",
                                                                                   "length": "10","sortBy": "NAME",
                                                                                   "order": "A","status": "T"])
            }.then { response -> () in
                let json4Swift_Base = DistrictResponse(dictionary: response as NSDictionary)
                SharedSettings.shared.districtResponse = json4Swift_Base
            }.then { () -> () in
                self.getMyProfileData(citizenId: self.citizenId)
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
    fileprivate func getMyProfileData(citizenId:String) {
        NetworkManager().doServiceCall(serviceType: .getCitizenProfile, params: ["citizenId" : citizenId]).then { (response) -> () in
            let citizenProfile = CitizenProfile(dictionary: response as NSDictionary)
            let citizen = citizenProfile?.responseObject
            self.selectedDistrictID = citizen?.districtId ?? "no district"
            let dictList =  SharedSettings.shared.districtResponse?.responseObject?.districtList
            self.setRightButton(dictList)

            self.helpLineViewController?.districId = citizen?.districtId ?? dictList?[0].districtId
            self.helpLineViewController?.loadData()
            }.catch { (error) in
                self.showError(error: error)
        }
    }

    func switchtoAdministrationTab() {
        helpLineViewController?.selectedSegmented = 0
        helpLineViewController?.helpLineTableView.reloadData()
    }
    
    func switchMVDTab() {
        helpLineViewController?.selectedSegmented = 1
        helpLineViewController?.helpLineTableView.reloadData()
    }
    
    @IBAction func selectedSegmentedController(_ sender: SWSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            switchtoAdministrationTab()
        } else {
            switchMVDTab()
        }
    }

}


extension HelpLineContainerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.districtList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "DistrictCellIdentifier")!
        let district: District = self.districtList[indexPath.row]
        
        cell.textLabel?.text = district.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let district: District = self.districtList[indexPath.row]
        self.selectedDistrictID = district.districtId!
        tableView.alpha = 0.0
        self.helpLineViewController?.districId = district.districtId!
        self.helpLineViewController?.loadData()
        let rightButton: UIButton  = self.navigationItem.rightBarButtonItem?.customView as! UIButton
        rightButton.setTitle(district.name, for: .normal)
    }
   
}
