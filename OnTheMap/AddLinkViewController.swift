//
//  AddLinkViewController.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 11/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import MapKit
import SwiftyJSON

var isDismissed = false

class AddLinkViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var myLocation = ""
    var myCoordinate = CLLocationCoordinate2D()
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        
        isDismissed = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePin(_ sender: UIButton) {
        
        var myLink = ""
        
        if linkTextField.text != "" {
            
            myLink = linkTextField.text!
        }
        
        let userAccount = currentUser["account"] as! [String: Any]
        
        request.postUserLocation(uniqueKey: userAccount["key"] as! String, firstName: user["first_name"] as! String, lastName: user["last_name"] as! String, mapString: myLocation, media: myLink, latitude: myCoordinate.latitude, longitude: myCoordinate.longitude, controller: self, completion: {response in
            
            DispatchQueue.main.async(execute: {
                
                if let error = response["error"] {
                    
                    print("Error creating request: \(error)")
//                    helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error.localizedDescription, vc: self)
                }
                else if response["createdAt"] != nil {
                    
                    print("response arrived: \(response)")
                    print("nav controller: \(self.navigationController)")
                    self.dismiss(animated: false, completion: nil)
                    isDismissed = true
                }
                else {
                    
                    helper.giveErrorAlerts(response: response, vc: self)
                }
            })
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        linkTextField.attributedPlaceholder = NSAttributedString(string:"Add a link here", attributes:[NSForegroundColorAttributeName: UIColor.white])
        submitButton.layer.cornerRadius = 5
        
        self.indicator.startAnimating()
        forwardGeocoding(address: myLocation)
        mapView.delegate = self
        linkTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        linkTextField.resignFirstResponder()
        return true
    }
    
    //<-- Code Reference: Swift Development Blog (mhorga.org)
    var loader = LoadingOverlay()
    
    func forwardGeocoding(address: String) {
        
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            
            if error != nil {
                print("geocoding failed: \(error)")
                helper.giveErrorAlerts(errorString: "", errorMessage: "Geocoding Failed", vc: self)
            }
            
            else if placemarks!.count > 0 {
                
                print("animation started")
                
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("lat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                
                let latDelta:CLLocationDegrees = 10.0
                let lonDelta:CLLocationDegrees = 10.0
                let span = MKCoordinateSpanMake(latDelta, lonDelta)
                let region = MKCoordinateRegionMake(coordinate!, span)
                self.mapView.setRegion(region, animated: false)
                self.addPinOnMap(lat: coordinate!.latitude, long: coordinate!.longitude)
            }
        })
    }
    
    //Reference complete -->
    
    func addPinOnMap(lat: Double, long: Double) {
        
        let newAnnotation = MKPointAnnotation()
        let newCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: long)!)
        newAnnotation.coordinate = newCoordinate
        self.mapView.addAnnotation(newAnnotation)
        print("animation stopped")
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
    }
    
}
