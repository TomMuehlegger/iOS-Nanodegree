//
//  Constants.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 21.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

extension Client {
    
    struct Constants {
        
        // MARK: Udacity constants
        struct Udacity {
            static let ApiBaseUrl = "https://www.udacity.com/api/"
            static let SignUpUrl = "https://www.udacity.com/account/auth#!/signup"
            
            // MARK: Udacity methods
            struct Methods {
                static let User = "users/"
                static let Session = "session"
            }
            
            // MARK: Udacity JSONResponseKeys
            struct UdacityJSON {
                static let Account = "account"
                static let Session = "session"
                static let ID = "id"
                static let Key = "key"
                static let User = "user"
                static let FirstName = "first_name"
                static let LastName = "last_name"
            }
            
            // MARK: Udacity parameters
            struct URLParams {
                static let UserID = "id"
            }
        }

        // MARK: Parse constants
        struct Parse {
            // MARK: URLs
            static let ApiScheme = "https"
            static let ApiHost = "parse.udacity.com"
            static let ApiPath = "/parse/classes/"
            static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
            static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            
            // MARK: Parse methods
            struct Methods {
                static let StudentLocation = "StudentLocation"
            }
            
            // MARK: Parameter keys
            struct ParameterKeys {
                static let ApiKey = "api_key"
                static let SessionID = "session_id"
                static let RequestToken = "request_token"
                static let Query = "query"
            }
            
            // MARK: Parse StudentLocationJSON-ResponseKeys
            struct StudentLocationJSON {
                static let ObjectId = "objectId"
                static let UniqueKey = "uniqueKey"
                static let FirstName = "firstName"
                static let LastName = "lastName"
                static let MapString = "mapString"
                static let MediaURL = "mediaURL"
                static let Latitude = "latitude"
                static let Longitude = "longitude"
                static let CreatedAt = "createdAt"
                static let UpdatedAt = "updatedAt"
                static let ACL = "ACL"
            }
            
            // MARK: Parse StudentLocationsJSON-ResponseKeys
            struct StudentLocationsJSON {
                static let Results = "results"
            }
            
            // MARK: Parse parameters
            struct URLParams {
                static let Limit = "limit"
                static let Order = "order"
            }
        }
    }
}
