//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 21.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

struct StudentInformation {
    var objectId: String
    var uniqueKey: String?
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float
    var createdAt: String?
    var updatedAt: String?
    
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[Client.Constants.Parse.StudentLocationJSON.ObjectId] as! String
        uniqueKey = dictionary[Client.Constants.Parse.StudentLocationJSON.UniqueKey] as? String ?? ""
        firstName = dictionary[Client.Constants.Parse.StudentLocationJSON.FirstName] as! String
        lastName = dictionary[Client.Constants.Parse.StudentLocationJSON.LastName] as! String
        mapString = dictionary[Client.Constants.Parse.StudentLocationJSON.MapString] as! String
        mediaURL = dictionary[Client.Constants.Parse.StudentLocationJSON.MediaURL] as? String ?? ""
        latitude = dictionary[Client.Constants.Parse.StudentLocationJSON.Latitude] as! Float
        longitude = dictionary[Client.Constants.Parse.StudentLocationJSON.Longitude] as! Float
        createdAt = dictionary[Client.Constants.Parse.StudentLocationJSON.CreatedAt] as? String ?? ""
        updatedAt = dictionary[Client.Constants.Parse.StudentLocationJSON.UpdatedAt] as? String ?? ""
    }
}
