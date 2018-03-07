
import Foundation
import PromiseKit

 class Register {
	public var responseObject : Int?
	public var errorCode : Int?
	public var errorMessage : String?

	required public init?(dictionary: NSDictionary) {

		responseObject = dictionary["responseObject"] as? Int
		errorCode = dictionary["errorCode"] as? Int
		errorMessage = dictionary["errorMessage"] as? String
	}
}


