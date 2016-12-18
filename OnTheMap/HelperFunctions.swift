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
    
    var allStudentLocations: [StudentInformation] = []
    
    func giveErrorAlerts(response: JSON, vc: UIViewController) {
        
//        var alert = UIAlertController(title: "Error!", message: "\(response["error"].string!)", preferredStyle: .alert)
        
        if let responseError = response["error"].string {
            
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
    
    func studentLocationJSONToStruct(response: [JSON]) -> [StudentInformation] {
        
        allStudentLocations = []
        
        for each in response {
            
            
            let first = makeVariables(variable: each["firstName"].string)
            let last = makeVariables(variable: each["lastName"].string)
            let unique = makeVariables(variable: each["uniqueKey"].string)
            let lati = makeVariables(variable: each["latitude"].double)
            let longi = makeVariables(variable: each["longitude"].double)
            let map = makeVariables(variable: each["mapString"].string)
            let media = makeVariables(variable: each["mediaURL"].string)
            
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
    
    func allStudentLocations(response: JSON, controller: UIViewController) -> (flag: Bool, array: [StudentInformation]) {
        
        if let error = response.error {
            
            print("Error creating request: \(error.localizedDescription)")
            helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error.localizedDescription, vc: controller)
            return (false, [])
        }
        else if response["results"] != JSON.null {
            
            let results = helper.studentLocationJSONToStruct(response: response["results"].array!)
            return (true, results)
        }
        else {
            
            print("Response error!")
            helper.giveErrorAlerts(response: response, vc: controller)
            return (false, [])
        }
    }    
}
