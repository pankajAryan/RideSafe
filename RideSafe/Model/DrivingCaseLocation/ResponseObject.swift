/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class ResponseObject {
	public var mobile : String?
	public var postedByName : String?
	public var lon : String?
	public var createdOn : String?
	public var postedBy : String?
	public var lat : String?
	public var fieldOfficialList : Array<FieldOfficialList>?
	public var fieldOfficialId : String?
	public var drivingCaseLocationList : Array<DrivingCaseLocationList>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let responseObject_list = ResponseObject.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of ResponseObject Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ResponseObject]
    {
        var models:[ResponseObject] = []
        for item in array
        {
            models.append(ResponseObject(dictionary: item as! NSDictionary)!)
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

		mobile = dictionary["mobile"] as? String
		postedByName = dictionary["postedByName"] as? String
		lon = dictionary["lon"] as? String
		createdOn = dictionary["createdOn"] as? String
		postedBy = dictionary["postedBy"] as? String
		lat = dictionary["lat"] as? String
        if (dictionary["fieldOfficialList"] != nil) { fieldOfficialList = FieldOfficialList.modelsFromDictionaryArray(array: dictionary["fieldOfficialList"] as! NSArray) }
		fieldOfficialId = dictionary["fieldOfficialId"] as? String
        if (dictionary["drivingCaseLocationList"] != nil) { drivingCaseLocationList = DrivingCaseLocationList.modelsFromDictionaryArray(array: dictionary["drivingCaseLocationList"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.mobile, forKey: "mobile")
		dictionary.setValue(self.postedByName, forKey: "postedByName")
		dictionary.setValue(self.lon, forKey: "lon")
		dictionary.setValue(self.createdOn, forKey: "createdOn")
		dictionary.setValue(self.postedBy, forKey: "postedBy")
		dictionary.setValue(self.lat, forKey: "lat")
		dictionary.setValue(self.fieldOfficialId, forKey: "fieldOfficialId")

		return dictionary
	}

}
