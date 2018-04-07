//
//  SettingController.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 18/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit

protocol SettingControllerProtocol:class {
    func language(chnaged:Bool)
}

class SettingController: RideSafeViewController {

     struct languageModel {
        var lanCode = ""
        var langName = ""
        var localName = ""
        var isChecked = false
    }
    @IBOutlet weak var tabble: UITableView!
    weak var delegate:SettingControllerProtocol?
    var selectedIndexPath = IndexPath()
    
    var languages = [languageModel(lanCode:"E", langName: "English",localName:"", isChecked: false),
                     languageModel(lanCode:"H", langName: "Hindi",localName:"हिन्दी", isChecked: false),
                     languageModel(lanCode:"U", langName: "Urdu",localName:"اردو", isChecked: false)]
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        
    }
    
    @IBAction func SaveClicked(_ sender: UIButton) {
       let langselected = languages.filter { $0.isChecked == true }.first
        
        
        if langselected?.lanCode != selectedLanguage {
            UserDefaults.standard.set(langselected?.lanCode, forKey: Localization.selectedLanguage.rawValue)
            UserDefaults.standard.synchronize()
            delegate?.language(chnaged: true)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if   let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell") as? LanguageCell{
            cell.localizedLanguageName.text = languages[indexPath.row].localName
            cell.LanguageName.text = languages[indexPath.row].langName
            cell.accessoryType = self.selectedLanguage == languages[indexPath.row].lanCode ? .checkmark : .none
            if self.selectedLanguage == languages[indexPath.row].lanCode {
                selectedIndexPath = indexPath
                languages[indexPath.row].isChecked = true
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath != selectedIndexPath {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.selectedBackgroundView?.backgroundColor = UIColor.clear
            cell?.accessoryType = .checkmark
            languages[indexPath.row].isChecked = !languages[indexPath.row].isChecked
            
            let selectedCell = tableView.cellForRow(at: selectedIndexPath)
            selectedCell?.accessoryType = .none
            languages[selectedIndexPath.row].isChecked = false

            selectedIndexPath = indexPath
        }
        
    }
    
}
