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
    var latDelta:CLLocationDegrees = 0.1
    var longDelta:CLLocationDegrees = 0.1

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
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
//        objectAnnotation.title = ""
        issueMapView.addAnnotation(objectAnnotation)
    }

}
