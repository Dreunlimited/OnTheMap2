//
//  ParseConvenience.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/31/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift

extension ParseClient {
    
    func getStudentLocation(completionHandlerForLocation: @escaping (_ result:[StudentLocation]?, _ errror: NSError?)-> Void) {
        
        
        let _  = taskFromGet(Parse.PARSE.BASEURL) { (results, error) in
            
            if let error = error {
                completionHandlerForLocation(nil, error)
            } else {
                if let results = results?[Parse.JSONResponseKeys.studentResults] as? [[String:AnyObject]] {
                    let locations = StudentLocation.locationsFromResults(results)
                    completionHandlerForLocation(locations, nil)
                    
                } else {
                    completionHandlerForLocation(nil, NSError(domain: "getStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocationData"]))
                }
            }
            
        }
        
    }
    
    func postStudentLocation(_ uniqueKey:String, _ firstName:String, _ lastName:String, _ mapString:String, _ mediaURL:String, _ latitude: Double, _ longitude: Double, completionHandlerForPostLocation: @escaping(_ results:AnyObject?, _ error:String?)-> Void) {
        
        
        
        let httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        let _ = self.taskForPost(Parse.PARSE.BASEURL, httpBody) { (results, error) in
            if let _ = results?["error"] as? [String:AnyObject] {
                completionHandlerForPostLocation(nil, "Error posting location")
            } else {
                completionHandlerForPostLocation(results, nil)
            }
            
        }
    }
}
