//
//  Client.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 21.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import Foundation

class Client {
    
    // User properties
    var sessionID: String!
    var userID: String!
    var firstName: String!
    var lastName: String!
    
    // shared session
    var session = URLSession.shared
    
    // MARK: GET call (isUdacityCall is needed to set the data offset of 5)
    func taskForGETMethod(_ url: URL, headers: [String:AnyObject], isUdacityCall: Bool? = false, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Configure the request
        let request = NSMutableURLRequest(url: url)
        
        // Add the headers to the request
        for (key, value) in headers {
            request.addValue("\(value)", forHTTPHeaderField: key)
        }
        
        request.httpMethod = "GET"
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data (happens in completion handler)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET, isUdacityCall: isUdacityCall)
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: POST (isUdacityCall is needed to set the data offset of 5)
    func taskForPOSTMethod(_ url: URL, headers: [String:AnyObject], jsonBody: String, isUdacityCall: Bool? = false, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Configure the request
        let request = NSMutableURLRequest(url: url)
        
        // Add the headers to the request
        for (key, value) in headers {
            request.addValue("\(value)", forHTTPHeaderField: key)
        }
        
        request.httpMethod = "POST"
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data (happens in completion handler)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST, isUdacityCall: isUdacityCall)
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    // MARK: DELETE call (isUdacityCall is needed to set the data offset of 5)
    func taskForDELETEMethod(_ url: URL, headers: [String:AnyObject], isUdacityCall: Bool? = false, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        // Configure the request
        let request = NSMutableURLRequest(url: url)
        
        // Add the headers to the request
        for (key, value) in headers {
            request.addValue("\(value)", forHTTPHeaderField: key)
        }
        
        request.httpMethod = "DELETE"
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data (happens in completion handler)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE, isUdacityCall: isUdacityCall)
        }
        
        // Start the request
        task.resume()
        
        return task
    }
    
    // Return a usable object from the given JSON
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void, isUdacityCall: Bool? = false) {
        
        var parsedResult: AnyObject! = nil
        
        var newData = data
        
        if (isUdacityCall)! {
            // Everything was fine
            let range = Range(5..<data.count)
            // subset response data!
            newData = data.subdata(in: range)
        }
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
}
