//
//  ParseConstants.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/27/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import Foundation

struct Parse {
    static let helper = Parse()
    
    struct PARSE {
        static let ApiScheme = "https://"
        static let ApiHost = "parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
        static let BASEURL = ApiScheme + ApiHost
    }
    
    struct ParseParameterKeys {
        static let appId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct JSONBodyKeys {
         static let uniqueKey = "uniqueKey"
         static let firstName = "firstName"
         static let lastName = "lastName"
         static let mapString = "mapString"
         static let mediaURL = "mediaURL"
         static let latitude = "latitude"
         static let longitude = "longitude"
    }
    
    struct JSONResponseKeys {
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let studentResults = "results"
    }
    
}
