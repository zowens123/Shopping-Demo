//
//  RegisterViewController.swift
//  Shopping Demo
//
//  Created by Zach Owens on 7/8/19.
//  Copyright © 2019 Zach Owens. All rights reserved.
//

import UIKit
import os.log
import Leanplum

class RegisterViewController: UIViewController, UITextFieldDelegate {

    var users: Users?
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var sportsField: UITextField!
    
    var username: String!
    var password: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var phone: String!
    var age: Int = 0
    var sportsInterests: String!
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        phoneField.delegate = self
        sportsField.delegate = self
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func back(_ sender: UIBarButtonItem) {
        
        //depending on style of presentation, the view controller will be dismissed in two ways
        let isPresentingController = presentingViewController is UINavigationController
        
        if isPresentingController {
            dismiss(animated: true, completion: nil)
        }
        else {
            print("back button not working")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        //Configure the destination view controller only when register button is pressed
        guard let button = sender as? UIButton, button == registerButton else {
            os_log("Save button was not pressed, cancelling", log:OSLog.default, type: .debug)
            return
            
        }
        
        let ageInt = Int(ageField.text ?? "0")
        
        username = usernameField.text
        password = passwordField.text
        firstName = firstNameField.text
        lastName = lastNameField.text
        email = emailField.text
        phone = phoneField.text
        age = ageInt ?? 0
        sportsInterests = sportsField.text

        users = Users(username: username, password: password, firstName: firstName, lastName: lastName, email: email, phoneNumber: phone, age: age, interests: sportsInterests)
        
        Leanplum.setUserId(username)
        Leanplum.setUserAttributes(["firstName":firstName, "lastName":lastName, "email":email, "phoneNumber":phone, "age":age, "interests":sportsInterests])
        Leanplum.forceContentUpdate()
        Leanplum.track("userRegistered")

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder?
        
        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            usernameField.resignFirstResponder()
            passwordField.resignFirstResponder()
            firstNameField.resignFirstResponder()
            lastNameField.resignFirstResponder()
            emailField.resignFirstResponder()
            phoneField.resignFirstResponder()
            ageField.resignFirstResponder()
            sportsField.resignFirstResponder()
        }
        
        return false

    }
        

}
