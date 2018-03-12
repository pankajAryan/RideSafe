//
//  DashboardController.swift
//  sidebarmenu
//
//  Created by Devesh on 11/03/18.
//  Copyright © 2018 __SELF___. All rights reserved.
//

import UIKit

class DashboardController: UIViewController, MenuCellDelegte {
    
    @IBOutlet weak var sideMenu: SideMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu.menuCellDelegte = self
    }
    
    func cellCllicked(action: SliderActions?) {
        
        guard let action = action else { return  }
        
        switch action {
        case .Profile: break
        case .Report: break
        case .Setting: break
        case .About: break
        case .Share: break
        case .Logout: break
        }
    }
    
}
