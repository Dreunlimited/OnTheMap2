//
//  UdacityConvenience.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 2/1/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func authenticateWithEmail(_ email:String, _ password:String, completionHandlerForAuth: @escaping (_  sucess: Bool, _ error: String?, _ userID:String?)-> Void) {
        
        let httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        let _ = taskForPost(Udacity.UDACITY.BASEURL, httpBody) { (results, error) in
            
            if let _ = error {
                completionHandlerForAuth(false, "Error returning key", nil)
            } else {
                
                if let account = results?["account"] as? [String:AnyObject] {
                   let key = account["key"] as? String
                    print(key)
                    
                    completionHandlerForAuth(true, nil, key)
                }
            }
            
        }
        
        
    }
    
    func getUserProfile(completionHandler: @escaping (_ sucess: Bool, _ results:[String:AnyObject]?, _ error: String? )-> Void) {
        
        let key = userKey.object(forKey: "key")
        let url = "\(Udacity.UDACITY.BASEURL)/\(key!)"
        
        let _ = taskForGet(url, parameters: nil) { (results, error) in
            if let error = error {
                print(error)
                completionHandler(false, nil, "Error getting profile")
            } else {
                
                completionHandler(true, results as! [String : AnyObject]?, nil)
            }
        }
        
    }
    
}