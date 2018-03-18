//
//  SettingController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 18/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

class SettingController: UIViewController {

     struct languageModel {
        var lanCode = ""
        var langName = ""
        var localName = ""
        var isChecked = false
    }
    var languages = [languageModel(lanCode:"en", langName: "English",localName:"", isChecked: false),
                     languageModel(lanCode:"hi", langName: "Hindi",localName:"हिन्दी", isChecked: false),
                     languageModel(lanCode:"ur", langName: "Urdu",localName:"اردو", isChecked: false)]
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
    }
    @IBAction func SaveClicked(_ sender: UIButton) {
       let selectedLanguage = languages.filter { $0.isChecked == true }.first
        UserDefaults.standard.set(selectedLanguage?.lanCode, forKey: "localizedLanguage")
        UserDefaults.standard.synchronize()
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if   let cell = tableView.dequeueReusableCell(withIdentifier: "language") as? LanguageCell{
            cell.textLabel?.text = languages[indexPath.row].langName
            cell.detailTextLabel?.text = languages[indexPath.row].localName
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectedBackgroundView?.backgroundColor = UIColor.clear
        cell?.accessoryType =  .checkmark
        languages[indexPath.row].isChecked = !languages[indexPath.row].isChecked
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
            languages[indexPath.row].isChecked = !languages[indexPath.row].isChecked
        }
    
}

extension String {
    var localized: String {
        
        if let _ = UserDefaults.standard.string(forKey: "localizedLanguage") {} else {
            // we set a default, just in case
            UserDefaults.standard.set("en", forKey: "localizedLanguage")
            UserDefaults.standard.synchronize()
        }

        
        let lang = UserDefaults.standard.string(forKey: "localizedLanguage")
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
