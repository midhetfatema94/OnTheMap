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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllStudentLocations()
    }
    
    func getAllStudentLocations() {
        
        request.getMultipleUserLocations(completion: {response in
            
            DispatchQueue.main.async(execute: {
                
                if let error = response.error {
                    
                    print("Error creating request: \(error.localizedDescription)")
                }
                else if response["results"] != JSON.null {
                    
                    self.results = response["results"].array!
                    self.tableView.reloadData()
                }
                else {
                    
                    print("Response error!")
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
