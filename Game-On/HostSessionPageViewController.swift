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
    
    @IBAction func cancelSession(sender: AnyObject) {
        
        hostedSessionObject?.deleteInBackground()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in the sesion for host now")
        print(hostedSessionObject)
        
        gameTitle.text = hostedSessionObject!["gameTitle"] as? String
        var hostUser = PFUser()
        hostUser = hostedSessionObject!["host"] as! PFUser
        hostDisplay.text = hostUser.username
        
    }
    
    func queryParticipantsForGame()
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CustomSessionCell
        
        cell.playerEmailHost.text = usersInGame[indexPath.row].username
        
        cell.playerNameHost.text = usersInGame[indexPath.row]["firstName"] as! String
        
        
        return cell
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return usersInGame.count
    }
    
}
