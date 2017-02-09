//
//  UdacityConstants.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/27/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import Foundation

struct Udacity {
    
    static let helper = Udacity()
    
    struct UDACITY {
        static let ApiScheme = "https://www."
        static let ApiHost = "udacity.com/api/session"
        static let ApiUser = "udacity.com/api/users/"
        static let BASEURL = ApiScheme + ApiHost
        static let UserBASEURL = ApiScheme + ApiUser
    }
    
    struct UDACITYParameterKeys {
        static let udacity = "udacity"
        
    }
    
    struct URLKeys {
        static let UserID = "key"
    }
    
    struct JSONResponseKeys {
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        static let UserResults = "user"
        
      
        static let SessionID = "session_id"
        static let Acccount = "account"
    }
}
