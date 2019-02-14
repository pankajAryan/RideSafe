//
//  String+Extenstion.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 07/04/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        
        if let _ = UserDefaults.standard.string(forKey: Localization.selectedLanguage.rawValue) {} else {
            // we set a default, just in case
            UserDefaults.standard.set("E", forKey: Localization.selectedLanguage.rawValue)
            UserDefaults.standard.synchronize()
        }
        
        
        var lang = UserDefaults.standard.string(forKey: Localization.selectedLanguage.rawValue)
        
        //Hack ,no need of localization other than citizen
        let delegate =  UIApplication.shared.delegate as! AppDelegate
        if delegate.getuserType() != UserType.Citizen{
            lang = "E";
        }
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

/*
 Usage
 
 Just add .localized to your string, as such :
 
 "MyString".localized , MyString being a key in the Localizable.strings file
 */
