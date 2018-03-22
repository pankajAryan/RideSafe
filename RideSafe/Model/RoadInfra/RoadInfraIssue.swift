/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class RoadInfraIssue {
	public var roadInfraIssueCategoryId : Int?
	public var enName : String?
	public var hiName : String?
	public var urName : String?
	public var isActive : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let responseObject_list = RoadInfraIssue.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of RoadInfraIssue Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [RoadInfraIssue]
    {
        var models:[RoadInfraIssue] = []
        for item in array
        {
            models.append(RoadInfraIssue(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let responseObject = RoadInfraIssue(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: RoadInfraIssue Instance.
*/
	required public init?(dictionary: NSDictionary) {

		roadInfraIssueCategoryId = dictionary["roadInfraIssueCategoryId"] as? Int
		enName = dictionary["enName"] as? String
		hiName = dictionary["hiName"] as? String
		urName = dictionary["urName"] as? String
		isActive = dictionary["isActive"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.roadInfraIssueCategoryId, forKey: "roadInfraIssueCategoryId")
		dictionary.setValue(self.enName, forKey: "enName")
		dictionary.setValue(self.hiName, forKey: "hiName")
		dictionary.setValue(self.urName, forKey: "urName")
		dictionary.setValue(self.isActive, forKey: "isActive")

		return dictionary
	}

}
