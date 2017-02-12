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
            
            if let account = results?["account"] as? [String:AnyObject] {
                   let key = account[Udacity.URLKeys.UserID] as! String
                    self.userKey.set(key, forKey: "key")
                    completionHandlerForAuth(true, nil, key)
                } else {
                     completionHandlerForAuth(false, "Error returning key", nil)
                }
            }
            
        }
    
    
    func getUserProfile(completionHandler: @escaping (_ sucess: Bool, _ results:[String:AnyObject]?, _ error: String? )-> Void) {
        
        let key = userKey.object(forKey: "key")
        let url = "\(Udacity.UDACITY.UserBASEURL)\(key!)"
        let _ = taskForGet(url, parameters: nil) { (results, error) in
            if let results = results?["error"] as? [String:AnyObject] {
                print("hey")
                completionHandler(false, nil, "Error getting profile")
            } else {
                if let user = results?["user"] as? [String:AnyObject] {
                    let firstName = user["first_name"] as! String
                    let lastName = user["last_name"] as! String
                    
                    let userInfo = ["first_name":firstName, "last_name":lastName]
                    completionHandler(true, userInfo as [String : AnyObject]?, nil)

                }
            }
        }
        
    }
    
}
