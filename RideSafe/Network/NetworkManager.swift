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
        let urlString = makeUrl(restUrl: serviceType.rawValue)
        return Promise { fullFilled , reject in
            Alamofire.request(urlString, method: .post, parameters: params).responseJSON {
                response in
                switch response.result {
                case .success:
                    if let response = response.value as? [String : Any]  {
                        fullFilled(response)
                    }
                    break
                case .failure(let error):
                    print(error)
                    reject(error)
                }
            }
        }
    }
    
    private func makeUrl(restUrl:String) -> String {
        let urlString =  Environment.baseUrl + restUrl
        return urlString
    }
}
