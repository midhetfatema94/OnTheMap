//
//  Structures.swift
//  OnTheMap
//
//  Created by Midhet Sulemani on 12/12/16.
//  Copyright © 2016 MCreations. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    var key: String!
    var location: StudentLocation!
    var media: String!
}

struct StudentLocation {
    
    var longitiude: Double!
    var latitude: Double!
    var mapString: String!
}
