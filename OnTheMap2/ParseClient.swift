//
//  ParseClient.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/27/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    let session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func taskFromGet(_ method:String, completionHandlerForGET: @escaping(_ result:AnyObject?,_ error:NSError?)-> Void) {
        var request = URLRequest(url: URL(string: method)!)
        request.httpMethod = "GET"
        request.addValue(Parse.ParseParameterKeys.appId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Parse.ParseParameterKeys.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
           
        }
        task.resume()
    }
    
    func taskForPost(_ method:String,_ httpBody: String,completionHandlerForPOST: @escaping(_ result:AnyObject?,_ error:NSError?)-> Void) {
        
        var request = URLRequest(url: URL(string: method)!)
        request.httpMethod = "POST"
        request.addValue(Parse.ParseParameterKeys.appId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Parse.ParseParameterKeys.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request 2: \(error)")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            print("response \(response)")
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
        
    }

    
     func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
   

    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    
}
