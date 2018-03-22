//
//  StudentInformations.swift
//  OnTheMap
//
//  Created by Thomas Muehlegger on 21.03.18.
//  Copyright © 2018 Thomas Muehlegger. All rights reserved.
//

class StudentInformations {
    
    var studentInformations = [StudentInformation]()
    static let sharedInstance = StudentInformations()
    
    // Add student informations
    func addStudentInformationsFromResult(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        for result in results {
            studentInformations.append(StudentInformation(dictionary: result))
        }
        return studentInformations
    }
    
    func count() -> Int {
        return studentInformations.count
    }
    
    func getAll() -> [StudentInformation] {
        return studentInformations
    }
    
    func getAtIndex( _ index: Int) -> StudentInformation {
        return studentInformations[index]
    }
    
    func removeAll() -> Void {
        studentInformations.removeAll()
    }
    
}
