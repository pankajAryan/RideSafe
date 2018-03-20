/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class EmergencyConacts {
	public var emergencyContactId : String?
	public var emergencyContact1 : String?
	public var emergencyContact2 : String?
	public var emergencyContact3 : String?
	public var citizenId : String?
	public var citizenName : String?
	public var createdOn : String?
	public var updatedOn : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let responseObject_list = EmergencyConacts.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of EmergencyConacts Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [EmergencyConacts]
    {
        var models:[EmergencyConacts] = []
        for item in array
        {
            models.append(EmergencyConacts(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let responseObject = EmergencyConacts(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: EmergencyConacts Instance.
*/
	required public init?(dictionary: NSDictionary) {

		emergencyContactId = dictionary["emergencyContactId"] as? String
		emergencyContact1 = dictionary["emergencyContact1"] as? String
		emergencyContact2 = dictionary["emergencyContact2"] as? String
		emergencyContact3 = dictionary["emergencyContact3"] as? String
		citizenId = dictionary["citizenId"] as? String
		citizenName = dictionary["citizenName"] as? String
		createdOn = dictionary["createdOn"] as? String
		updatedOn = dictionary["updatedOn"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.emergencyContactId, forKey: "emergencyContactId")
		dictionary.setValue(self.emergencyContact1, forKey: "emergencyContact1")
		dictionary.setValue(self.emergencyContact2, forKey: "emergencyContact2")
		dictionary.setValue(self.emergencyContact3, forKey: "emergencyContact3")
		dictionary.setValue(self.citizenId, forKey: "citizenId")
		dictionary.setValue(self.citizenName, forKey: "citizenName")
		dictionary.setValue(self.createdOn, forKey: "createdOn")
		dictionary.setValue(self.updatedOn, forKey: "updatedOn")

		return dictionary
	}

}
