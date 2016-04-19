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
    
    var hostedSessionObject = PFObject?()
   
    @IBOutlet weak var tableView: UITableView!
    
    var array2 = [String]()
    
    var usersInGame = [PFUser]()
    
    var usersInGameSet = Set<PFUser>()
    
   var timer = NSTimer()
    
    @IBAction func cancelSession(sender: AnyObject) {
        
        hostedSessionObject?.deleteInBackground()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
         timer = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: "update", userInfo: nil, repeats: true)
        
        
        print("in the sesion for host now")
        print(hostedSessionObject)
        
        gameTitle.text = hostedSessionObject!["gameTitle"] as? String
        var hostUser = PFUser()
        hostUser = hostedSessionObject!["host"] as! PFUser
        hostDisplay.text = hostUser.username
        
    }
    
    func update() {
        /**
         ADD THE CODE TO UPDATE THE DATA SOURCE
         **/
     
     
        
        dispatch_async(dispatch_get_main_queue())
        {
            self.queryUserInfo()
           
            self.tableView.reloadData()
        }
        
    }
    
    func queryParticipantsForGame()->[String]
    {
        
        let objectIDCompare = hostedSessionObject?.objectId
        
        var query = PFQuery(className: "GameOnSession")
        query.whereKey("objectId", equalTo: objectIDCompare!)
        query.findObjectsInBackgroundWithBlock {
            (object:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
                var currentSession = object![0]
                
                print(currentSession)
                
                self.array2 = currentSession["participants"] as! [String]
                
                
               /* for user in self.array2
                {
                    self.queryUserInfo(user)
                }*/
                /* for element in array2
                 {
                 self.stringArray.append(element)
                 }*/
                
                //print(self.stringArray)
                // stringArray = currentSession["participants"] as! [PFUser]
                
                self.tableView.reloadData()
            } else {
                print("Error in query for participants!!")
            }
            
            
        }
        
        
        return array2
        
    }
    
    func updateUsers()
    {
        for users in array2
        {
           // queryUserInfo(users)
        }
    }

  
    func queryUserInfo()
    {
        let theone = queryParticipantsForGame()
        print(theone.count)
        for user in theone
        {
            usersInGame = [PFUser]()
        
        var userQuery = PFUser.query()
        userQuery!.whereKey("objectId", equalTo: user)
        userQuery!.findObjectsInBackgroundWithBlock {
            (object:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
               // for obj in object!
                //{
                
                    var user = PFUser()
                    user = object![0] as! PFUser
                    //print(obj)
                    //self.usersInGame.append(user)
                
                    self.usersInGame.append(user)
                    print(self.usersInGameSet)
                    print(self.array2)
                    let thiss = self.usersInGame.contains(user)
                    if thiss == true
                    {
                        print("TRUEEEEE")
                    }
                    else{
                        print("falseeee")
                    }
                    
                //}
                
                self.tableView.reloadData()
                
            } else {
                print("Error in query for participants!!")
            }
            
            
        }
        
       // return usersInGame
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(true)
        print("GONEEE")
       timer.invalidate()
    }
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CustomSessionCell
        
        cell.playerEmails.text = usersInGame[indexPath.row].username
        
        cell.playerName.text = usersInGame[indexPath.row]["firstName"] as! String
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return usersInGame.count
    }
    
}
