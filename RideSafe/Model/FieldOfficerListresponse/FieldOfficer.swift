/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class FieldOfficer {
	public var fieldOfficialId : String?
	public var departmentId : String?
	public var name : String?
	public var departmentName : String?
	public var designation : String?
	public var mobile : String?
	public var password : String?
	public var isActive : String?
	public var createdOn : String?
	public var updatedOn : String?
	public var lastLogin : String?
	public var deviceModel : String?
	public var deviceOS : String?
	public var pushNotificationId : String?
	public var loginStatus : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let responseObject_list = ResponseObject.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of ResponseObject Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [FieldOfficer]
    {
        var models:[FieldOfficer] = []
        for item in array
        {
            models.append(FieldOfficer(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let responseObject = ResponseObject(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: ResponseObject Instance.
*/
	required public init?(dictionary: NSDictionary) {

		fieldOfficialId = dictionary["fieldOfficialId"] as? String
		departmentId = dictionary["departmentId"] as? String
		name = dictionary["name"] as? String
		departmentName = dictionary["departmentName"] as? String
		designation = dictionary["designation"] as? String
		mobile = dictionary["mobile"] as? String
		password = dictionary["password"] as? String
		isActive = dictionary["isActive"] as? String
		createdOn = dictionary["createdOn"] as? String
		updatedOn = dictionary["updatedOn"] as? String
		lastLogin = dictionary["lastLogin"] as? String
		deviceModel = dictionary["deviceModel"] as? String
		deviceOS = dictionary["deviceOS"] as? String
		pushNotificationId = dictionary["pushNotificationId"] as? String
		loginStatus = dictionary["loginStatus"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.fieldOfficialId, forKey: "fieldOfficialId")
		dictionary.setValue(self.departmentId, forKey: "departmentId")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.departmentName, forKey: "departmentName")
		dictionary.setValue(self.designation, forKey: "designation")
		dictionary.setValue(self.mobile, forKey: "mobile")
		dictionary.setValue(self.password, forKey: "password")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.createdOn, forKey: "createdOn")
		dictionary.setValue(self.updatedOn, forKey: "updatedOn")
		dictionary.setValue(self.lastLogin, forKey: "lastLogin")
		dictionary.setValue(self.deviceModel, forKey: "deviceModel")
		dictionary.setValue(self.deviceOS, forKey: "deviceOS")
		dictionary.setValue(self.pushNotificationId, forKey: "pushNotificationId")
		dictionary.setValue(self.loginStatus, forKey: "loginStatus")

		return dictionary
	}

}
