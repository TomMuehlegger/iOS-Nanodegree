//
//  Pin+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Thomas Muehlegger on 23.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

@objc(Pin)
public class Pin: NSManagedObject, MKAnnotation {
    
    var appDelegate: AppDelegate! = UIApplication.shared.delegate as! AppDelegate
    
    // Delete photos from the pin
    func deletePhotosFromPin() {
        for photo in photos! {
            appDelegate.getContext().delete(photo as! NSManagedObject)
        }
        appDelegate.saveContext()
    }
}
