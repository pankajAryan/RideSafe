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
    
    func doServiceCall(serviceType:ServiceType, params:[String:String],showLoader: Bool = true) -> Promise<[String:Any]> {
        if showLoader {
            SwiftLoader.show(animated: true)
        }
        let urlString = makeUrl(restUrl: serviceType.rawValue)
        return Promise { fullFilled , reject in
            Alamofire.request(urlString, method: .post, parameters: params).responseJSON {
                response in
                switch response.result {
                case .success:
                    if let response = response.value as? [String : Any]  {
                        #if DEBUG
                            print("✅ service: \(serviceType.rawValue)\n paramas: \(params)\n response: \(response) ")
                        #endif
                        
                        let errorCode = String(describing: response["errorCode"]!)
                        if errorCode == "0" {
                                fullFilled(response)
                            } else {
                                let _error = CustomError(errorMessage: response["errorMessage"] as! String, errorCode:errorCode )
                                reject(_error)
                            }
                        SwiftLoader.hide()
                    }
//                    break
                case .failure(let error):
                    #if DEBUG
                        print("✅ service: \(serviceType.rawValue)\n paramas: \(params)\n response: \(response) ")
                        print("❌ response code: \(String(describing:  response.response?.statusCode))")
                    #endif
                    reject(error)
                    SwiftLoader.hide()
                }
            }
        }
    }
    
    func upload(image: UIImage, serviceType: ServiceType) -> Promise<String?> {
        
        guard let data = UIImageJPEGRepresentation(image, 0.5) else {
            return Promise(value: "")
        }
        
        let urlString = makeUrl(restUrl: serviceType.rawValue)
        SwiftLoader.show(animated: true)
        
        return  Promise { fullfill,reject in
            Alamofire.upload(multipartFormData: { (form) in
                form.append(data, withName: "file", fileName: "file.jpg", mimeType: "multipart/form-data ")
            }, to: urlString, encodingCompletion: { result in
                switch result {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        #if DEBUG
                            print("File uploaded sucessfully")
                            print(response.value ?? "response is blank")
                        #endif
                        fullfill(response.value)
                        SwiftLoader.hide()
                    }
                case .failure(let encodingError):
                    #if DEBUG
                        print("Uploading image failed with \(encodingError.localizedDescription)")
                    #endif
                    reject(encodingError.localizedDescription as! Error)
                    SwiftLoader.hide()
                }
            })
        }
        
    }
    
    private func makeUrl(restUrl:String) -> String {
        let urlString =  Environment.baseUrl + restUrl
        return urlString
    }
}
