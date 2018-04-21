//
//  ShareLiveLocation.swift
//  RideSafe
//
//  Created by Anand Mishra on 21/04/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit

class ShareLiveLocation:NSObject, CLLocationManagerDelegate {
    
    private override init() { }
    static let shared = ShareLiveLocation()
    var timer: Timer?
    var counter = 0
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var citizenId:String {
        get {
            guard let citizenId = UserDefaults.standard.string(forKey: UserDefaultsKeys.citizenId.rawValue) else { return "" }
            return citizenId
        }
    }


    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locVal = manager.location?.coordinate else { return }
        userLocation = locVal
        locationManager.stopUpdatingLocation()
        if self.timer != nil {
            counter = counter + 1
            let latitude: String = String(locVal.latitude)
            let longitude: String = String(locVal.longitude)
            self.updateServerWithLiveLocation(latitude: latitude, longitude: longitude)
        }
        
        if counter == 90 { // Stop Timer after 15 min
            timer?.invalidate()
            counter = 0
            timer = nil
        }
    }
    
    private func updateServerWithLiveLocation(latitude: String, longitude: String) {
        
        firstly {
            NetworkManager().doServiceCall(serviceType: .recordCitizenLiveLocation, params: ["citizenId": citizenId,
                                                                                             "lat":  latitude,
                                                                                             "lon": longitude], showLoader: false)
            }.then { response -> () in
                print(response)
            }.catch { (error) in
                
        }
    }
    
}
