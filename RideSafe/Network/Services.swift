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
    case reportDrivingIssue = "reportDrivingIssue" // dashboard report button clicked
    case registerCitizenPushNotificationId = "registerCitizenPushNotificationId"
    case addEmergencyContacts = "addEmergencyContacts"
    case updateEmergencyContacts = "updateEmergencyContacts"
    case getEmergencyContactsList = "getEmergencyContactsList"
    case uploadDrivingIssuePicture = "uploadDrivingIssuePicture"
    case reportRoadInfraIssue = "reportRoadInfraIssue"
    case getRoadInfraCategoryListByLanguage = "getRoadInfraCategoryListByLanguage"
    case uploadInfraIssuePicture = "uploadInfraIssuePicture"
    case getCitizenRoadInfraIssueList = "getCitizenRoadInfraIssueList"
    case getCitizenDrivingIssueList = "getCitizenDrivingIssueList"
    case getDrivingIssueListForFieldOfficial = "getDrivingIssueListForFieldOfficial"
    case getRoadInfraIssueListForFieldOfficial = "getRoadInfraIssueListForFieldOfficial"
    case getFellowFieldOfficialList = "getFellowFieldOfficialList"
    case updateDrivingIssue = "updateDrivingIssue"
    case logoutEscalationOfficia = "logoutEscalationOfficia"
    case logoutFieldOfficial = "logoutFieldOfficial"
    case recordCitizenLiveLocation = "recordCitizenLiveLocation"
    case getFieldOfficialById = "getFieldOfficialById"
}


struct Environment {
    static let baseUrl = "http://139.59.81.101:8080/RideSafe/rest/service/"
}
