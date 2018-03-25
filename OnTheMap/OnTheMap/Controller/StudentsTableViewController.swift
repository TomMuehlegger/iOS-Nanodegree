//
//  StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 22.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    let studentInformations = StudentInformations.sharedInstance
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add the activity indicator to the tableview
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        activityIndicatorView.frame = tableView.frame
        activityIndicatorView.center = tableView.center
        activityIndicatorView.stopAnimating()
        activityIndicatorView.hidesWhenStopped = true
        
        tableView.addSubview(activityIndicatorView)
        
        reload()
    }
    
    // MARK: Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentInformations.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInformationCell", for: indexPath)
        let student = studentInformations.getAtIndex(indexPath.row)
        
        // Set the labels
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaURL
        return cell
    }
    
    // Mark: Open student URL
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = self.studentInformations.getAtIndex(indexPath.row)
        let studentURL = URL(string: student.mediaURL)
        
        // If no URL provided
        guard (studentURL != nil) else {
            performUIUpdatesOnMain() {
                self.showAlert("URL-Error", message: "No valid URL")
            }
            return
        }
        UIApplication.shared.open(studentURL!)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // MARK: Logout
    @IBAction func logout(_ sender: Any) {
        activityIndicatorView.startAnimating()
        
        Client.sharedInstance().logout() {
            (success, error) in
            
            guard (error == nil) else {
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
    
    // MARK: Reload
    @IBAction func reloadClick(_ sender: Any) {
        reload()
    }
    
    func reload() {
        activityIndicatorView.startAnimating()
        
        Client.sharedInstance().getStudentLocations() {
            (success, error) in
            self.performUIUpdatesOnMain {
                self.activityIndicatorView.stopAnimating()
                
                // Check on error
                guard (error == nil) else {
                    self.showAlert("Load students error", message: "An error occurred when loading student informations")
                    return
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: Post new student location
    @IBAction func addNewLocation(_ sender: Any) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "postStudentInformationViewController") as! PostStudentInformationViewController
        navigationController!.pushViewController(controller, animated: true)
    }
}
