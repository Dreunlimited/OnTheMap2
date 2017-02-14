//
//  UdacityClient.swift
//  OnTheMap2
//
//  Created by Dandre Ealy on 1/27/17.
//  Copyright © 2017 Dandre Ealy. All rights reserved.
//

import Foundation
import ReachabilitySwift

class UdacityClient: NSObject {
    
    let session = URLSession.shared
    let userKey = UserDefaults()
    var sessionID: String? = nil
    
    
    override init() {
        super.init()
    }
    
    func taskForGet(_ method:String, parameters:[String:AnyObject]?, completionHandlerForGet:@escaping (_ results: AnyObject?, _ error:NSError?) ->Void) {
        
        var request = URLRequest(url: URL(string: method)!)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGet(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request : \(error)")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
              
            self.convertDataToJson(data, completionHandlerForConvertData: completionHandlerForGet)
        }
        task.resume()

    }
  

    
    func taskForPost(_ method:String,_ httpBody:String,completionHandlerForPOST: @escaping(_ result:AnyObject?,_ error:NSError?)-> Void) {
        
        
        var request = URLRequest(url: URL(string: method)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
          
            self.convertDataToJson(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        task.resume()
       
    }
    
    func taskForDelete(_ method:String, completionHandlerForPOST: @escaping(_ result:Bool,_ error:NSError?)-> Void ) {
        
         var request = URLRequest(url: URL(string: method)!)
         request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(false, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            if let error = error {
                sendError("error with logging out")
                completionHandlerForPOST(false, error as NSError?)
            } else {
                completionHandlerForPOST(true,nil)
            }
            
        }
            task.resume()
    }
    
    func convertDataToJson(_ data: Data, completionHandlerForConvertData:(_ results:AnyObject?, _ error:NSError?)-> Void) {
        
        var results: AnyObject! = nil
        
        do {
            results = try JSONSerialization.jsonObject(with: data.subdata(in: Range(uncheckedBounds: (lower: data.startIndex.advanced(by: 5), upper: data.endIndex))), options: .allowFragments) as AnyObject!
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(results, nil)
    }
    
    
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
    
    
    
    
}
