//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 12/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import UIKit

class StudentLocationTableViewController: UITableViewController {
    
    var results: [StudentInformation] = []
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
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
        
        let userAccount = currentUser["account"] as! [String: Any]
        
        request.getSingleUserLocation(key: userAccount["key"] as! String, vc: self, completion: { response in
            
            DispatchQueue.main.async(execute: {
                
                helper.postPin(response: response, viewController: self)
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if helper.allStudentLocations.count == 0 {
            
            getAllStudentLocations()
        }
        else {
            
            results = helper.allStudentLocations
        }
        
    }
    
    func getAllStudentLocations() {
        
        request.getMultipleUserLocations(sorting: true, controller: self, completion: {response in
            
            let results = helper.allStudentLocations(response: response, controller: self)
            
            if results.0 {
                
                self.results = results.array
                self.tableView.reloadData()
            }
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
        cell.studentName.text = "\(results[indexPath.row].firstName!) \(results[indexPath.row].lastName!)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let urlToOpen = URL(string: results[indexPath.row].media) {
            UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
        }
    }
}
