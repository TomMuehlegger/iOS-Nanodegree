//
//  Pin+Extensions.swift
//  VirtualTourist
//
//  Created by Thomas Muehlegger on 23.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import CoreData
import MapKit

extension Pin {
    
    // Coordinate from latitude and logitude and vice versa
    public var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            self.latitude = newValue.latitude
            self.longitude = newValue.longitude
        }
    }
    
    // Delete Photos associate to pin
    func deletePhotosFromPin(_ appDelegate: AppDelegate) {
        for photo in photos! {
            appDelegate.getContext().delete(photo as! NSManagedObject)
        }
        appDelegate.saveContext()
    }
}
