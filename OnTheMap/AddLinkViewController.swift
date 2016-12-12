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

class AddLinkViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var myLocation = ""
    var myCoordinate = CLLocationCoordinate2D()
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePin(_ sender: UIButton) {
        
        var myLink = ""
        
        if linkTextField.text != "" {
            
            myLink = linkTextField.text!
        }
        
        request.postUserLocation(uniqueKey: currentUser["account"]["key"].string!, firstName: "Darth", lastName: "Vader", mapString: myLocation, media: myLink, latitude: myCoordinate.latitude, longitude: myCoordinate.longitude, completion: {response in
            
            DispatchQueue.main.async(execute: {
                
                if let error = response.error {
                    
                    print("Error creating request: \(error.localizedDescription)")
                }
                else if response["createdAt"] != JSON.null {
                    
                    print("response arrived: \(response)")
                    print("nav controller: \(self.navigationController)")
                    self.dismiss(animated: false, completion: nil)
                    isDismissed = true
                }
            })
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        linkTextField.attributedPlaceholder = NSAttributedString(string:"Add a link here", attributes:[NSForegroundColorAttributeName: UIColor.white])
        submitButton.layer.cornerRadius = 5
        
        forwardGeocoding(address: myLocation)
        
    }
    
    func forwardGeocoding(address: String) {
        
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error as Any)
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                self.addPinOnMap(lat: coordinate!.latitude, long: coordinate!.longitude)
//                if placemark!.areasOfInterest!.count > 0 {
//                    let areaOfInterest = placemark!.areasOfInterest![0]
//                    print(areaOfInterest)
//                } else {
//                    print("No area of interest found.")
//                }
            }
        })
    }
    
    func addPinOnMap(lat: Double, long: Double) {
        
        let newAnnotation = MKPointAnnotation()
        let newCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: long)!)
        newAnnotation.coordinate = newCoordinate
        self.mapView.addAnnotation(newAnnotation)
    }
    
}
