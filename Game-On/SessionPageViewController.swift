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
    
    var stringArray = [String]()
    
    var array2 = [String]()
    
    var usersInGame = [PFUser]()
    
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
                print("error leaving game")
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
        queryParticipantsForGame()
        
        
        
        gameTitle.text = passedInObjectId!["gameTitle"] as! String
        //hostName.text = "Host: \(hostObjectID!)"
        //let HostAdditional = queryAdditionalHostInfo(hosty)
        //var username = String()
        //username = HostAdditional["username"] as! String
        //hostName.text = "Host:" + username
      tableView.reloadData()
        //print(array2.count)
       
        
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
    
    func queryParticipantsForGame()
    {
       
        
        
        var query = PFQuery(className: "GameOnSession")
        query.whereKey("objectId", equalTo:(passedInObjectId?.objectId)!)
        query.findObjectsInBackgroundWithBlock {
            (object:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                var currentSession = object![0]
                
                print(currentSession)
                
                self.array2 = currentSession["participants"] as! [String]
                

               /* for element in array2
                {
                    self.stringArray.append(element)
                }*/
                
                //print(self.stringArray)
                // stringArray = currentSession["participants"] as! [PFUser]
                
              
            } else {
                print("Error in query for participants!!")
            }
            
            
        }
        
        
        
     
    }
    
    
    func queryUserInfo(userObjectID:String)->[PFUser]
    {
        
        var userQuery = PFUser.query()
        userQuery!.whereKey("objectId", equalTo: userObjectID)
        userQuery!.findObjectsInBackgroundWithBlock {
            (object:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                for obj in object!
                {
                    
                    var user = PFUser()
                    user = obj as! PFUser
                    //print(obj)
                    //self.usersInGame.append(user)
                    self.usersInGame.append(user)
                    print(user.username)
                    
                    
                }
               
                self.tableView.reloadData()
                
            } else {
                print("Error in query for participants!!")
            }
            
            
        }
        
        return usersInGame
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
      
        self.tableView.reloadData()
        print("view willll appppear!")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print(array2)
        
        for user in array2
        {
            queryUserInfo(user)
        }
        print("view did appear!!!")
        self.tableView.reloadData()
    }
    
  
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomSessionCell
        
       
        cell.playerName?.text = usersInGame[indexPath.row].username
        
        cell.playerEmailLabel?.text = usersInGame[indexPath.row]["firstName"] as! String
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        
            //let sizeRight = queryUserInfo(<#T##userObjectID: String##String#>)
               // print(usersInGame.count)
        
                return usersInGame.count
    }
}
