//
//  HelperFunctions.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 14/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Helper {
    
    func giveErrorAlerts(response: JSON, vc: UIViewController) {
        
        var alert = UIAlertController()
        
        switch response["status"].int! {
        case 403:
            alert = UIAlertController(title: "Error!", message: "\(response["error"].string!)", preferredStyle: .alert)
        case 500:
            alert = UIAlertController(title: "Error!", message: "Could not connect to the internet", preferredStyle: .alert)
        default:
            break
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func giveErrorAlerts(errorString: String, errorMessage: String, vc: UIViewController) {
        
        let alert = UIAlertController(title: "Error! \(errorString)", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func logout(response: JSON, viewController: UIViewController) {
        
        if let error = response.error {
            
            print("error creating request: \(error.localizedDescription)")
            helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error.localizedDescription, vc: viewController)
        }
        else if response != JSON.null {
            
            let allvcs = mainNav.viewControllers
            
            for eachVC in allvcs {
                
                if eachVC.isKind(of: ViewController.self) {
                    
                    let vc = eachVC as! ViewController
                    vc.loginManager.logOut()
                }
            }
            
            mainNav.popToRootViewController(animated: true)
        }
        
    }
    
    func postPin(response: JSON, viewController: UIViewController) {
        
        if let error = response.error {
            
            print("Error creating a request: \(error.localizedDescription)")
            helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error.localizedDescription, vc: viewController)
            
        }
        else if response["results"].array!.count > 0 {
            
            let alert = UIAlertController(title: nil, message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {_ in
                self.postStudentLocation(vc: viewController)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
        else {
            
            self.postStudentLocation(vc: viewController)
        }
    }
    
    func postStudentLocation(vc: UIViewController) {
        
        let setLocVC = vc.storyboard?.instantiateViewController(withIdentifier: "setLocationVC") as! SetLocationViewController
        vc.navigationController!.present(setLocVC, animated: true, completion: nil)
    }
    
    var allStudentLocations: [StudentInformation] = []
    
    func studentLocationJSONToStruct(response: [JSON]) {
        
        allStudentLocations = []
        
        for each in response {
            
            allStudentLocations.append(StudentInformation(firstName: each["firstName"].string!, lastName: each["lastName"].string!, key: each["uniqueKey"].string!, location: each["firstName"].string!, media: each["firstName"].string!))
            
            
        }
        
    }
    
}
