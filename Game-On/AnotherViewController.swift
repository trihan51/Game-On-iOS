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
    
    var chosenOne = PFObject?()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        
        
        for element in passedArray{
            print(element.objectId)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
            print("view did appear")
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.tableView.reloadData()
        print("viewDidDisappear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        passedArray = [PFObject]()
        print("viewwilldissapear")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomJoinCell
        
        cell.specificSession?.text = passedArray[indexPath.row].objectId
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        chosenOne = passedArray[indexPath.row]
        
        var arrayOfCurrUser = [String]()
        var currUser = PFUser.currentUser()?.objectId
        
        arrayOfCurrUser = chosenOne!["participants"] as! [String]
        print(arrayOfCurrUser.count)
        arrayOfCurrUser.append(currUser!)
        
        //print(arrayOfCurrUser[0])
        
        chosenOne!["participants"] = arrayOfCurrUser
        
        chosenOne?.saveInBackground()
        
        
        print(chosenOne)
        
        performSegueWithIdentifier("joinGameSessionSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "joinGameSessionSegue") {
            
            var vc = segue.destinationViewController as! SessionPageViewController
            vc.passedInObjectId = chosenOne!
            
            
            
        }
    }
    
    
}
