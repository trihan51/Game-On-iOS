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
    
    @IBOutlet weak var testLabel: UILabel!
    
    var geoPointOfHost = PFGeoPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = "Host view screen"
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
        
        if(segue.identifier == "joinGameSegue") {
            
            var vc = segue.destinationViewController as! SessionPageViewController
            
            
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gameNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CustomJoinCell
        
        cell.boardGameName2?.text = gameNames[indexPath.row]
        
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
        newHostedGame["Open"] = true
        newHostedGame["host"] = currentUser
        newHostedGame["location"] = geoPointOfHost
        newHostedGame.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if (success)
            {
                print("game successfully created!")
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

    }

    
}