/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 

public class DistrictResponse {
	public var responseObject : DistrictList?
	public var errorCode : Int?
	public var errorMessage : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [DistrictResponse]
    {
        var models:[DistrictResponse] = []
        for item in array
        {
            models.append(DistrictResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		if (dictionary["responseObject"] != nil) { responseObject = DistrictList(dictionary: dictionary["responseObject"] as! NSDictionary) }
		errorCode = dictionary["errorCode"] as? Int
		errorMessage = dictionary["errorMessage"] as? String
	}


	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.responseObject?.dictionaryRepresentation(), forKey: "responseObject")
		dictionary.setValue(self.errorCode, forKey: "errorCode")
		dictionary.setValue(self.errorMessage, forKey: "errorMessage")

		return dictionary
	}

}
