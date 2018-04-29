/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class DrivingIssuesCategoryList {
	public var isRegistered : String?
	public var userType : String?
    public var token : String?
	public var fieldOfficialId : String?
	public var citizenId : String?
	public var escalationLevel : String?
	public var escalationOfficialId : String?
	public var drivingIssueCategoryList : Array<DrivingIssueCategory>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let responseObject_list = DrivingIssuesCategoryList.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of DrivingIssuesCategoryList Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [DrivingIssuesCategoryList]
    {
        var models:[DrivingIssuesCategoryList] = []
        for item in array
        {
            models.append(DrivingIssuesCategoryList(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let responseObject = DrivingIssuesCategoryList(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: DrivingIssuesCategoryList Instance.
*/
	required public init?(dictionary: NSDictionary) {

		isRegistered = dictionary["isRegistered"] as? String
		userType = dictionary["userType"] as? String
		fieldOfficialId = dictionary["fieldOfficialId"] as? String
		citizenId = dictionary["citizenId"] as? String
        token = dictionary["token"] as? String
		escalationLevel = dictionary["escalationLevel"] as? String
		escalationOfficialId = dictionary["escalationOfficialId"] as? String
        if (dictionary["drivingIssueCategoryList"] != nil) { drivingIssueCategoryList = DrivingIssueCategory.modelsFromDictionaryArray(array: dictionary["drivingIssueCategoryList"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.isRegistered, forKey: "isRegistered")
		dictionary.setValue(self.userType, forKey: "userType")
		dictionary.setValue(self.fieldOfficialId, forKey: "fieldOfficialId")
		dictionary.setValue(self.citizenId, forKey: "citizenId")
		dictionary.setValue(self.escalationLevel, forKey: "escalationLevel")
		dictionary.setValue(self.escalationOfficialId, forKey: "escalationOfficialId")

		return dictionary
	}

}
