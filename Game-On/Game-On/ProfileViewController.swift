//
//  ProfileViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/3/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var userInfolabel: UILabel!
    var currentUser = PFUser.currentUser()
    
    @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOut()
       
        print("You have successfully logged out")
        
    }
       
    override func viewDidLoad() {
               testLabel.text = "Profile view screen"
            userInfolabel.text = "User logged in is:" + (currentUser?.username)!
       
        
      
    }

}
