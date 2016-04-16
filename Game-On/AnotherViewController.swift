//
//  AnotherViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/11/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse

class AnotherViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var BackButton: UIButton!
    
    var passedArray = [PFObject]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        for element in passedArray{
            print(element.objectId)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomJoinCell
        
        cell.specificSession?.text = passedArray[indexPath.row].objectId
        
        return cell

    }
    
}
