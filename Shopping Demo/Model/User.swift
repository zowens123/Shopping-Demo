//
//  User.swift
//  Shopping Demo
//
//  Created by Zach Owens on 7/9/19.
//  Copyright © 2019 Zach Owens. All rights reserved.
//

import UIKit
import os.log

class Users: NSObject, NSCoding {
    
    //Mark: Properties
    var username: String
    var password: String
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var age: Int
    var interests: String
    
    //Mark: Archiving Paths
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("users")

    //Mark: Types
    struct userProperties {
        
        static let  username = "username"
        static let  password = "password"
        static let  firstName = "firstName"
        static let  lastName = "lastName"
        static let  email = "email"
        static let  phoneNumber = "phoneNumber"
        static let  age = "age"
        static let  interests = "interests"
        
    }
    
    //Mark: Initialization
    init?(username: String, password: String, firstName: String, lastName: String, email: String, phoneNumber: String, age: Int, interests: String) {
        
        //Mark: Initialization Fails if no value
        guard !username.isEmpty || !password.isEmpty else {
            return nil
        }
        
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.age = age
        self.interests = interests
    }
    
    //NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: userProperties.username)
        aCoder.encode(password, forKey: userProperties.password)
        aCoder.encode(firstName, forKey: userProperties.firstName)
        aCoder.encode(lastName, forKey: userProperties.lastName)
        aCoder.encode(email, forKey: userProperties.email)
        aCoder.encode(phoneNumber, forKey: userProperties.phoneNumber)
        aCoder.encode(age, forKey: userProperties.age)
        aCoder.encode(interests, forKey: userProperties.interests)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //username and password are required. If we cannot decode, the init should fail
        guard let username = aDecoder.decodeObject(forKey: userProperties.username) as? String
            else {
                os_log("Unable to decode the username of the user.", log: OSLog.default, type: .debug)
                return nil
        }
        
        guard let password = aDecoder.decodeObject(forKey: userProperties.password) as? String
            else {
                os_log("Unable to decode the password of the user.", log: OSLog.default, type: .debug)
                return nil
        }
        
        
        guard let firstName = aDecoder.decodeObject(forKey: userProperties.firstName) as? String else { return nil }
        guard let lastName = aDecoder.decodeObject(forKey: userProperties.lastName) as? String else { return nil }
        guard let email = aDecoder.decodeObject(forKey: userProperties.email) as? String else { return nil }
        guard let phoneNumber = aDecoder.decodeObject(forKey: userProperties.phoneNumber) as? String else { return nil }
        let age = aDecoder.decodeInteger(forKey: userProperties.age)
        guard let interests = aDecoder.decodeObject(forKey: userProperties.interests) as? String else { return nil }
        
        //calling designated initilizer
        self.init(username: username, password: password, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, age: age, interests: interests)
    }

    
}
