//
//  HostGameViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/3/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class HostGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gameNames = [String]()
    
    let locationManager = CLLocationManager()
    
    var newHostedGameObjects = PFObject?()
    
    @IBOutlet weak var testLabel: UILabel!
    
    var geoPointOfHost = PFGeoPoint()
    
    var gameLogos = [UIImage]()
    
    var gameBoardsArray = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       queryObjectWay()

        
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else {
            print ("location not enabled")
        }
        
      
        print("View is LOADED")
        
       
    }

   
   
  
    
    
    func queryObjectWay()
    {
        let query = PFQuery(className: "BoardGames")
        query.findObjectsInBackgroundWithBlock{(games: [PFObject]?, error: NSError?) in
            
            if error == nil
            {
                if let games = games {
                    for game in games {
                        
                        self.gameBoardsArray.append(game)
                       
                        
                        
                        
                    }
                    self.tableView.reloadData()
                    //print(self.gameNames)
                }
                print("success", games?.count)
                
            }else{
                print("no success")
            }
            
        }
        
    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "hostGameSegue") {
            
            var vc = segue.destinationViewController as! HostSessionPageViewController
            
            vc.hostedSessionObject = newHostedGameObjects
            
            
            
            
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gameBoardsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! CustomJoinCell
    
        //tableView.estimatedRowHeight = 8
       /*
         cell.gamePic?.image = gameLogos[indexPath.row]
        cell.boardGameName3?.text = gameNames[indexPath.row]*/
        
     
        var imagestodisplay = gameBoardsArray[indexPath.row]["gameLogo"] as! PFFile
        
        imagestodisplay.getDataInBackgroundWithBlock { (result, error) in
            cell.gamePic?.image = UIImage(data:result!)
            
             
        }
        cell.boardGameName3?.text = gameBoardsArray[indexPath.row]["boardName"] as! String
  
       
        
        
        return cell
        
    }
   
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let currentUser = PFUser.currentUser()
        
    
       
        //let row = indexPath.row
        //let arr = setUpView()
        //let stringy = arr[row]
        let gameToCreate = gameBoardsArray[indexPath.row]
        var newHostedGame = PFObject(className:"GameOnSession")
        newHostedGame["gameTitle"] = gameToCreate["boardName"]
        newHostedGame["open"] = true
        newHostedGame["host"] = currentUser
        newHostedGame["location"] = geoPointOfHost
        newHostedGame["participants"] = []
        newHostedGameObjects = newHostedGame
        newHostedGame.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if (success)
            {
                print("game successfully created!")
                
                self.performSegueWithIdentifier("hostGameSegue", sender: self)
                
            } else {
                print("error created this new session")
            }
        }
        
       
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       // queryData()
        var currLocation = locationManager.location
        geoPointOfHost = PFGeoPoint(location:currLocation)
        print("location recaptured")
        
     
       

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
       print("VIEW ABOUT TO APPEAR")
     
       
    }
    
   

    
}