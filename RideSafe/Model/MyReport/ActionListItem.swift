/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class ActionListItem {
	public var action : String?
	public var status : String?
	public var createdOn : String?
	public var postedBy : String?
	public var userType : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [ActionListItem]
    {
        var models:[ActionListItem] = []
        for item in array
        {
            models.append(ActionListItem(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		action = dictionary["action"] as? String
		status = dictionary["status"] as? String
		createdOn = dictionary["createdOn"] as? String
		postedBy = dictionary["postedBy"] as? String
		userType = dictionary["userType"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.action, forKey: "action")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.createdOn, forKey: "createdOn")
		dictionary.setValue(self.postedBy, forKey: "postedBy")
		dictionary.setValue(self.userType, forKey: "userType")

		return dictionary
	}

}
