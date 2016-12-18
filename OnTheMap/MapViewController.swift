//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 06/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var userUniqueId = ""
    var annotations = [MKPointAnnotation]()
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        mapView.removeAnnotations(annotations)
        getAllStudentLocations()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        request.logoutUserUdacity(controller: self, completion: { response in
            
            DispatchQueue.main.async {
                
                helper.logout(response: response, viewController: self)
            }
        })
    }
    
    @IBAction func placePin(_ sender: UIBarButtonItem) {
        
        request.getSingleUserLocation(key: currentUser["account"]["key"].string!, vc: self, completion: { response in
            
            DispatchQueue.main.async(execute: {
                
                helper.postPin(response: response, viewController: self)
            })
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        userUniqueId = currentUser["account"]["key"].string!
            
        getStudentDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if helper.allStudentLocations.count == 0 {
            
            getAllStudentLocations()
        }
    }
    
    func getStudentDetails() {
        
        request.getUserData(uniqueKey: currentUser["account"]["key"].string!, controller: self, completion: { response in
            
            if let error = response.error {
                
                helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error.localizedDescription, vc: self)
            }
            else if response["status"].string != nil {
                
                helper.giveErrorAlerts(response: response, vc: self)
            }
            else if response != JSON.null {
                
                print("response arrived student details")
                user = response["user"]
            }
        })
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                print("media url: \(toOpen)")
    
                if toOpen != "" {
                    app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func getAllStudentLocations() {
        
        request.getMultipleUserLocations(sorting: true, controller: self, completion: {response in
            
            DispatchQueue.main.async {
                
                let results = helper.allStudentLocations(response: response, controller: self)
                
                if results.0 {
                    
                    self.getPins(results: results.1)
                }
            }
        })
    }
    
    func getPins(results: [StudentInformation]) {
        
        let allStudentInfo = results
        
        for dictionary in allStudentInfo {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(Double(dictionary.location.latitude))
//            print("lat: \(lat)")
            let long = CLLocationDegrees(Double(dictionary.location.longitiude))
//            print("long: \(long)")
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            var first = ""
            
            if dictionary.firstName != nil && dictionary.firstName != "" {
                first = dictionary.firstName
            }
            
            var last = ""
            
            if dictionary.lastName != nil && dictionary.lastName != "" {
                last = dictionary.lastName
            }
            
            var mediaURL = ""
            
            if dictionary.media != nil && dictionary.media != "" {
                mediaURL = dictionary.media
            }
            
            print("creating annotations \(lat) \(long)")
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
}
