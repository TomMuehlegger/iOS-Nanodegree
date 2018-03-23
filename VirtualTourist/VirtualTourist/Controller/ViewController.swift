//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Thomas Muehlegger on 23.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: Shows an alert message
    func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        return
    }
    
    // MARK: GCDBlackBox to perform on main queue
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
