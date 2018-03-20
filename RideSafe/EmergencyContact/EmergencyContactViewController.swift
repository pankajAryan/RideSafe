//
//  EmergencyContactViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 18/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import PromiseKit
import JFContactsPicker

class EmergencyContactViewController: UIViewController {

    @IBOutlet weak var contact1: UITextField!
    @IBOutlet weak var contact2: UITextField!
    @IBOutlet weak var contact3: UITextField!
    var  contactPickerScene: ContactsPicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadEmergencyContact() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getEmergencyContactsList, params: ["citizenId": citizenId])
            }.then { response -> () in
                let emergencyContactResponse = EmergencyContactResponce(dictionary: response as NSDictionary)
                let mediaList = emergencyContactResponse?.responseObject
            }.catch { (error) in
        }
    }
    

    @IBAction func button1Clicked(_ sender: Any) {
        contactPickerScene = ContactsPicker(delegate: self, multiSelection: false, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func button2Clicked(_ sender: Any) {
       contactPickerScene = ContactsPicker(delegate: self, multiSelection: false, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func button3Clicked(_ sender: Any) {
        contactPickerScene = ContactsPicker(delegate: self, multiSelection: false, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
   
    }
}

extension EmergencyContactViewController:  ContactsPickerDelegate {
    func contactPicker(_ : ContactsPicker, didSelectContact contact: Contact)
    {
        print("Contact \(contact.displayName) has been selected")
        contactPickerScene.dismiss(animated: true)
    }
    
}
