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
    
    init(firstName: String, lastName: String, key: String, location: StudentLocation, mediaurl: String) {
        
        self.firstName = firstName
        self.lastName = lastName
        self.key = key
        self.location = location
        self.media = mediaurl
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
