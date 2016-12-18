//
//  Model.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 01/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import Foundation
import UIKit

class Model {
    
    func loginUserUdacity(username: String, password: String, controller: UIViewController, completion: @escaping (([String: Any]) -> Void)) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                
                print("Error: \(error)")
                helper.giveErrorAlerts(errorString: "Request failed", errorMessage: error!.localizedDescription, vc: controller)
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range) /* subset response data! */
            print("starts here")
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            do {
                let result = try JSONSerialization.jsonObject(with: newData!, options: []) as! [String:AnyObject]
                print("response: \(result)")
                completion(result)

            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func logoutUserUdacity(controller: UIViewController, completion: @escaping (([String: Any]) -> Void)) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                
                print("Error: \(error)")
                helper.giveErrorAlerts(errorString: "Request failed", errorMessage: error!.localizedDescription, vc: controller)
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range)
            do {
                let result = try JSONSerialization.jsonObject(with: newData!, options: []) as! [String:AnyObject]
                print("response: \(result)")
                completion(result)
                
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
        
    }
    
    func loginUserFb(accessToken: String, controller: UIViewController, completion: @escaping (([String: Any]) -> Void)) {
        
        // create post request
        let url = URL(string: "https://www.udacity.com/api/session")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        print("access token is: \(accessToken)")
        
        // insert json data to the request
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
            
            if error != nil{
                
                print("Error: \(error)")
                helper.giveErrorAlerts(errorString: "Request failed", errorMessage: error!.localizedDescription, vc: controller)
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range)
            print("starts here fb")
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            do {
                let result = try JSONSerialization.jsonObject(with: newData!, options: []) as! [String: Any]
                print("response: \(result)")
                completion(result)
                
            } catch {
                print("Error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func getMultipleUserLocations(sorting: Bool, controller: UIViewController, completion: @escaping (([String: Any]) -> Void)) {
        
        var request = NSMutableURLRequest()
        
        if sorting {
            
            request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        }
        else {
            
            request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")!)
        }
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil { // Handle error...
                
                print("Error: \(error)")
                helper.giveErrorAlerts(errorString: "Request failed", errorMessage: error!.localizedDescription, vc: controller)
                return
            }
            print("starts here")

            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                print("response multiple user locations: \(result)")
                completion(result)
                
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func getSingleUserLocation(key: String, vc: UIViewController, completion: @escaping (([String: Any]) -> Void)) {
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(key)%22%7D"
        let url = URL(string: urlString)
        
        print("url is: \(url) \(urlString)")
        
        let request = NSMutableURLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                
                print("Error: \(error)")
                helper.giveErrorAlerts(errorString: "Request failed", errorMessage: error!.localizedDescription, vc: vc)
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                print("response: \(result)")
                completion(result)
                
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func postUserLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, media: String, latitude: Double, longitude: Double, controller: UIViewController, completion: @escaping (([String: Any]) -> Void)) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(media)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                
                print("Error: \(error)")
                helper.giveErrorAlerts(errorString: "Request failed", errorMessage: error!.localizedDescription, vc: controller)
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                print("response: \(result)")
                completion(result)
                
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func getUserData(uniqueKey: String, controller: UIViewController, completion: @escaping (([String: Any]) -> Void)) {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(uniqueKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                
                print("Error: \(error)")
                helper.giveErrorAlerts(errorString: "Request failed", errorMessage: error!.localizedDescription, vc: controller)
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count))
            let newData = data?.subdata(in: range) /* subset response data! */
            do {
                let result = try JSONSerialization.jsonObject(with: newData!, options: []) as! [String:AnyObject]
                print("response: \(result)")
                completion(result)
                
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
}
