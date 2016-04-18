//
//  HostSessionPageViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/18/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse

class HostSessionPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var hostDisplay: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
   
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CustomSessionCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
}
