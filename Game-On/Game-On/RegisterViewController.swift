//
//  SecondViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 3/21/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController,UITextFieldDelegate{
    
    
    @IBOutlet weak var userFirstName: UITextField!
    
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userPassword2: UITextField!
    
    override func viewDidLoad() {
        self.userFirstName.delegate = self;
        self.userLastName.delegate=self;
        self.userEmail.delegate = self;
        self.userPassword.delegate=self;
        self.userPassword2.delegate = self;
        
    }
    
    @IBAction func verifyRegistrationInfo(sender: AnyObject) {
       
        var email = userEmail.text
        var pass1 = userPassword.text
        var firstname = userFirstName.text
        var lastname = userLastName.text
        
        if email != "" && pass1 != "" &&  firstname != "" && lastname != ""
        {
            //no blank fields, proceed to sign up
            signUp()
        }
        else{
            print("error, empty fields")
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func signUp() {
        var email = userEmail.text
        var pass1 = userPassword.text
        var firstname = userFirstName.text
        var lastname = userLastName.text
        
        var user = PFUser()
        user.username = email
        user.password = pass1
        user["Name"] = firstname
        user["lastName"] = lastname
      
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print(errorString)
            } else {
                // Hooray! Let them use the app now.
                print("succesfully registered!")
            }
        }
    }
    
}