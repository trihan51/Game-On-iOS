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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        queryData()
        
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
        
        
    }

   
    
    func queryData()
    {
        let query = PFQuery(className: "BoardGames")
        query.findObjectsInBackgroundWithBlock{(games: [PFObject]?, error: NSError?) in
            
            if error == nil
            {
                if let games = games {
                    for game in games {
                        
                        self.gameNames.append(game["boardName"] as! String)
                            print(game)
                        let thumbnailImage = game["gameLogo"] as? PFFile
                        thumbnailImage!.getDataInBackgroundWithBlock   {
                            (imageData: NSData?, error:NSError?) in
                            
                            if error == nil {
                                if let image = UIImage(data: (imageData)!)
                                {
                                    self.gameLogos.append(image)
                                }
                            } else {
                                print("error with data image???")
                            }
                            self.tableView.reloadData()
                        }
                    }
                    self.tableView.reloadData()
                    print(self.gameNames)
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
        
        return gameLogos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! CustomJoinCell
    
        tableView.estimatedRowHeight = 26
        cell.boardGameName3?.text = gameNames[indexPath.row]
        cell.gamePic?.image = gameLogos[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let currentUser = PFUser.currentUser()
       
        //let row = indexPath.row
        //let arr = setUpView()
        //let stringy = arr[row]
        let gameToCreate = gameNames[indexPath.row]
        var newHostedGame = PFObject(className:"GameOnSession")
        newHostedGame["gameTitle"] = gameToCreate
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
        var currLocation = locationManager.location
        geoPointOfHost = PFGeoPoint(location:currLocation)
        print("location recaptured")
        self.tableView.reloadData()
       

    }

    
}