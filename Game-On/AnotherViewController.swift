//
//  AnotherViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/11/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse

class AnotherViewController: UIViewController {
    
    @IBOutlet weak var BackButton: UIButton!
    var passedArray = [PFObject]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        for element in passedArray{
            print(element.objectId)
        }
    }
    
    
}
