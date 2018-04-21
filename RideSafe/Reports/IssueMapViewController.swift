//
//  IssueMapViewController.swift
//  RideSafe
//
//  Created by Anand Mishra on 25/03/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import MapKit

class IssueMapViewController: RideSafeViewController {
    @IBOutlet weak var issueMapView: MKMapView!
    var latDelta:CLLocationDegrees = 0.02
    var longDelta:CLLocationDegrees = 0.02

    var issueLatitude:CLLocationDegrees = 0.01
    var issueLongitude:CLLocationDegrees = 0.01

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        self.title = "Issue report location"
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake( issueLatitude, issueLongitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
        issueMapView.setRegion(region, animated: true)
        
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(issueLatitude, issueLongitude)
        let objectAnnotation = Artwork(title: "\(issueLatitude), \(issueLongitude)", locationName: "", discipline: "", coordinate: pinLocation)
        issueMapView.addAnnotation(objectAnnotation)

    }
}

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

