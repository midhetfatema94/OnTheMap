//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 12/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit
import SwiftyJSON

class StudentLocationTableViewController: UITableViewController {
    
    var results: [JSON] = []
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        getAllStudentLocations()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        request.logoutUserUdacity(completion: { response in
            
            DispatchQueue.main.async {
                
                helper.logout(response: response, viewController: self)
            }
        })
    }
    
    @IBAction func placePin(_ sender: UIBarButtonItem) {
        
        request.getSingleUserLocation(key: currentUser["account"]["key"].string!, completion: { response in
            
            DispatchQueue.main.async(execute: {
                
                helper.postPin(response: response, viewController: self)
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllStudentLocations()
    }
    
    func getAllStudentLocations() {
        
        request.getMultipleUserLocations(sorting: true, completion: {response in
            
            DispatchQueue.main.async(execute: {
                
                if let error = response.error {
                    
                    print("Error creating request: \(error.localizedDescription)")
                    helper.giveErrorAlerts(errorString: "Error creating request", errorMessage: error.localizedDescription, vc: self)
                }
                else if response["results"] != JSON.null {
                    
                    self.results = response["results"].array!
                    self.tableView.reloadData()
                }
                else {
                    
                    print("Response error!")
                    helper.giveErrorAlerts(response: response, vc: self)
                }
            })
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationCell", for: indexPath) as! StudentLocationDetailTableViewCell
        cell.studentName.text = "\(results[indexPath.row]["firstName"].string!) \(results[indexPath.row]["lastName"].string!)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let urlToOpen = URL(string: results[indexPath.row]["mediaURL"].string!) {
            UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
        }
    }
}
