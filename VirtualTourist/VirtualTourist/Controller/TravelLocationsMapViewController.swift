//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Thomas Muehlegger on 23.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController {
    
    @IBOutlet weak var mapViewLocations: MKMapView!
    
    var locationManager = CLLocationManager()
    var pin: Pin!  = nil
    var appDelegate: AppDelegate! = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewLocations.delegate = self
        // Long Press Gesture Recognizer
        mapViewLocations.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:))))
        
        // Load default map position and zoom
        loadMapView()
        
        // Load all pins
        fetchAnnotations()
    }
    
    // MARK: Save the center point and the zoom of the MapView
    func saveActualMapState() {
        UserDefaults.standard.set(mapViewLocations.region.center.latitude, forKey: Constants.MapViewConstants.MapViewLatitude)
        UserDefaults.standard.set(mapViewLocations.region.center.longitude, forKey: Constants.MapViewConstants.MapViewLongitude)
        UserDefaults.standard.set(mapViewLocations.region.span.latitudeDelta, forKey: Constants.MapViewConstants.MapViewLatitudeSpan)
        UserDefaults.standard.set(mapViewLocations.region.span.longitudeDelta, forKey: Constants.MapViewConstants.MapViewLongitudeSpan)
    }
    
    // MARK: Initialize center and span of the map view
    func loadMapView() {
        var latitude = UserDefaults.standard.double(forKey: Constants.MapViewConstants.MapViewLatitude)
        var longitude = UserDefaults.standard.double(forKey: Constants.MapViewConstants.MapViewLongitude)
        var latitudeSpan = UserDefaults.standard.double(forKey: Constants.MapViewConstants.MapViewLatitudeSpan)
        var longitudeSpan = UserDefaults.standard.double(forKey: Constants.MapViewConstants.MapViewLongitudeSpan)
        
        // Check if the app was launched the first time
        if (latitude == 0 && longitude == 0 && latitudeSpan == 0 && longitudeSpan == 0) {
            // First launch, set the default location to Salzburg
            latitude = Constants.MapViewConstants.defaultLatitude
            longitude = Constants.MapViewConstants.defaultLongitude
            latitudeSpan = Constants.MapViewConstants.defaultLatitudeDelta
            longitudeSpan = Constants.MapViewConstants.defaultLongitudeDelta
        }
        
        // Set the region depending on the coordinates
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: latitudeSpan, longitudeDelta: longitudeSpan)
        mapViewLocations.setRegion(MKCoordinateRegion(center:location, span:span), animated: true)
    }
    
    func fetchAnnotations() {
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true),
                              NSSortDescriptor(key: "longitude", ascending: false)]
        
        // Fetch pins and add to the mapView
        do {
            if let pins = try? appDelegate.getContext().fetch(fr) as! [Pin] {
                mapViewLocations.addAnnotations(pins)
            }
        }
    }
    // MARK: Handle Long Press
    @objc func handleLongPressGesture(_ longPressGesture: UIGestureRecognizer) {
        let clLocation: CLLocationCoordinate2D = mapViewLocations.convert(longPressGesture.location(ofTouch: 0, in: mapViewLocations), toCoordinateFrom: mapViewLocations)
        
        switch (longPressGesture.state) {
        case .began:
            pin = Pin(context: appDelegate.getContext())
            pin.coordinate.latitude = clLocation.latitude
            pin.coordinate.longitude = clLocation.longitude
            mapViewLocations.addAnnotation(pin)
            
        case .changed:
            pin.willChangeValue(forKey: "coordinate")
            pin.coordinate = clLocation
            pin.didChangeValue(forKey: "coordinate")
        case .ended:
            appDelegate.saveContext()
            
        default:
            return
        }
    }
}

extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    // MARK: MapView Data Source
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                let studentURL = URL(string: toOpen!)
                guard (studentURL != nil) else {
                    self.performUIUpdatesOnMain {
                        self.showAlert("URL Error", message: "No valid URL")
                    }
                    return
                }
                UIApplication.shared.open(studentURL!)
            }
        }
    }
    
    // MARK: MapView Changed
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveActualMapState()
    }
    
    // MARK: MapView PIN selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        let photoAlbumViewController = storyboard?.instantiateViewController(withIdentifier: "photoAlbumViewController" ) as! PhotoAlbumViewController
        
        photoAlbumViewController.pin = view.annotation as! Pin
        
        navigationController?.pushViewController(photoAlbumViewController, animated: true)
    }
}
