//
//  ViewController.swift
//  Shopping Demo
//
//  Created by Zach Owens on 6/26/19.
//  Copyright © 2019 Zach Owens. All rights reserved.
//

import UIKit
import os
import Leanplum

class LoginViewController: UIViewController, UITextFieldDelegate {

    var cartTransfer: MyCart?
    var users = [Users]()
    var userAuth = [String]()
    var username:String!
    var password:String!

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        userNameField.delegate = self
        passwordField.delegate = self
        
        if let userlist = loadUsers() {
            users += userlist
        }
        loadAuth()
        
        print("this is the users array \(users)")
        
    }

    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // the view controller will be dismissed 
        let isPresentingLoginMode = presentingViewController is UINavigationController
        
        if isPresentingLoginMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("ShoppingTableVC is not inside a navigation controller")
        }
    }
    
    @IBAction func signin(_ sender: UIButton) {
        
        username = userNameField.text
        password = passwordField.text
        let usersLogin = userAuth
        
        if (username.isEmpty == false && password.isEmpty == false) {
            
            if usersLogin.contains(username) {
                
                Leanplum.setUserId(username)
                print("----Login is Successful----")
                Leanplum.forceContentUpdate()
                _ = navigationController?.popViewController(animated: true)
                
            }
            else {
                
                let alert = UIAlertController(title: "Sign In", message: "Username Not Found, Please Register First", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            
            let alert = UIAlertController(title: "Sign In", message: "All Fields Are Required", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }

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
            userNameField.resignFirstResponder()
            passwordField.resignFirstResponder()
        }
        
        return false
    }
    
    @IBAction func unwindUsersList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? RegisterViewController, let user = sourceViewController.users {
            // Add a new user.
            users.append(user)
            saveUser()
        }
        
        loadAuth()
        print(loadAuth())
    }
    
    private func saveUser() {
        let saveSuccessful = NSKeyedArchiver.archiveRootObject(users, toFile: Users.ArchiveURL.path)
        
        if saveSuccessful {
            os_log("user successfully saved", log: OSLog.default, type: .debug)
            
        }
        else {
            os_log("user failed to save", log: OSLog.default, type: .error)
            
        }
    }
    
    private func loadUsers() -> [Users]? {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: Users.ArchiveURL.path) as? [Users] )
    }
    
    private func loadAuth() -> Array<String> {
        
        for user in users {
            
            userAuth.append(user.username)
            
        }
        
        print("this is the user auth array \(userAuth)")
        return userAuth
    }
    
}


