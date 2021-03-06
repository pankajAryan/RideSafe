//
//  SideMenu.swift
//  sidebarmenu
//
//  Created by Devesh on 11/03/18.
//  Copyright © 2018 __SELF___. All rights reserved.
//

import UIKit


protocol MenuCellDelegte:class {
    func cellCllicked(action:SliderActions?)
}

class SideMenu: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    weak var menuCellDelegte: MenuCellDelegte?
    
    var sliderData = [slideData(slideImage: #imageLiteral(resourceName: "ic_profile"), slideText: "My Profile",    action:.Profile),
                      slideData(slideImage: #imageLiteral(resourceName: "ic_my_report"), slideText: "My Reports",     action:.Report),
                      slideData(slideImage: #imageLiteral(resourceName: "ic_settings"), slideText: "Settings",       action:.Setting),
                      slideData(slideImage: #imageLiteral(resourceName: "tutorial"), slideText: "Tutorial",       action:.Tutorial),
                      slideData(slideImage: #imageLiteral(resourceName: "ic_about"), slideText: "About App",action:.About),
                      slideData(slideImage: #imageLiteral(resourceName: "ic_share"), slideText: "Share",         action:.Share),
                      slideData(slideImage: #imageLiteral(resourceName: "ic_logout"), slideText: "Logout",         action:.Logout)]
    
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        registerNib()
        
        if let usertype = UserDefaults.standard.string(forKey: UserDefaultsKeys.userType.rawValue) {
            if usertype != "C" {
                 sliderData = [slideData(slideImage: #imageLiteral(resourceName: "ic_profile"), slideText: "My Profile",    action:.Profile),
                                  slideData(slideImage: #imageLiteral(resourceName: "ic_about"), slideText: "About App",action:.About),
                                  slideData(slideImage: #imageLiteral(resourceName: "ic_share"), slideText: "Share",         action:.Share),
                                  slideData(slideImage: #imageLiteral(resourceName: "ic_logout"), slideText: "Logout",         action:.Logout)]
            }
        }
        
    }
    
    fileprivate func registerNib() {
        let nib = UINib(nibName: "MenuCell", bundle: nil)
        self.register(nib, forCellReuseIdentifier: "menuCell")
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuCell {
            let sliderModel = sliderData[indexPath.row]
            cell.sideImage.image = sliderModel.slideImage
            cell.sideText.text = sliderModel.slideText!.localized
            cell.action = sliderModel.action
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell ()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sliderData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell =  tableView.cellForRow(at: indexPath) as? MenuCell {
            menuCellDelegte?.cellCllicked(action: cell.action)
            self .deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell =  tableView.cellForRow(at: indexPath) as? MenuCell {
            cell.contentView.backgroundColor = UIColor.white
        }
    }
}

enum SliderActions {
    case Profile
    case Report
    case Setting
    case Tutorial
    case About
    case Share
    case Logout
}


struct slideData {
    var slideImage:UIImage?
    var slideText:String?
    var action:SliderActions?
}
