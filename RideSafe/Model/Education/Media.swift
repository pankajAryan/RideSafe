/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Media {
	public var educationalMediaId : Int?
	public var title : String?
	public var description : String?
	public var mediaURL : String?
	public var thumbnailURL : String?
	public var type : String?
	public var postedOn : String?
	public var isActive : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let responseObject_list = Media.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Media Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Media]
    {
        var models:[Media] = []
        for item in array
        {
            models.append(Media(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let responseObject = Media(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Media Instance.
*/
	required public init?(dictionary: NSDictionary) {

		educationalMediaId = dictionary["educationalMediaId"] as? Int
		title = dictionary["title"] as? String
		description = dictionary["description"] as? String
		mediaURL = dictionary["mediaURL"] as? String
		thumbnailURL = dictionary["thumbnailURL"] as? String
		type = dictionary["type"] as? String
		postedOn = dictionary["postedOn"] as? String
		isActive = dictionary["isActive"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.educationalMediaId, forKey: "educationalMediaId")
		dictionary.setValue(self.title, forKey: "title")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.mediaURL, forKey: "mediaURL")
		dictionary.setValue(self.thumbnailURL, forKey: "thumbnailURL")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.postedOn, forKey: "postedOn")
		dictionary.setValue(self.isActive, forKey: "isActive")

		return dictionary
	}

}
