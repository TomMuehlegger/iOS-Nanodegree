//
//  TextFieldDelegate.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 22.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

import UIKit

// MARK: TextFieldDelegate
class TextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
