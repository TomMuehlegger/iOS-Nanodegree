//
//  Constants.swift
//  VirtualTourist
//
//  Created by Thomas Muehlegger on 23.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

// MARK: Constants for the Virtual Tourist App
struct Constants {
    
    // MARK: Flickr
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
        static let Latitude = "lat"
        static let Longitude = "lon"
        static let Radius = "radius"
        static let PerPage = "per_page"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "31bd491a19c3d6611ff60b4527b55c01"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" // 1 means "yes"
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let GalleryID = "5704-72157622566655097"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        static let PhotosPerPage = "24"
        static let Radius = "5" // Radius in kilometer
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Id = "id"
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
    // MARK: Map View constants / default values
    struct MapViewConstants {
        static let MapViewLatitude = "mapViewLatitude"
        static let MapViewLongitude = "mapViewLongitude"
        static let MapViewLatitudeSpan = "mapViewLatitudeSpan"
        static let MapViewLongitudeSpan = "mapViewLongitudeSpan"
        static let defaultLatitude = 47.811195
        static let defaultLongitude = 13.033229
        static let defaultLatitudeDelta = 5.0
        static let defaultLongitudeDelta = 5.0
    }
}
