//
//  DrivingIssueMapVC.swift
//  JK RideSafe
//
//  Created by Rahul Chaudhary on 11/07/18.
//  Copyright © 2018 Mobiquel. All rights reserved.
//

import UIKit
import MapKit

protocol FieldOfficerAnnotationViewDelegate : class {
    func buttonReassignAction(fieldOfficerAnnotation:FieldOfficerAnnotation?)
}

class FieldOfficerAnnotationView : UIView {
    
    @IBOutlet weak var lbl_detail: UILabel!
    @IBOutlet weak var btn_reassign: UIButton!
    @IBOutlet weak var constrain_heightReassignBtn: NSLayoutConstraint!

    weak var delegate : FieldOfficerAnnotationViewDelegate?
    weak var annotation : FieldOfficerAnnotation?

    @IBAction func reassignBtnAction(_ sender: Any) {
        
        delegate?.buttonReassignAction(fieldOfficerAnnotation: annotation)
    }
}

class DrivingIssueMapVC: RideSafeViewController {
    
    @IBOutlet weak var issueMapView: MKMapView!

    var drivingCaseLocationForAppResponse : DrivingCaseLocationForAppResponse?
    var drivingCaseId : String?
    var userTypeEnum : UserType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton()
        title = "Map View, Case # \(drivingCaseId ?? "")"
    
        userTypeEnum = UserType.Citizen.getTokenUserType(userType: self.userType)
        
        issueMapView.delegate = self
        getDrivingCaseLocationForApp()
    }
    
    //MARK:-
    
    fileprivate func getDrivingCaseLocationForApp() {
        
        NetworkManager().doServiceCall(serviceType: .getDrivingCaseLocationForApp, params: ["drivingCaseId" : drivingCaseId ?? ""]).then { response -> () in
            
            self.drivingCaseLocationForAppResponse = DrivingCaseLocationForAppResponse(dictionary: response as NSDictionary)
            self.showFieldOfficersOnMap()
            self.showRouteOnMap()
            self.issueMapView.showAnnotations(self.issueMapView.annotations, animated: true)

            }.catch { error in
                self.showError(error: error)
        }
    }

    func showFieldOfficersOnMap () {
    
        if let arr = drivingCaseLocationForAppResponse?.responseObject?.fieldOfficialList {
            for annotation in arr {
                
                let fieldOfficerAnnotation = FieldOfficerAnnotation.init(name: annotation.name, dateTime: annotation.lastLocationTimeStamp, number: annotation.mobile, id: annotation.fieldOfficialId, coordinate: CLLocationCoordinate2DMake(Double(annotation.lat ?? "0.0")!, Double(annotation.lon ?? "0.0")!))
                
                issueMapView.addAnnotation(fieldOfficerAnnotation)
            }
        }
    }
    
    func showRouteOnMap() {
        
        guard let arr = drivingCaseLocationForAppResponse?.responseObject?.drivingCaseLocationList, arr.count != 0 else {
            return
        }
        
        let startPoint = arr.first
        let endPoint = arr.last
        
        let pickupCoordinate = CLLocationCoordinate2DMake(Double(startPoint?.lat ?? "0.0")!, Double(startPoint?.lon ?? "0.0")!)
        let destinationCoordinate = CLLocationCoordinate2DMake(Double(endPoint?.lat ?? "0.0")!, Double(endPoint?.lon ?? "0.0")!)
        
        let sourceAnnotation = DrivingCaseLocationAnnotation.init(name: drivingCaseLocationForAppResponse?.responseObject?.postedByName, number: drivingCaseLocationForAppResponse?.responseObject?.mobile, coordinate: pickupCoordinate, image: #imageLiteral(resourceName: "location_start"))
        
        let destinationAnnotation = DrivingCaseLocationAnnotation.init(name: drivingCaseLocationForAppResponse?.responseObject?.postedByName, number: drivingCaseLocationForAppResponse?.responseObject?.mobile, coordinate: destinationCoordinate, image: #imageLiteral(resourceName: "locationcurrent"))
        
        issueMapView.addAnnotations([sourceAnnotation,destinationAnnotation])
        
        // Show route
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        if let arr = drivingCaseLocationForAppResponse?.responseObject?.drivingCaseLocationList {
            for annotation in arr {
                points.append(CLLocationCoordinate2DMake(Double(annotation.lat ?? "0.0")!, Double(annotation.lon ?? "0.0")!))
            }
        }
        
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        issueMapView.add(polyline)
    }
}
extension DrivingIssueMapVC: FieldOfficerAnnotationViewDelegate {
    
    func buttonReassignAction(fieldOfficerAnnotation: FieldOfficerAnnotation?) {
        NetworkManager().doServiceCall(serviceType: .reAssignDrivingCaseToFieldOfficial, params: ["drivingCaseId" : drivingCaseId ?? "", "assignedById" : citizenId, "assignedToId" : fieldOfficerAnnotation?.id ?? ""]).then { response -> () in
            
            print(response)
            self.navigationController?.popViewController(animated: true)
            }.catch { error in
                self.showError(error: error)
        }
    }
}

extension DrivingIssueMapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotation is FieldOfficerAnnotation {
            
            let identifier = "FieldOfficerAnnotationView"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
            
            let fieldOfficerAnnotation = annotation as! FieldOfficerAnnotation
            
            let views = Bundle.main.loadNibNamed("FieldOfficerAnnotationView", owner: nil, options: nil)
            let fieldOfficerAnnotationView = views?[0] as! FieldOfficerAnnotationView
           
            if userTypeEnum == .FieldOfficial {
                fieldOfficerAnnotationView.constrain_heightReassignBtn.constant = 35.0
            } else {
                fieldOfficerAnnotationView.constrain_heightReassignBtn.constant = 0.0
            }
            
            fieldOfficerAnnotationView.layer.cornerRadius = 2.0
            fieldOfficerAnnotationView.layer.masksToBounds = true
            
            fieldOfficerAnnotationView.btn_reassign.layer.cornerRadius = 2.0
            fieldOfficerAnnotationView.btn_reassign.layer.masksToBounds = true
            
            var str = fieldOfficerAnnotation.name
            
            if let timeStam = fieldOfficerAnnotation.dateTime {
                str?.append("\n")
                str?.append(timeStam)
            }
            
            if let number = fieldOfficerAnnotation.number {
                str?.append("\n")
                str?.append(number)
            }
            
            fieldOfficerAnnotationView.lbl_detail.text = str
            fieldOfficerAnnotationView.delegate = self
            fieldOfficerAnnotationView.annotation = annotation as? FieldOfficerAnnotation
            
            annotationView?.detailCalloutAccessoryView = fieldOfficerAnnotationView
            annotationView?.image = #imageLiteral(resourceName: "ic_action_official")
            
            return annotationView
            
        }else if annotation is DrivingCaseLocationAnnotation {
         
            let identifier = "DrivingCaseLocationAnnotation"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
            
            let drivingCaseLocationAnnotation = annotation as! DrivingCaseLocationAnnotation

            annotationView?.image = drivingCaseLocationAnnotation.image

            return annotationView
        }
        
        return nil
    }
}

class FieldOfficerAnnotation: NSObject, MKAnnotation {
    
    let name: String?
    let dateTime: String?
    let number: String?
    let id : String?
    var coordinate: CLLocationCoordinate2D
    
    init(name: String?, dateTime: String?, number: String?, id: String?, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.dateTime = dateTime
        self.number = number
        self.id = id
        self.coordinate = coordinate
        super.init()
    }
    
    var title: String? {
        return nil
    }
}


class DrivingCaseLocationAnnotation: NSObject, MKAnnotation {
    
    let name: String?
    let number: String?
    var coordinate: CLLocationCoordinate2D
    var image : UIImage?
    
    init(name: String?, number: String?, coordinate: CLLocationCoordinate2D, image: UIImage?) {
        self.name = name
        self.number = number
        self.coordinate = coordinate
        self.image = image
        super.init()
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return number
    }
}
