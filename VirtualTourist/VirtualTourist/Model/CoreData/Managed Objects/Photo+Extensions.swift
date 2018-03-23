//
//  Photo+Extensions.swift
//  VirtualTourist
//
//  Created by Thomas Muehlegger on 23.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit

extension Photo {
    
    // MARK: Download Photo from Flicker
    func loadImage(appDelegate: AppDelegate, _ completionLoadImageHandler: @escaping (_ image:UIImage?, _ errorMessage:String?) -> Void) {
        
        // GUARD: If the image was not loaded before
        guard (self.image != nil) else {
            FlickrClient.sharedInstance.loadImageFromUrl(url!) {
                (data, error) in
                
                // GUARD: Was there an error?
                guard (error == nil) else {
                    completionLoadImageHandler(nil, "An error occurred when requesting the image: \(error?.description ?? "Unknown error")")
                    return
                }
                
                // GUARD: Was the image data ok?
                guard let image = UIImage(data: data!) else {
                    completionLoadImageHandler(nil, "Wrong image data (format)?")
                    return
                }
                
                appDelegate.getContext().performAndWait {
                    self.image = data
                }
                
                completionLoadImageHandler(image, nil)
                
            }
            return
        }
        
        // Call the completion handler with the image
        completionLoadImageHandler(UIImage(data: self.image! as Data)!, nil)
    }
}
