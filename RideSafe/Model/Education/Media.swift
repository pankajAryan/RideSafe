import Foundation


public class Media {
	public var educationalMediaId : Int?
	public var title : String?
	public var description : String?
	public var mediaURL : String?
	public var thumbnailURL : String?
	public var type : String?
	public var postedOn : String?
	public var isActive : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [Media]
    {
        var models:[Media] = []
        for item in array
        {
            models.append(Media(dictionary: item as! NSDictionary)!)
        }
        return models
    }

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
