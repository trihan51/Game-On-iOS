//
//  ViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 3/21/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            //do stuff
            performSegueWithIdentifier("alreadyLoggedIn", sender: self)
            
        } else {
            //show signup or login
        }
    }
    
   

}

