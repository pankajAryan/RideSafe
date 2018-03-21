//
//  NetworkManager.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 06/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit


class NetworkManager {
    
    func doServiceCall(serviceType:ServiceType, params:[String:String]) -> Promise<[String:Any]> {
        SwiftLoader.show(animated: true)
        let urlString = makeUrl(restUrl: serviceType.rawValue)
        return Promise { fullFilled , reject in
            Alamofire.request(urlString, method: .post, parameters: params).responseJSON {
                response in
                switch response.result {
                case .success:
                    if let response = response.value as? [String : Any]  {
                        #if DEBUG
                            print()
                            print("✅ service: \(serviceType.rawValue)\n✅ paramas: \(params)\n✅ response: \(response) ")
                        #endif
                        fullFilled(response)
                        SwiftLoader.hide()
                    }
                    break
                case .failure(let error):
                    #if DEBUG
                        print("❌ response code: \(String(describing:  response.response?.statusCode))")
                    #endif
                    reject(error)
                    SwiftLoader.hide()
                }
            }
        }
    }
    
    func upload(image: UIImage) -> Promise<String?> {
        guard let data = UIImageJPEGRepresentation(image, 0.5) else {
            return Promise(value: "Thsi is i ")
        }
        let urlString = makeUrl(restUrl: ServiceType.uploadDrivingIssuePicture.rawValue)

        
        return  Promise { fullfill,reject in
            Alamofire.upload(multipartFormData: { (form) in
                form.append(data, withName: "file", fileName: "file.jpg", mimeType: "multipart/form-data ")
            }, to: urlString, encodingCompletion: { result in
                switch result {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        print(response.value)
                        fullfill(response.value)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    reject(encodingError.localizedDescription as! Error)
                }
            })
        }
        
    }
    
    private func makeUrl(restUrl:String) -> String {
        let urlString =  Environment.baseUrl + restUrl
        return urlString
    }
}
