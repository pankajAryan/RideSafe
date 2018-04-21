//
//  UIViewController+Extention.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 22/04/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func currentInstalledVersion() -> String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)!
    }
    
    public func launchAppStore() {
        let url = URL(string: "https://itunes.apple.com/app/id\(Environment.appID)") 
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]

        DispatchQueue.main.async {
            UIApplication.shared.open(url!, options: options, completionHandler: nil)
        }
    }
    
    func isForceUpdateRequired(for latestVersion: String?) -> Bool {
        
        if let forceUpdateVersion = latestVersion, forceUpdateVersion.count > 0, (currentInstalledVersion().compare(forceUpdateVersion, options: .numeric) == .orderedAscending) {
            return true
        } else {
            return false
        }
    }
    
}
