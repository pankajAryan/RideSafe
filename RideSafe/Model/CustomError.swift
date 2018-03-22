//
//  BaseError.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 22/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import Foundation
protocol RideSafeErrorProtocol: LocalizedError {
    
    var errorMessage: String { get }
    var errorCode: String { get }
}
struct CustomError: RideSafeErrorProtocol {
    
    var errorMessage: String
    var errorCode: String
    
    init(errorMessage: String, errorCode: String) {
        self.errorMessage = errorMessage
        self.errorCode = errorCode
    }
}
