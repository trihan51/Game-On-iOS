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
    
    @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOut()
        
        
       
        print("You have successfully logged out")
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    


               testLabel.text = "Profile view screen"
        
       
        
        
      
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        var currentUser = PFUser.currentUser()

        if currentUser != nil{
            userInfolabel.text = currentUser?.username
        }else {
            userInfolabel.text = "User is here"
        }
        
    }

}
