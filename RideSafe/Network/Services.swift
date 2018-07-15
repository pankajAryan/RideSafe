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
    case getDistrictListForApp = "getDistrictListForApp"
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
    case logoutFieldOfficial = "logoutFieldOfficial"
    case recordCitizenLiveLocation = "recordCitizenLiveLocation"
    case getFieldOfficialById = "getFieldOfficialById"
    case getNotificationListForUserType = "getNotificationListForUserType"
    case rateDrivingIssueByCitizen =  "rateDrivingIssueByCitizen"
    case reOpenDrivingIssueByCitizen = "reOpenDrivingIssueByCitizen"
    case logoutCitizen = "logoutCitizen"
    case registerFieldOfficialPushNotificationId = "registerFieldOfficialPushNotificationId"
    // Escalation official apis
    case getDrivingIssueListForEscalationLevel1 = "getDrivingIssueListForEscalationLevel1"
    case getDrivingIssueListForEscalationLevel2 = "getDrivingIssueListForEscalationLevel2"
    case getDrivingIssueListForEscalationOfficer = "getDrivingIssueListForEscalationOfficer"
    case getEscalationOfficialById              = "getEscalationOfficialById"
    case logoutEscalationOfficial               = "logoutEscalationOfficial"
    case registerEscalationOfficialPushNotificationId = "registerEscalationOfficialPushNotificationId"

    case reAssignDrivingCaseToFieldOfficial = "reAssignDrivingCaseToFieldOfficial"
    case getDrivingCaseLocationForApp = "getDrivingCaseLocationForApp"

    case noService = ""
}


struct Environment {
    static let baseUrl = "http://ridesafe.jk.gov.in:8080/RideSafe/rest/service/"
    static let appID = "123456"
}
