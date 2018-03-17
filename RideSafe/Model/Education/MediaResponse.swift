
import Foundation
 


public class MediaResponse {
	public var responseObject : Array<Media>?
	public var errorCode : Int?
	public var errorMessage : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [MediaResponse]
    {
        var models:[MediaResponse] = []
        for item in array
        {
            models.append(MediaResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

        if (dictionary["responseObject"] != nil) { responseObject = Media.modelsFromDictionaryArray(array: dictionary["responseObject"] as! NSArray) }
		errorCode = dictionary["errorCode"] as? Int
		errorMessage = dictionary["errorMessage"] as? String
	}
    
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.errorCode, forKey: "errorCode")
		dictionary.setValue(self.errorMessage, forKey: "errorMessage")

		return dictionary
	}

}
