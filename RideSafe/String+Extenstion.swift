//
//  String+Extenstion.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 07/04/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        
        if let _ = UserDefaults.standard.string(forKey: Localization.selectedLanguage.rawValue) {} else {
            // we set a default, just in case
            UserDefaults.standard.set("en", forKey: Localization.selectedLanguage.rawValue)
            UserDefaults.standard.synchronize()
        }
        
        
        let lang = UserDefaults.standard.string(forKey: Localization.selectedLanguage.rawValue)
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
