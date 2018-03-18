//
//  SharedSettings.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 17/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import Foundation

class SharedSettings {
    
    private init() { }
    static let shared = SharedSettings()
    var districtResponse:DistrictResponse?
    var verifyOTPResponse:VerifyOTPResponse?
}
