//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 21.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import MapKit

extension Client {
    
    // MARK: Get the newest 100 student locations
    func getStudentLocations(completionHandlerForGetStudentLocations:  @escaping (_ success: Bool, _ error: String?) -> Void){
        
        // Params for Limit and Size
        var params = [:] as [String:AnyObject]
        params[Constants.Parse.URLParams.Limit] = 100 as AnyObject
        params[Constants.Parse.URLParams.Order] = "-updatedAt" as AnyObject
        
        // Headers for the parse API
        var headers = [:] as [String:AnyObject]
        headers["X-Parse-Application-Id"] = Constants.Parse.ParseApplicationID as AnyObject
        headers["X-Parse-REST-API-Key"] = Constants.Parse.RestApiKey as AnyObject
        
        // Make the request
        let _ = taskForGETMethod(parseUrlFromParameters(params, withPathExtension: Constants.Parse.Methods.StudentLocation), headers: headers) { (results, error) in
            
            // Check if there was any error?
            if let error = error {
                completionHandlerForGetStudentLocations(false, error.localizedDescription)
            } else {
                // Parse locations
                if let parsedResults = results?[Constants.Parse.StudentLocationsJSON.Results] as? [[String:AnyObject]] {
                    
                    let studentInformations = StudentInformations.sharedInstance
                    studentInformations.removeAll()
                    
                    let studentInfo = studentInformations.addStudentInformationsFromResult(parsedResults)
                    
                    guard (!studentInfo.isEmpty) else {
                        completionHandlerForGetStudentLocations(false, "Failed to get student information from the parsed results")
                        return
                    }
                    completionHandlerForGetStudentLocations(true, nil)
                } else {
                    completionHandlerForGetStudentLocations(false, "Failed to parse StudentInformation")
                }
            }
        }
    }
    
    // MARK: Post the user location
    func postStudentLocation(_ mapString: String, mediaURL: String, coordinate: CLLocationCoordinate2D, completionHandlerForPostStudentLocation:  @escaping (_ success: Bool, _ error: String?) -> Void){
        
        // Headers for the parse API
        var headers = [:] as [String:AnyObject]
        headers["X-Parse-Application-Id"] = Constants.Parse.ParseApplicationID as AnyObject
        headers["X-Parse-REST-API-Key"] = Constants.Parse.RestApiKey as AnyObject
        headers["Content-Type"] = "application/json" as AnyObject
        
        // Create the JSON string
        let jsonBody = "{\"uniqueKey\": \"\(Client.sharedInstance().userID!)\", \"firstName\": \"\(Client.sharedInstance().firstName!)\", \"lastName\": \"\(Client.sharedInstance().lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(coordinate.latitude), \"longitude\": \(coordinate.longitude)}"
        
        // Make the request
        let _ = taskForPOSTMethod(parseUrlFromParameters([:], withPathExtension: Constants.Parse.Methods.StudentLocation), headers: headers, jsonBody: jsonBody) { (results, error) in
            
            // Check if there was any error?
            if let error = error {
                completionHandlerForPostStudentLocation(false, error.localizedDescription)
            } else {
                // Everything was fine
                completionHandlerForPostStudentLocation(true, nil)
            }
        }
    }

    // Create a Parse URL from parameters
    private func parseUrlFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Parse.ApiScheme
        components.host = Constants.Parse.ApiHost
        components.path = Constants.Parse.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
