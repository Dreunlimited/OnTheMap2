//
//  StudentLocation.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/27/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct StudentLocation {
    var objectId:String?
    var uniqueKey:String?
    var firstName:String?
    var lastName:String?
    var mapString:String?
    var mediaURL:String?
    var latitude: CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var location: CLLocationCoordinate2D?
   
    init(dictionary:[String:AnyObject]) {
        objectId = dictionary[Parse.JSONResponseKeys.objectId] as? String
        uniqueKey = dictionary[Parse.JSONResponseKeys.uniqueKey] as? String
        if let fName = dictionary[Parse.JSONResponseKeys.firstName] as? String {
            firstName = fName
        } else {
            firstName = ""
        }
        if let lName = dictionary[Parse.JSONResponseKeys.lastName] as? String {
            lastName = lName
        } else {
            lastName = ""
        }
        mapString = dictionary[Parse.JSONResponseKeys.objectId] as? String
        mediaURL = dictionary[Parse.JSONResponseKeys.mediaURL] as? String
        if let lat = dictionary[Parse.JSONResponseKeys.latitude] as? Double {
            latitude = lat
        } else {
            latitude = 0.0
        }
            
        if let long = dictionary[Parse.JSONResponseKeys.longitude] as? Double {
            longitude = long
        } else {
            longitude = 0.0
        }
        location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
    
    static func locationsFromResults(_ results:[[String:AnyObject]]!)-> [StudentLocation] {
        let appDel = UIApplication.shared.delegate as? AppDelegate
        
        var studentLocations = [StudentLocation]()
        
        
        for location in results {
    
            studentLocations.append(StudentLocation(dictionary: location))
            
        }
        appDel?.listLocation = studentLocations.flatMap { $0 }
        return studentLocations
    
    }
}

