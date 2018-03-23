//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Thomas Muehlegger on 23.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import MapKit
import CoreData
import UIKit

class FlickrClient {
    
    static let sharedInstance = FlickrClient()
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Get images for pin
    func getImagesForPin(pin: Pin, pageNumber: Int?, context: NSManagedObjectContext, completionHandler: @escaping(_ photos:[Photo]?, _ errorMessage:String?) -> Void ) {
        
        
        // create session and request
        let session = URLSession.shared
        let request = URLRequest(url: getURLFromParameters(getParameters(latitude: pin.latitude, longitude: pin.longitude, pageNumber: pageNumber)))
        
        // create network request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                completionHandler(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
                sendError("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Is "photos" key in our result? */
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                sendError("No key '\(Constants.FlickrResponseKeys.Photos)' in \(parsedResult)")
                return
            }
            
            /* Is a Page Number permitted? */
            if (pageNumber == nil) {
                /* GUARD: Is "pages" key in the photosDictionary? */
                guard let totalPages = photosDictionary[Constants.FlickrResponseKeys.Pages] as? Int else {
                    sendError("No key '\(Constants.FlickrResponseKeys.Pages)' in \(photosDictionary)")
                    return
                }
                
                // pick a random page!
                let pageLimit = min(totalPages, 40)
                let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
                self.getImagesForPin(pin: pin, pageNumber: randomPage, context: context, completionHandler: completionHandler)
                
            } else {
                /* GUARD: Is the "photo" key in photosDictionary? */
                guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                    sendError("No key '\(Constants.FlickrResponseKeys.Photo)' in \(photosDictionary)")
                    return
                }
                
                /* GUARD: Check photoArray size > 0 */
                guard ( photosArray.count != 0) else {
                    sendError("No Photos Found. Search Again.")
                    return
                }
                
                var coreDataPhotoArray = [Photo]()
                
                for photo in photosArray {
                    /* GUARD: Check imageURL */
                    guard let imageURL = photo[Constants.FlickrResponseKeys.MediumURL] as? String else {
                        sendError("No Url for Image")
                        return
                    }
                    
                    /* GUARD: Check ImageID */
                    guard let imageId = photo[Constants.FlickrResponseKeys.Id] as? String else {
                        sendError("No Id for Image")
                        return
                    }
                    
                    /* Add Photos to CoreData */
                    context.performAndWait {
                        let photo = Photo(context: self.delegate.getContext())
                        photo.id = imageId
                        photo.url = imageURL
                        
                        coreDataPhotoArray.append(photo)
                    }
                }
                
                context.performAndWait {
                    self.delegate.saveContext()
                }
                
                completionHandler(coreDataPhotoArray, nil)
            }
        }
        
        // start the task!
        task.resume()
    }
    
    
    func loadImageFromUrl(_ url: String, completionHandler: @escaping (_ image:Data?, _ errorMessage:String?) -> Void) {
        
        // create session and request
        let session = URLSession.shared
        let request = URLRequest(url: URL(string: url)!)
        
        
        // create network request
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                completionHandler(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            //Return Photo
            completionHandler(data, nil)
        }
        task.resume()
        
    }
    // MARK: Helper for Creating a URL from Parameters
    func getParameters(latitude: Double, longitude: Double, pageNumber: Int?) -> [String:AnyObject] {
        var methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
            Constants.FlickrParameterKeys.Latitude: latitude,
            Constants.FlickrParameterKeys.Longitude: longitude,
            Constants.FlickrParameterKeys.Radius: Constants.FlickrParameterValues.Radius,
            Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PhotosPerPage
            ] as [String : Any]
        
        if (pageNumber != nil) {
            methodParameters[Constants.FlickrParameterKeys.Page] = pageNumber as AnyObject
        }
        
        return methodParameters as [String : AnyObject]
    }
    
    func getURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
    // MARK: parseJSON
    func parseJSONWithCompletionHandler(_ data: Data, completionHandlerForJSONData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForJSONData(nil, NSError(domain: "completionHandlerForJSONData", code: 1, userInfo: userInfo))
        }
        completionHandlerForJSONData(parsedResult, nil)
    }
    
    // MARK: Helper for Escaping Parameters in URL
    private func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
}
