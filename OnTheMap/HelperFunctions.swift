//
//  HelperFunctions.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 14/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    var allStudentLocations: [StudentInformation] = []
    
    func giveErrorAlerts(response: [String: Any], vc: UIViewController) {
        
//        var alert = UIAlertController(title: "Error!", message: "\(response["error"].string!)", preferredStyle: .alert)
        
        if let responseError: String = response["error"] as? String {
            
            let errorSplit = responseError.components(separatedBy: ":")
            giveErrorAlerts(errorString: "", errorMessage: errorSplit.last!, vc: vc)
        }
        
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        vc.present(alert, animated: true, completion: nil)
    }
    
    func giveErrorAlerts(errorString: String, errorMessage: String, vc: UIViewController) {
        
        let alert = UIAlertController(title: "Error! \(errorString)", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func logout(response: [String: Any], viewController: UIViewController) {
        
        if let error = response["error"] {
            
            print("error creating request: \(error)")
            helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error as! String, vc: viewController)
        }
        else if response != nil {
            
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
    
    func postPin(response: [String: Any], viewController: UIViewController) {
        
        if let error = response["error"] {
            
            print("Error creating a request: \(error)")
            helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error as! String, vc: viewController)
            
        }
        else if let myResponse: [[String: Any]] = response["results"] as? [[String : Any]] {
            
            if myResponse.count > 0 {
                
                let alert = UIAlertController(title: nil, message: "You have already posted a student location. Would you like to overwrite your current location?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: {_ in
                    self.postStudentLocation(vc: viewController)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
            }
        }
        else {
            
            self.postStudentLocation(vc: viewController)
        }
    }
    
    func postStudentLocation(vc: UIViewController) {
        
        let setLocVC = vc.storyboard?.instantiateViewController(withIdentifier: "setLocationVC") as! SetLocationViewController
        vc.navigationController!.present(setLocVC, animated: true, completion: nil)
    }
    
    func studentLocationJSONToStruct(response: [[String: Any]]) -> [StudentInformation] {
        
        allStudentLocations = []
        
//        let theResponse: [String: Any] = response as! [String: Any]
        
        for each in response {
            
            
            let first = makeVariables(variable: each["firstName"] as? String)
            let last = makeVariables(variable: each["lastName"] as? String)
            let unique = makeVariables(variable: each["uniqueKey"] as? String)
            let lati = makeVariables(variable: each["latitude"] as? Double)
            let longi = makeVariables(variable: each["longitude"] as? Double)
            let map = makeVariables(variable: each["mapString"] as? String)
            let media = makeVariables(variable: each["mediaURL"] as? String)
            
            let info: [String : Any] = ["firstName": first, "lastName": last, "key": unique, "location": StudentLocation(lat: lati, long: longi, map: map), "mediaurl": media]
            
            allStudentLocations.append(StudentInformation(studentInfo: info))
        }
        
        return allStudentLocations
    }
    
    func makeVariables(variable: String?) -> String {
        
        let varChar = ""
        
        if variable != nil {
            
            return variable!
        }
        
        return varChar
    }
    
    func makeVariables(variable: Double?) -> Double {
        
        let varChar = 0.0
        
        print("double variable: \(variable)")
        
        if variable != nil {
            
            return Double(variable!)
        }
        
        return varChar
    }
    
    func allStudentLocations(response: [String: Any], controller: UIViewController) -> (flag: Bool, array: [StudentInformation]) {
        
        if let error = response["error"] as? String {
            
            print("Error creating request: \(error)")
            helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error, vc: controller)
            return (false, [])
        }
        else if response["results"] != nil {
            
            let results = helper.studentLocationJSONToStruct(response: response["results"] as! [[String: Any]])
            return (true, results)
        }
        else {
            
            print("Response error!")
            helper.giveErrorAlerts(response: response, vc: controller)
            return (false, [])
        }
    }    
}
