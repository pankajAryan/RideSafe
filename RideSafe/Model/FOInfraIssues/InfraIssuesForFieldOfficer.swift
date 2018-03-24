/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import UIKit
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class InfraIssuesForFieldOfficer {
	public var roadInfraIssueId : String?
	public var lat : Double?
	public var lon : Double?
	public var description : String?
	public var category : String?
	public var categoryName : String?
	public var postedBy : String?
	public var postedByName : String?
	public var uploadedImageURL : String?
	public var createdOn : String?
	public var status : String?
	public var action : String?
	public var updatedBy : String?
	public var updatedByName : String?
	public var postedByMobile : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let responseObject_list = InfraIssuesForFieldOfficer.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of InfraIssuesForFieldOfficer Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [InfraIssuesForFieldOfficer]
    {
        var models:[InfraIssuesForFieldOfficer] = []
        for item in array
        {
            models.append(InfraIssuesForFieldOfficer(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let responseObject = InfraIssuesForFieldOfficer(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: InfraIssuesForFieldOfficer Instance.
*/
	required public init?(dictionary: NSDictionary) {

		roadInfraIssueId = dictionary["roadInfraIssueId"] as? String
		lat = dictionary["lat"] as? Double
		lon = dictionary["lon"] as? Double
		description = dictionary["description"] as? String
		category = dictionary["category"] as? String
		categoryName = dictionary["categoryName"] as? String
		postedBy = dictionary["postedBy"] as? String
		postedByName = dictionary["postedByName"] as? String
		uploadedImageURL = dictionary["uploadedImageURL"] as? String
		createdOn = dictionary["createdOn"] as? String
		status = dictionary["status"] as? String
		action = dictionary["action"] as? String
		updatedBy = dictionary["updatedBy"] as? String
		updatedByName = dictionary["updatedByName"] as? String
		postedByMobile = dictionary["postedByMobile"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.roadInfraIssueId, forKey: "roadInfraIssueId")
		dictionary.setValue(self.lat, forKey: "lat")
		dictionary.setValue(self.lon, forKey: "lon")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.category, forKey: "category")
		dictionary.setValue(self.categoryName, forKey: "categoryName")
		dictionary.setValue(self.postedBy, forKey: "postedBy")
		dictionary.setValue(self.postedByName, forKey: "postedByName")
		dictionary.setValue(self.uploadedImageURL, forKey: "uploadedImageURL")
		dictionary.setValue(self.createdOn, forKey: "createdOn")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.action, forKey: "action")
		dictionary.setValue(self.updatedBy, forKey: "updatedBy")
		dictionary.setValue(self.updatedByName, forKey: "updatedByName")
		dictionary.setValue(self.postedByMobile, forKey: "postedByMobile")

		return dictionary
	}

   public var statusImage:UIImage {
        get {
            return   self.status == "RESOLVED" ? #imageLiteral(resourceName: "ic_status_resolved") :#imageLiteral(resourceName: "ic_status_pending")
        }
    }
}
