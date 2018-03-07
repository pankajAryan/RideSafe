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
}


struct Environment {
    static let baseUrl = "http://139.59.36.168:8080/RideSafe/rest/service/"
}
