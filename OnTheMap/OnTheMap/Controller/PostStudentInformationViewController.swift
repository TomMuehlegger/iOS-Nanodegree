//
//  PostStudentInformationViewController.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 22.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit
import MapKit

class PostStudentInformationViewController : UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var textFieldURL: UITextField!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationPlacemark: MKPlacemark!
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the navigation bar
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancel))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.title = "Add location"
        
        textFieldLocation.delegate = textFieldDelegate
        textFieldURL.delegate = textFieldDelegate
        
        buttonSubmit.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    @objc func cancel(){
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Search location
    @IBAction func searchLocation(_ sender: Any) {
        
        //Check location field
        guard (textFieldLocation != nil && !(textFieldLocation.text?.isEmpty)!) else {
            showAlert("Location Error", message: "The location field must not be empty")
            return
        }
        
        // Geocoder to fetch the location
        let geocoder = CLGeocoder()
        activityIndicator.startAnimating()
        
        geocoder.geocodeAddressString(textFieldLocation.text!) {
            (CLPlacemark, error) in
            
            guard (error == nil) else {
                self.performUIUpdatesOnMain() {
                    self.showAlert("GeoCoding-Error", message: (error?.localizedDescription)!)
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard ((CLPlacemark?.count)! > 0) else {
                self.performUIUpdatesOnMain {
                    self.showAlert("GeoCoding-Error", message: "No results found")
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            self.performUIUpdatesOnMain() {
                self.activityIndicator.stopAnimating()
                
                // Show the submit button to post the location
                self.buttonSubmit.isHidden = false
                self.locationPlacemark = MKPlacemark(placemark: CLPlacemark![0])
                self.mapView.addAnnotation(self.locationPlacemark)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                let zoomToUser = MKCoordinateRegionMake((self.locationPlacemark!.location?.coordinate)!, span)
                self.view.endEditing(true)
                self.mapView.setRegion(zoomToUser, animated: true)
            }
        }
    }
    
    // MARK: Post student information
    @IBAction func postStudentInformation(_ sender: Any) {
        // Check website field
        guard (textFieldURL != nil && !(textFieldURL.text?.isEmpty)!) else {
            showAlert("Link Error", message: "The website field must not be empty")
            return
        }
        
        // Check correct website field
        guard ( (textFieldURL.text?.starts(with: "http://"))! || (textFieldURL.text?.starts(with: "https://"))! ) else {
            showAlert("Link Error", message: "Invalid link. Include http(s)://")
            return
        }
        
        Client.sharedInstance().postStudentLocation(textFieldLocation.text!, mediaURL: textFieldURL.text!, coordinate: locationPlacemark.coordinate) {
            (success, error) in
            
            self.performUIUpdatesOnMain {
                if success {
                    // Dismiss the view controller
                    self.cancel()
                } else {
                    self.showAlert("Updating location failed", message: "An error occurred when updating the location.")
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }    
}
