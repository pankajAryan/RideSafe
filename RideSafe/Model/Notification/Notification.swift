/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Notification {
	public var id : String?
	public var imageURL : String?
	public var title : String?
	public var description : String?
	public var createdOn : String?
	public var postedBy : String?
	public var userType : String?
	public var link : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let responseObject_list = Notification.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Notification Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Notification]
    {
        var models:[Notification] = []
        for item in array
        {
            models.append(Notification(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let responseObject = Notification(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Notification Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		imageURL = dictionary["imageURL"] as? String
		title = dictionary["title"] as? String
		description = dictionary["description"] as? String
		createdOn = dictionary["createdOn"] as? String
		postedBy = dictionary["postedBy"] as? String
		userType = dictionary["userType"] as? String
		link = dictionary["link"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.imageURL, forKey: "imageURL")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.createdOn, forKey: "createdOn")
		dictionary.setValue(self.postedBy, forKey: "postedBy")
		dictionary.setValue(self.userType, forKey: "userType")
		dictionary.setValue(self.link, forKey: "link")

		return dictionary
	}

}
