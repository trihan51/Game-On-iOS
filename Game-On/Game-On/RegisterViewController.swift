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
    
    
    @IBOutlet weak var userFirstName: MKTextField!
    
    @IBOutlet weak var userLastName: MKTextField!
    @IBOutlet weak var userEmail: MKTextField!
    @IBOutlet weak var userPassword: MKTextField!
    
    @IBOutlet weak var userUsername: MKTextField!
    @IBOutlet weak var userPassword2: MKTextField!
    
    var passwordNotSameAlert: UIAlertController?
    
    override func viewDidLoad() {
        self.userFirstName.delegate = self;
        self.userLastName.delegate=self;
        self.userEmail.delegate = self;
        self.userPassword.delegate=self;
        self.userPassword2.delegate = self;
        self.userUsername.delegate = self;
        
        setUpPasswordAlert()
        
    }
    
    func setUpPasswordAlert()
    {
        
        passwordNotSameAlert = UIAlertController(title: "Error", message: "Passwords do not match!", preferredStyle: .Alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .Default) { (action) in
            
        }
        
        passwordNotSameAlert?.addAction(okayAction)
        
    }
    
    @IBAction func verifyRegistrationInfo(sender: AnyObject) {
       
        var email = userEmail.text
        var pass1 = userPassword.text
        var pass2 = userPassword2.text
        var firstname = userFirstName.text
        var lastname = userLastName.text
        var username = userUsername.text
        
        if email != "" && pass1 != "" &&  firstname != "" && lastname != "" && username != "" && pass2 != ""
        {
            //no blank fields, proceed to sign up
            if (pass1 == pass2)
            {
                signUp()
            } else {
                self.presentViewController(passwordNotSameAlert!, animated: true, completion: {
                    pass1 = ""
                    pass2 = ""
                })
            }
           
        }
        else{
            print("error, empty fields")
        }
        
    }
    
    func signUp() {
        var email = userEmail.text
        var pass1 = userPassword.text
        var firstname = userFirstName.text
        var lastname = userLastName.text
        var username = userUsername.text
        
        var user = PFUser()
        user.email = email
        user.username = username
        user.password = pass1
        user["firstName"] = firstname
        user["lastName"] = lastname
        
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print(errorString)
            } else {
                // Hooray! Let them use the app now.
                self.performSegueWithIdentifier("registerSuccess", sender: self)
                print("succesfully registered!")
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
            case userFirstName:
                userLastName.becomeFirstResponder()
            case userLastName:
                userUsername.becomeFirstResponder()
        case userUsername:
            userEmail.becomeFirstResponder()
            case userEmail:
                userPassword.becomeFirstResponder()
            case userPassword:
                userPassword2.becomeFirstResponder()
            default:
                break
        }
        return false
    }
    
    /**********************************************************************/
    // Code from here ...
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    // Lifting the view up
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    // ... to here was taken from http://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present
    /**********************************************************************/
}