//
//  SessionPageViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/16/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps
import MapKit

class SessionPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var passedInObjectId = PFObject?()

     var bounds = GMSCoordinateBounds()
    
    @IBOutlet weak var hostName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var gameTitle: UILabel!
    
    var stringArray = [String]()
    
    var path = GMSMutablePath()
    
    var array2 = [String]()
    
    var hostLocation = PFGeoPoint()
    
    var userLocation = PFGeoPoint()
    
    var closedSession = true
    
    var closedSessionController : UIAlertController?
    var leaveSessionController : UIAlertController?
    
    var sessionStartedController: UIAlertController?
    
    var startedSession = false
    
    @IBOutlet weak var viewMap: GMSMapView!
    
     var timer = NSTimer()
    var usersInGame = [PFUser]()
    
    @IBAction func leaveButton(sender: AnyObject) {
        
        leaveSessionController = UIAlertController(title: "Game-On", message: "Leave this game?", preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            print("Yes button pressed")
            
            var currUser = PFUser.currentUser()?.objectId
            var query = PFQuery(className: "GameOnSession")
            query.whereKey("objectId", equalTo:(self.passedInObjectId?.objectId)!)
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
                    
                    self.performSegueWithIdentifier("leftGameGoHome", sender: self)
                    
                } else {
                    print("error leaving game")
                }
            }
            
            print("leave button clicked")
            
            
            
            
        }
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) in
            print("No buton pressed")
        }
        
        leaveSessionController?.addAction(yesAction)
        leaveSessionController?.addAction(noAction)
        
        self.presentViewController(leaveSessionController!, animated: true) {
            
        }
        
        
        
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var currentUser = PFUser.currentUser()
        //let hosty =  PFUser()
        
        let hosty = passedInObjectId!["host"] as! PFUser
        hostLocation = passedInObjectId!["location"] as! PFGeoPoint
        let hostObjectID = hosty.objectId
        print(hosty.objectId)
        queryAdditionalHostInfo(hosty)
        queryParticipantsForGame()
        
         timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "update", userInfo: nil, repeats: true)
        
        gameTitle.text = passedInObjectId!["gameTitle"] as! String
        //hostName.text = "Host: \(hostObjectID!)"
        //let HostAdditional = queryAdditionalHostInfo(hosty)
        //var username = String()
        //username = HostAdditional["username"] as! String
        //hostName.text = "Host:" + username
      tableView.reloadData()
        //print(array2.count)
        
        setUpAlertClosedSession()
        setUpSessionStartedAlert()
       
        
    }
    
    func giveDirections()
    {
        let coordinate = CLLocationCoordinate2DMake(hostLocation.latitude,hostLocation.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Host's Location"
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeDriving : MKLaunchOptionsDirectionsModeKey])
    }
    
    func setUpAlertClosedSession()
    {
        closedSessionController = UIAlertController(title: "Sorry!", message: "The host cancelled the session.", preferredStyle: .Alert)
      
        
        let doneAction = UIAlertAction(title: "Done", style: .Default) { (action) in
            print("Done Pressed")
            
            self.performSegueWithIdentifier("sessionClosedGoHome", sender: self)
           
        }
        
        
        closedSessionController?.addAction(doneAction)
      
        
    }
    
    
    func setUpSessionStartedAlert()
    {
        sessionStartedController = UIAlertController(title: "Game-On", message: "The game has started!", preferredStyle: .Alert)
        
        
        let doneAction = UIAlertAction(title: "Directions please!", style: .Default) { (action) in
           self.giveDirections()
            
            self.performSegueWithIdentifier("sessionClosedGoHome", sender: self)
            
        }
        
        
        sessionStartedController?.addAction(doneAction)
        
        
    }
    func update() {
        /**
         ADD THE CODE TO UPDATE THE DATA SOURCE
         **/
        self.queryUserInfo()
        
        let checkSession = checkIfSessionClosed()
      
        if (checkSession == false)
        {
            timer.invalidate()
            presentViewController(self.closedSessionController!, animated: true) {
               
               
            }
            
        }
        
        let sessionStart = checkIfSessionStarted()
       
       
        
        dispatch_async(dispatch_get_main_queue())
        {
          
            
            if (sessionStart == true)
            {
                self.timer.invalidate()
                self.presentViewController(self.sessionStartedController!, animated: true) {
                    
                    
                }
            }
          
            self.tableView.reloadData()
        }
        
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
    
     func checkIfSessionClosed() -> Bool
    {
        
        var query = PFQuery(className: "GameOnSession")
        query.whereKey("objectId", equalTo:(passedInObjectId?.objectId)!)
        query.findObjectsInBackgroundWithBlock { (object: [PFObject]?, error:NSError?) in
            if object?.count == 0{
                print("SESSION CLOSEDDDD")
                self.closedSession = false
            } else {
                print(object?.count)
                print("SESSION STILL OPEN")
                self.closedSession = true
            }
        }
        
        return closedSession
    }
    
    func checkIfSessionStarted() -> Bool
    {
        
        var query = PFQuery(className: "GameOnSession")
        query.whereKey("objectId", equalTo:(passedInObjectId?.objectId)!)
        query.findObjectsInBackgroundWithBlock { (object: [PFObject]?, error:NSError?) in
            if error == nil
            {
                var currentsession = object?[0]
                var statusofGame = currentsession?["open"] as! Bool
                if (statusofGame == false)
                {
                    self.startedSession = true
                     print("SESSION STARTED")
                }
                else {
                    self.startedSession = false
                    print("SESSION NOT STARTED YET")
                }
            } else {
                print("Error occured in checking if session started")
            }
        }
        
        return startedSession
    }
    
    func queryParticipantsForGame()->[String]
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
        
        
        return array2
     
    }
    
    
    func queryUserInfo()
    {
        let theone = queryParticipantsForGame()
        print(theone.count)
        usersInGame = [PFUser]()
        for user in theone
        {
            
        
        var userQuery = PFUser.query()
        userQuery!.whereKey("objectId", equalTo: user)
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
                print(error)
            }
            
            
        }
        }
        
        //return usersInGame
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
      
        self.tableView.reloadData()
        print("view willll appppear!")
       /* let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
        let Map = GMSMapView.mapWithFrame(self.viewMap.bounds, camera: camera)
        Map.camera = camera
        self.viewMap.addSubview(Map) */
        
        let camera1: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(hostLocation.latitude, longitude: hostLocation.longitude, zoom: 8.0)
        let Map = GMSMapView.mapWithFrame(self.viewMap.bounds, camera: camera1)
        let position = CLLocationCoordinate2DMake(hostLocation.latitude, hostLocation.longitude)
        let marker = GMSMarker(position: position)
        marker.title = "Host's Location"
        marker.icon = GMSMarker.markerImageWithColor(UIColor.orangeColor())
        

        marker.map = Map
        let usersPosition = CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude)
        let usersMarker = GMSMarker(position:usersPosition)
        usersMarker.title = "Your location"
        usersMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        usersMarker.map = Map
        //Map.camera = camera1
        self.viewMap.addSubview(Map)
        
        var markers = [CLLocationCoordinate2D]()
        markers.append(position)
        markers.append(usersPosition)
        
        
       for marker in markers
       {
            path.addCoordinate(marker)
        }
        bounds.includingPath(path)
       
        let camera2: GMSCameraUpdate = GMSCameraUpdate.fitBounds(bounds, withPadding:10.0)
        Map.animateWithCameraUpdate(camera2)
        
        self.viewMap.addSubview(Map)

        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        timer.invalidate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print(array2)
        
      /*  for user in array2
        {
            queryUserInfo(user)
        }*/
        queryUserInfo()
        print("view did appear!!!")
        self.tableView.reloadData()
    }
    
  
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomSessionCell
        
       
        cell.playerName?.text = usersInGame[indexPath.row].username
        
        cell.playerEmailLabel?.text = usersInGame[indexPath.row]["firstName"] as? String
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        
            //let sizeRight = queryUserInfo(<#T##userObjectID: String##String#>)
               // print(usersInGame.count)
        
                return usersInGame.count
    }
}
