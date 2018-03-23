//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Thomas Muehlegger on 23.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Foundation

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapViewLocation: MKMapView!
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    @IBOutlet weak var buttonNewCollection: UIBarButtonItem!
    @IBOutlet weak var labelNoImages: UILabel!
    
    var pin: Pin!
    var photos = [Photo]()
    var appDelegate: AppDelegate! = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the overview map
        mapViewLocation.delegate = self
        mapViewLocation.addAnnotation(pin)
        centerMapToPin(pin: pin)
        
        // Setup the collection view
        collectionViewPhotos.delegate = self
        collectionViewPhotos.dataSource = self
        
        // Get the photos of the pin
        if let photos = pin!.photos?.array as? [Photo] {
            self.photos = photos
            
            // Check the photos count and enable/disable the label and the button
            if (photos.count == 0) {
                labelNoImages.isHidden = false
                buttonNewCollection.isEnabled = false
                
                getPhotosFromFlickr()
            } else {
                labelNoImages.isHidden = true
                buttonNewCollection.isEnabled = true
            }
        }
    }
    
    // MARK: To always show 3 item per row
    override func viewWillLayoutSubviews() {
        guard let flowLayout = collectionViewPhotos.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    
    // MARK: Load new collection of photos
    @IBAction func loadNewCollection(_ sender: Any) {
        removePhotos()
        collectionViewPhotos.reloadData()
        getPhotosFromFlickr()
    }
    
    // MARK: Set the center point of the map to the PIN
    func centerMapToPin(pin: Pin) {
        let location = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        mapViewLocation.setRegion(MKCoordinateRegion(center:location, span:span), animated: true)
    }
    
    // MARK: get Photos from Flickr
    func getPhotosFromFlickr() {
        FlickrClient.sharedInstance.getImagesForPin(pin: pin, pageNumber: nil, context: appDelegate.getContext()) {
            (photos, error) in
            guard (error == nil) else {
                self.performUIUpdatesOnMain {
                    self.showAlert("Error", message: error!)
                }
                return
            }
            
            self.performUIUpdatesOnMain {
                if(photos?.count == 0) {
                    self.labelNoImages.isHidden = false
                } else {
                    self.labelNoImages.isHidden = true
                    self.photos = photos!
                    self.collectionViewPhotos.reloadData()
                    self.buttonNewCollection.isEnabled = true
                    self.appDelegate.saveContext()
                }
            }
        }
    }
    
    private func removePhotos() {
        // TODO: Remove photos
        //pin.deletePhotosFromPin(stack)
        photos.removeAll()
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK : Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoAlbumCell", for: indexPath) as! PhotoAlbumCell
        cell.photo = photos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        appDelegate.getContext().delete(self.photos[indexPath.row])
        photos.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        appDelegate.saveContext()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width - 20.0) / 3.0
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
}
