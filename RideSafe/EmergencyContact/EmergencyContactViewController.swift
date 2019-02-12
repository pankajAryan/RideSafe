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

class EmergencyContactViewController: RideSafeViewController {

    @IBOutlet weak var contact1: UITextField!
    @IBOutlet weak var contact2: UITextField!
    @IBOutlet weak var contact3: UITextField!
    @IBOutlet weak var liveLocationSwitch: UISwitch!
    @IBOutlet weak var shareLiveLocationLabel: UILabel!

    var  contactPickerScene: ContactsPicker!
    var isContactAvailable = false
    var selectedTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadEmergencyContact()
        self.title = "Emergency Contacts"
        shareLiveLocationLabel.text = "Share Live Location".localized
        setBackButton()
        if let _ = ShareLiveLocation.shared.timer {
            liveLocationSwitch.setOn(true, animated: false)
        } else {
            liveLocationSwitch.setOn(false, animated: false)
        }
        
    }
    
    func loadEmergencyContact() {
        firstly{
            NetworkManager().doServiceCall(serviceType: .getEmergencyContactsList, params: ["citizenId": citizenId])
            }.then { response -> () in
                let emergencyContactResponse = EmergencyContactResponce(dictionary: response as NSDictionary)
                if let emergencyContact = emergencyContactResponse?.responseObject {
                    self.contact1.text = emergencyContact.emergencyContact1
                    self.contact2.text = emergencyContact.emergencyContact2
                    self.contact3.text = emergencyContact.emergencyContact3
                    self.isContactAvailable = true
                } else {
                    self.isContactAvailable = false
                }
            }.catch { (error) in
                self.showError(error: error)
        }
    }
    
    @IBAction func turnOffLiveLocation(_ sender: UISwitch) {
        
        if !liveLocationSwitch.isOn {
            print("location off")
            ShareLiveLocation.shared.timer?.invalidate()
            ShareLiveLocation.shared.counter = 0
            ShareLiveLocation.shared.timer = nil
        } else {
            ShareLiveLocation.shared.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(fetchLiveLocation), userInfo: nil, repeats: true)
            ShareLiveLocation.shared.setupLocationManager()
        }
    }
    @objc func fetchLiveLocation() {
        ShareLiveLocation.shared.setupLocationManager()
    }
    
    @IBAction func button1Clicked(_ sender: Any) {
        contactPickerScene = ContactsPicker(delegate: self, multiSelection: false, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
        selectedTextField = contact1
    }
    
    @IBAction func button2Clicked(_ sender: Any) {
       contactPickerScene = ContactsPicker(delegate: self, multiSelection: false, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
        selectedTextField = contact2
    }
    
    @IBAction func button3Clicked(_ sender: Any) {
        contactPickerScene = ContactsPicker(delegate: self, multiSelection: false, subtitleCellType: SubtitleCellValue.email)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
        selectedTextField = contact3
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
   
        var serviceType: ServiceType
        if self.isContactAvailable {
            serviceType = .updateEmergencyContacts
        } else {
            serviceType = .addEmergencyContacts
        }
        firstly{
            NetworkManager().doServiceCall(serviceType: serviceType, params: ["emergencyContact1": contact1.text!, "emergencyContact2": contact2.text!, "emergencyContact3": contact3.text!, "citizenId": citizenId])
            }.then { responce -> () in
                self.navigationController?.showToast(response: responce)
                self.navigationController?.popViewController(animated: true)
            }.catch { error in
                self.showError(error: error)
        }
    }
}

extension EmergencyContactViewController:  ContactsPickerDelegate {
    func contactPicker(_ : ContactsPicker, didSelectContact contact: Contact)
    {
        print("Contact \(contact.displayName) has been selected")
        contactPickerScene.dismiss(animated: true)
        
        let nonDigitCharacterSet = NSCharacterSet.decimalDigits.inverted
        
        selectedTextField.text = contact.phoneNumbers.first?.phoneNumber.components(separatedBy: nonDigitCharacterSet).joined(separator: "")
    }
    func contactPicker(_: ContactsPicker, didCancel error: NSError) {
        print("Cancel has been selected")
        contactPickerScene.dismiss(animated: true)
    }
}

extension EmergencyContactViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }

}
