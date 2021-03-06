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
    
    var postedByName : String?
    
    var latDelta:CLLocationDegrees = 0.02
    var longDelta:CLLocationDegrees = 0.02

    var issueLatitude:CLLocationDegrees = 0.01
    var issueLongitude:CLLocationDegrees = 0.01
    
    var locationArray:[CLLocation] = []
    var routeLine:MKPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        self.title = "Issue Location".localized
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake( issueLatitude, issueLongitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
        issueMapView.setRegion(region, animated: true)
        
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(issueLatitude, issueLongitude)
        let objectAnnotation = Artwork(name: postedByName ?? "", coordinate: pinLocation)
        issueMapView.addAnnotation(objectAnnotation)
        
        if locationArray.count > 0 {
            self.drawLineWithLocationArray(locationArray: locationArray)
        }
        
        self.issueMapView.delegate = self
    }
    
    func drawLineWithLocationArray(locationArray: [CLLocation]) {
        let pointCount = locationArray.count
        var coordinateArray:[CLLocationCoordinate2D] = []
        for location in locationArray {
            coordinateArray.append(location.coordinate)
        }
        self.routeLine  = MKPolyline.init(coordinates: coordinateArray, count: pointCount)
        self.issueMapView.setVisibleMapRect((routeLine?.boundingMapRect)!, animated: true)
        self.issueMapView.add(routeLine!)
    }
}

extension IssueMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer.init(polyline: self.routeLine!)
            pr.strokeColor = UIColor.red.withAlphaComponent(0.5)
            pr.lineWidth = 5
            return pr
        }
        
        return MKPolylineRenderer.init(polyline: self.routeLine!)
    }
}

class Artwork: NSObject, MKAnnotation {
    let name: String?
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate        
        super.init()
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return nil
    }
}

