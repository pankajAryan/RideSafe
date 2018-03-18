//
//  Services.swift
//  RideSafe
//
//  Created by Pankaj Yadav on 06/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import Foundation

enum ServiceType: String {
    case registerCitizen = "registerCitizen"
    case generateOtp =  "generateOtp"
    case verifyOtp =  "verifyOtp"
    case resendOtp = "resendOtp"
    case getDistrictList = "getDistrictList"
    case getEducationalMediaListByType = "getEducationalMediaListByType"
    case getCitizenProfile = "getCitizenProfile"
    case updateCitizenProfile = "updateCitizenProfile"
    case getDepartmentDirectoryListByDepartment = "getDepartmentDirectoryListByDepartment"
    case reportDrivingIssue = "reportDrivingIssue"

}


struct Environment {
    static let baseUrl = "http://139.59.81.101:8080/RideSafe/rest/service/"
}
