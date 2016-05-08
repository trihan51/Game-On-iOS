//
//  HostSessionPageViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/18/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

class HostSessionPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate {
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var hostDisplay: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var hostedSessionObject = PFObject?()
   
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    var array2 = [String]()
    
    var usersInGame = [PFUser]()
    
    var usersInGameSet = Set<PFUser>()
    
   var timer = NSTimer()
    
    var hostLocation = PFGeoPoint()
    
    var alertController: UIAlertController?
    
    var cancelAlertController: UIAlertController?
    
    var sharedPref = NSUserDefaults.standardUserDefaults()
    
    
   // @IBOutlet weak var viewMap: GMSMapView!
   
    @IBOutlet weak var viewMap: GMSMapView!
    
    //@IBOutlet weak var viewMap: GMSMapView!
    
    @IBAction func GameOnReady(sender: AnyObject) {
        
        alertController = UIAlertController(title: "Ready to Game On?", message: "Game On?", preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            print("Yes button pressed")
            self.hostedSessionObject!["open"] = false
            self.hostedSessionObject?.saveInBackground()
             self.performSegueWithIdentifier("cancelledGoHome", sender: self)
            
        }
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) in
            print("No buton pressed")
        }
        
        alertController?.addAction(yesAction)
        alertController?.addAction(noAction)
        
        self.presentViewController(alertController!, animated: true) {
            
        }
    }
    
    
    @IBAction func minimizeSession(sender: AnyObject) {
        
        
        let sharedPref = NSUserDefaults.standardUserDefaults()
        sharedPref.setValue(hostedSessionObject?.objectId, forKey: "currentSessionHost")
        performSegueWithIdentifier("minimizeSession", sender: self)

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "minimizeSession")
        {
            var vc = segue.destinationViewController as! ProfileViewController
            vc.passedInObjectSession = hostedSessionObject
        }
    }
    
    @IBAction func cancelSession(sender: AnyObject) {
        
        cancelAlertController = UIAlertController(title: "Cancel session?", message: "Are you sure?", preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            print("Yes button pressed")
            
            self.hostedSessionObject?.deleteInBackground()
           // stringForKey("currentSessionHost")
            self.sharedPref.removeObjectForKey("currentSessionHost")
            self.performSegueWithIdentifier("cancelledGoHome", sender: self)
            
           
            
        }
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) in
            print("No buton pressed")
        }
        
        cancelAlertController?.addAction(yesAction)
        cancelAlertController?.addAction(noAction)
        
        self.presentViewController(cancelAlertController!, animated: true) {
            
        }

        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         timer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: "update", userInfo: nil, repeats: true)
        
       
        
        print("in the sesion for host now")
        print(hostedSessionObject)
        
        gameTitle.text = hostedSessionObject?["gameTitle"] as? String
        var hostUser = PFUser()
        hostUser = (hostedSessionObject?["host"] as? PFUser)!
        hostLocation = hostedSessionObject!["location"] as! PFGeoPoint
        print(hostLocation)
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
                
                var currentSession = object?[0]
                
                print(currentSession)
                
                self.array2 = currentSession!["participants"] as! [String]
                
                
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
        print("number of participants in game")
        print(theone.count)
        if (theone.count != 0)
        {
        for user in theone
        {
            print("in the for LOOP")
            usersInGame = [PFUser]()
        
        var userQuery = PFUser.query()
        userQuery!.whereKey("objectId", equalTo: user)
        userQuery!.findObjectsInBackgroundWithBlock {
            (object:[PFObject]?, error:NSError?) in
            
            if error == nil {
                
               // for obj in object!
                //{
                        print("IN QUERY USER INFO")
                    var user = PFUser()
                    user = object?[0] as! PFUser
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
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //tableView.reloadData()
       
    }
    
    override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(true)
        print("GONEEE")
       timer.invalidate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
        let camera1: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(hostLocation.latitude, longitude: hostLocation.longitude, zoom: 8.0)
        let Map = GMSMapView.mapWithFrame(self.viewMap.bounds, camera: camera1)
        let position = CLLocationCoordinate2DMake(hostLocation.latitude, hostLocation.longitude)
        let marker = GMSMarker(position: position)
        marker.title = "Host's Location"
        marker.map = Map
        Map.camera = camera1
        self.viewMap.addSubview(Map)
        
      
    }
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CustomSessionCell
        
        cell.playerEmails.text = usersInGame[indexPath.row].username
        
        cell.playerName.text = usersInGame[indexPath.row]["firstName"] as? String
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return usersInGame.count
    }
    
}
