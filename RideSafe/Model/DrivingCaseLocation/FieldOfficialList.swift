/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class FieldOfficialList {
	public var mobile : String?
	public var loginStatus : String?
	public var lastLocationTimeStamp : String?
	public var lon : String?
	public var fieldOfficialId : String?
	public var lat : String?
	public var name : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let fieldOfficialList_list = FieldOfficialList.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of FieldOfficialList Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [FieldOfficialList]
    {
        var models:[FieldOfficialList] = []
        for item in array
        {
            models.append(FieldOfficialList(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let fieldOfficialList = FieldOfficialList(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: FieldOfficialList Instance.
*/
	required public init?(dictionary: NSDictionary) {

		mobile = dictionary["mobile"] as? String
		loginStatus = dictionary["loginStatus"] as? String
		lastLocationTimeStamp = dictionary["lastLocationTimeStamp"] as? String
		lon = dictionary["lon"] as? String
		fieldOfficialId = dictionary["fieldOfficialId"] as? String
		lat = dictionary["lat"] as? String
		name = dictionary["name"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.mobile, forKey: "mobile")
		dictionary.setValue(self.loginStatus, forKey: "loginStatus")
		dictionary.setValue(self.lastLocationTimeStamp, forKey: "lastLocationTimeStamp")
		dictionary.setValue(self.lon, forKey: "lon")
		dictionary.setValue(self.fieldOfficialId, forKey: "fieldOfficialId")
		dictionary.setValue(self.lat, forKey: "lat")
		dictionary.setValue(self.name, forKey: "name")

		return dictionary
	}

}
