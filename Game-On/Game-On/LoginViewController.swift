//
//  LoginViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/3/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController{
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    @IBAction func verifyInfo(sender: AnyObject) {
        
        var email = emailAddress.text
        var password = passwordField.text
        
        if email != "" && password != ""
        {
            //no empty fields, proceed to login
            login()
        }
        else{
            print("empty field, all fields required!")
        }
    }
    
    func login()
    {
        var email = emailAddress.text
        var password = passwordField.text

            PFUser.logInWithUsernameInBackground(email!, password:password!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    print("Succesful login!")
                    
                } else {
                    // The login failed. Check error to see why.
                    print("Error logging in, check pass/email")
                }
        }

    }
    
    
    
    
    
}
