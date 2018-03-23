//
//  StudentsMapViewController.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 22.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit
import MapKit

class StudentsMapViewController: UIViewController, MKMapViewDelegate {
    
    let studentInformations = StudentInformations.sharedInstance
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.delegate = self
        super.viewWillAppear(animated)
        reload()
    }
    
    // MARK: MapView Data Source
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
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
    
    fileprivate func removeAnnotations() {
        let annotationsToRemove = mapView.annotations.filter {
            $0 !== mapView.userLocation
        }
        mapView.removeAnnotations(annotationsToRemove)
    }
    
    fileprivate func displayStudentPins() {
        
        var annotations = [MKPointAnnotation]()
        
        for student in studentInformations.getAll() {
            let annotation = MKPointAnnotation()
            
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            // Set the coordinates
            let latidude = CLLocationDegrees(student.latitude)
            let longitude = CLLocationDegrees(student.longitude)
            annotation.coordinate = CLLocationCoordinate2D(latitude: latidude, longitude: longitude)
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
        
    }
    
    // MARK: Logout
    @IBAction func logout(_ sender: Any) {
        activityIndicatorView.startAnimating()
        
        Client.sharedInstance().logout(){
            (success, error) in
            
            guard(error == nil) else {
                self.showAlert("Logout Failed", message: "An error occurred when logging out the user.")
                return
            }
            
            // Dismiss the tab view controller
            self.performUIUpdatesOnMain {
                self.activityIndicatorView.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func reloadClick(_ sender: Any) {
        reload()
    }
    
    func reload() {
        activityIndicatorView.startAnimating()
        
        Client.sharedInstance().getStudentLocations {
            (success, error) in
            self.performUIUpdatesOnMain {
                self.activityIndicatorView.stopAnimating()
                
                // Check on error
                guard(error == nil) else {
                    self.showAlert("Load students error", message: "An error occurred when loading student informations")
                    return
                }
                self.removeAnnotations()
                self.displayStudentPins()
            }
        }
    }
    
    // MARK: Post new student location
    @IBAction func addNewLocation(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "postStudentInformationViewController") as! PostStudentInformationViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }
}
