//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 21.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import Foundation

extension Client {
    
    // MARK: Login with Udacity account
    func login(_ username: String, password: String, completionLoginHandler: @escaping (_ success: Bool, _ error: String?) -> Void ) {
        
        // Headers for the parse API
        var headers = [:] as [String:AnyObject]
        headers["Accept"] = "application/json" as AnyObject
        headers["Content-Type"] = "application/json" as AnyObject
        
        // Create the JSON string
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        // Make the request
        let _ = taskForPOSTMethod(URL(string: Constants.Udacity.ApiBaseUrl + Constants.Udacity.Methods.Session)!, headers: headers, jsonBody: jsonBody, isUdacityCall: true) { (results, error) in
            
            // Check if there was any error?
            if let error = error {
                completionLoginHandler(false, error.localizedDescription)
            } else {
                let parsedJSONResult = results
                
                // Parse SessionKey
                if let session = parsedJSONResult?[Constants.Udacity.UdacityJSON.Session] as? [String:Any] {
                    if let sessionID = session[Constants.Udacity.UdacityJSON.ID] as? String {
                        self.sessionID = sessionID
                    }
                }
                
                // Parse UserID from Account Data
                if let account = parsedJSONResult?[Constants.Udacity.UdacityJSON.Account] as? [String:Any] {
                    if let userID = account[Constants.Udacity.UdacityJSON.Key] as? String {
                        self.userID = userID
                    }
                }
                
                // Check SessionID and UserID
                guard(self.sessionID != nil && self.userID != nil) else {
                    completionLoginHandler(false, "Login failed")
                    return
                }
                
                // Get the username
                self.getUsername(self.userID!) {
                    (success, error) in
                    guard (error == nil) else {
                        completionLoginHandler(false, error?.description)
                        return
                    }
                    
                    completionLoginHandler(true, nil)
                }
            }
        }
    }
    
    // MARK: Get the Udacity username for posting the students location
    func getUsername(_ userID: String, completionGetUsernameHandler:  @escaping (_ success: Bool, _ error: String?) -> Void){
        
        // Make the request
        let _ = taskForGETMethod(URL(string: Constants.Udacity.ApiBaseUrl + Constants.Udacity.Methods.User + userID)!, headers: [:], isUdacityCall: true) { (results, error) in
            
            // Check if there was any error?
            if let error = error {
                completionGetUsernameHandler(false, error.description)
            } else {
                // Parse User first and last name
                if let result = results?[Constants.Udacity.UdacityJSON.User] as? [String:Any] {
                    if let firstName = result[Constants.Udacity.UdacityJSON.FirstName] as? String {
                        self.firstName = firstName
                    }
                    if let lastName = result[Constants.Udacity.UdacityJSON.LastName] as? String {
                        self.lastName = lastName
                    }
                }
                
                // Check firstname and lastname
                guard(self.firstName != nil && self.lastName != nil) else {
                    completionGetUsernameHandler(false, "Failed to get user data")
                    return
                }
                
                completionGetUsernameHandler(true, nil)
            }
        }
    }
    
    // MARK: Logout the logged in user
    func logout(completionLogoutHandler:  @escaping (_ success: Bool, _ error: String?) -> Void){
        
        // Make the request
        let _ = taskForDELETEMethod(URL(string: Constants.Udacity.ApiBaseUrl + Constants.Udacity.Methods.Session)!, headers: [:], isUdacityCall: true) { (results, error) in
            
            // Check if there was any error?
            if let error = error {
                completionLogoutHandler(false, error.description)
            } else {
                self.sessionID = nil
                self.userID = nil
                
                completionLogoutHandler(true, nil)
            }
        }
    }
}
