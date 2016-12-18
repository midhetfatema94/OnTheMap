//
//  Structures.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 12/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var firstName: String!
    var lastName: String!
    var key: String!
    var location: StudentLocation!
    var media: String!
    
    init(studentInfo: Dictionary<String, Any>) {
        
        self.firstName = studentInfo["firstName"] as! String!
        self.lastName = studentInfo["lastName"] as! String!
        self.key = studentInfo["key"] as! String!
        self.location = studentInfo["location"] as! StudentLocation!
        self.media = studentInfo["mediaurl"] as! String!
    }
}

struct StudentLocation {
    
    var longitiude: Double!
    var latitude: Double!
    var mapString: String!
    
    init(lat: Double, long: Double, map: String) {
        
        self.longitiude = long
        self.latitude = lat
        self.mapString = map
    }
    
}
