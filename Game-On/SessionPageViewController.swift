//
//  SessionPageViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/16/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse

class SessionPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var passedInObjectId = PFObject?()
    
    @IBOutlet weak var hostName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var gameTitle: UILabel!
    
    @IBAction func leaveButton(sender: AnyObject) {
        
        var currUser = PFUser.currentUser()?.objectId
        var query = PFQuery(className: "GameOnSession")
        query.whereKey("objectId", equalTo:(passedInObjectId?.objectId)!)
        query.findObjectsInBackgroundWithBlock { (object:[PFObject]?, error:NSError?) in
            if error == nil{
                var sessionToLeaveFrom = object![0]
                var stringArray = [String]()
                stringArray = sessionToLeaveFrom["participants"] as! [String]
                
                for items in stringArray
                {
                    if items == currUser
                    {
                        let index1 = stringArray.indexOf(currUser!)
                        stringArray.removeAtIndex(index1!)
                    }
                }
                self.passedInObjectId!["participants"] = stringArray
                
                self.passedInObjectId?.saveInBackground()
                
            } else {
                
            }
        }
       
        print("leave button clicked")
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUser = PFUser.currentUser()
        //let hosty =  PFUser()
        
        let hosty = passedInObjectId!["host"] as! PFUser
        let hostObjectID = hosty.objectId
        print(hosty.objectId)
        queryAdditionalHostInfo(hosty)
        gameTitle.text = passedInObjectId!["gameTitle"] as! String
        //hostName.text = "Host: \(hostObjectID!)"
        //let HostAdditional = queryAdditionalHostInfo(hosty)
        //var username = String()
        //username = HostAdditional["username"] as! String
        //hostName.text = "Host:" + username
       
        
    }
    
    func queryAdditionalHostInfo(host : PFUser)
    {
       // var hostInfo = PFUser()
        
       
        var query = PFUser.query()
        query!.whereKey("objectId", equalTo: host.objectId!)
        query!.findObjectsInBackgroundWithBlock {
            (user:[PFObject]?, error:NSError?) in
            
            if error == nil{
                var hostInfo = user![0]
                var hostUsernames = String()
                hostUsernames = hostInfo["username"] as! String
                self.hostName.text = "Host: \(hostUsernames)"
            } else {
                
            }
        }
        /*do {
            
            var hostInfo = try query.find
           print(hostInfo["username"])
        } catch {
            print (error)
        }*/
        
     
        
      
       
    }
    /*
    //query info as a user JOINING
    func queryHostInfo() ->PFUser
    {
        let query = PFQuery(className: "GameOnSession")
         query.whereKey("Open", equalTo: true)
        query.whereKey("objectId", equalTo: true)
        
        
        return user
    }*/
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomSessionCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
