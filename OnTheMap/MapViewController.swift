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
        
        self.mapView.removeAnnotations(annotations)
        getAllStudentLocations()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        request.logoutUserUdacity(completion: { response in
            
            DispatchQueue.main.async {
                
                if let error = response.error {
                    
                    print("error creating request: \(error.localizedDescription)")
                }
                else if response != JSON.null {
                    
                    let allvcs = self.navigationController!.viewControllers
                    
                    for eachVC in allvcs {
                        
                        if eachVC.isKind(of: ViewController.self) {
                            
                            let vc = eachVC as! ViewController
                            vc.loginManager.logOut()
                        }
                    }
                    
                    self.navigationController!.popToRootViewController(animated: true)
                }
            }
        })
    }
    
    @IBAction func placePin(_ sender: UIBarButtonItem) {
        
        request.getSingleUserLocation(key: currentUser["account"]["key"].string!, completion: { response in
            
            DispatchQueue.main.async(execute: {
                
                if let error = response.error {
                    
                    print("Error creating a request: \(error.localizedDescription)")
                    
                }
                else if response["results"].array!.count > 0 {
                        
                    let alert = UIAlertController(title: nil, message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {_ in
                        self.postStudentLocation()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    
                    self.postStudentLocation()
                }
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        userUniqueId = currentUser["account"]["key"].string!
        getAllStudentLocations()
    }
    
    func postStudentLocation() {
        
        let setLocVC = self.storyboard?.instantiateViewController(withIdentifier: "setLocationVC")
        self.navigationController!.present(setLocVC!, animated: true, completion: nil)
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
        
        var results: [JSON] = []
        
        request.getMultipleUserLocations(completion: {response in
                
            DispatchQueue.main.async(execute: {
                
                if let error = response.error {
                    
                    print("Error creating request: \(error.localizedDescription)")
                }
                else if response["results"] != JSON.null {
                    
                    results = response["results"].array!
                    self.getPins(results: results)
                    
                }
                else {
                    
                    print("Response error!")
                }
            })
        })
    }
    
    var locations: [JSON] = []
    
    func getPins(results: [JSON]) {
        
        locations = results
        
//        print("locations: \(locations)")
        
        for dictionary in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(Double(dictionary["latitude"].int!))
//            print("lat: \(lat)")
            let long = CLLocationDegrees(Double(dictionary["longitude"].int!))
//            print("long: \(long)")
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            var first = ""
            
            if dictionary["firstName"].string != nil && dictionary["firstName"] != "" {
                first = dictionary["firstName"].string!
            }
            
            var last = ""
            
            if dictionary["lastName"].string != nil && dictionary["lastName"] != "" {
                last = dictionary["lastName"].string!
            }
            
            var mediaURL = ""
            
            if dictionary["mediaURL"].string != nil && dictionary["mediaURL"] != "" {
                mediaURL = dictionary["mediaURL"].string!
            }
            
            
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
