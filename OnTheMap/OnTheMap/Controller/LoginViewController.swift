//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 22.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldEmail.delegate = textFieldDelegate
        textFieldPassword.delegate = textFieldDelegate
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.open(URL(string: Client.Constants.Udacity.SignUpUrl)!)
    }
    
    @IBAction func login(_ sender: Any) {
        // Check if email field is empty
        guard (textFieldEmail.text != nil && !(textFieldEmail.text?.isEmpty)!) else {
            showAlert("E-Mail", message: "E-Mail field must not be empty!")
            return
        }
        
        // Check if password field is empty
        guard (textFieldPassword.text != nil && !(textFieldPassword.text?.isEmpty)!) else {
            showAlert("Password", message: "Password field must not be empty!")
            return
        }
        
        activityIndicatorView.startAnimating()
        
        // Login
        Client.sharedInstance().login(textFieldEmail.text!, password: textFieldPassword.text!) { (success, error) in
            
            self.performUIUpdatesOnMain {
                self.activityIndicatorView.stopAnimating()
                
                if success {
                    // Display the tabBarController
                    let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                    self.present(tabBarController, animated: true, completion: nil)
                } else {
                    self.showAlert("Login failed", message: error!)
                }
            }
        }
    }
    
    
    // Move up the view when showing the keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0 - getKeyboardHeight(notification) / 2
        
    }
    
    // Move down the view when showing the keyboard
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        // of CGRect
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Subscribe the view controller to handle keyboard events
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // Unsubscribe the view controller from handling keyboard events
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
}

