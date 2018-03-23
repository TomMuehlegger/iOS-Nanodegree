//
//  PhotoAlbumCell.swift
//  VirtualTourist
//
//  Created by Thomas Muehlegger on 23.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit

class PhotoAlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    var appDelegate: AppDelegate! = UIApplication.shared.delegate as! AppDelegate
    
    var photo: Photo! = nil {
        didSet {
            if(imageViewPhoto.image != nil) {
                imageViewPhoto.image = nil
            }
            
            // Start activity indicator - show
            DispatchQueue.main.async(execute: {
                self.activityIndicatorLoading.startAnimating()
            })
            
            photo.loadImage(appDelegate: appDelegate) {
                (image, errorMessage) in
                guard(errorMessage == nil) else {
                    return
                }
                
                // Stop activity indicator - hide
                DispatchQueue.main.async(execute: {
                    self.activityIndicatorLoading.stopAnimating()
                    self.imageViewPhoto.image = image
                })
            }
        }
    }
}
