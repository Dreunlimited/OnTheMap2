//
//  ParseConvenience.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/31/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    func getStudentLocation(completionHandlerForLocation: @escaping (_ result:[StudentLocation]?, _ errror: NSError?)-> Void) {
        
       
        let _  = taskFromGet(Parse.PARSE.BASEURL) { (results, error) in
            
            if let error = error {
                completionHandlerForLocation(nil, error)

            } else {
            
                if let results = results?[Parse.JSONResponseKeys.studentResults] as? [[String:AnyObject]]! {
                     let locations = StudentLocation.locationsFromResults(results!)
                     completionHandlerForLocation(locations, nil)
                } else {
                    completionHandlerForLocation(nil, NSError(domain: "getStudentLocationparsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocationData"]))
                }
            }
            
            
        }
    }
}

