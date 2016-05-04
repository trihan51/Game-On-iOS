//
//  JoinGameViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/3/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class JoinGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {
    
    var gameNames = [String]()
    var test = ["manny", "sam", "bob"]
    var gameTypes = ["Monopoly", "Chess", "Settlers of Catan", "Splendor", "Werewolf", "Checkers", "Caverna: The Cave Farmers"]
    
    var chessArray = [PFObject]()
    var monopolyArray = [PFObject]()
    var settlersArray = [PFObject]()
     var splendorArray = [PFObject]()
    var werewolfArray = [PFObject]()
    var checkersArray = [PFObject]()
    var cavernaArray = [PFObject]()
    
    var chosenSessions = String()
    var timer = NSTimer()
    
     let locationManager = CLLocationManager()
    
    var usersLocation = PFGeoPoint()
    
    var longPressRecognizer = UILongPressGestureRecognizer()
    
    func update() {
        /**
         ADD THE CODE TO UPDATE THE DATA SOURCE
         **/
        self.splendorArray = [PFObject]()
        self.chessArray = [PFObject]()
        self.monopolyArray = [PFObject]()
        self.settlersArray = [PFObject]()
        self.werewolfArray = [PFObject]()
        self.checkersArray = [PFObject]()
        self.cavernaArray = [PFObject]()
        self.chosenSessions = String()
        
        queryData()
        
        dispatch_async(dispatch_get_main_queue())
        {
            self.tableView.reloadData()
        }
        
    }
    
    @IBOutlet weak var testLabel: UILabel!
   
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
            // tapRecognizer, placed in viewDidLoad
        //longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        //self.view.addGestureRecognizer(longPressRecognizer)
        
        self.splendorArray = [PFObject]()
        
       // queryData()
        
        
       // tableView.registerClass(CustomJoinCell.self, forCellReuseIdentifier: "cell")
       // tableView.delegate = self
        //tableView.dataSource = self
        
         timer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "update", userInfo: nil, repeats: true)
        
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
    
    override func viewWillDisappear(animated: Bool) {
        self.splendorArray = [PFObject]()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        timer.invalidate()
    }
    @IBAction func handleLongPress(sender: UILongPressGestureRecognizer) {
      
        if (sender.state == UIGestureRecognizerState.Began)
        {
            
           var p = sender.locationInView(self.tableView)
            
            if let indexPath = self.tableView.indexPathForRowAtPoint(p)
            {
               
                    let cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
                    if (cell.highlighted)
                    {
                        print("IT WORKSSSSS")
                         let oneTwo = setUpView()
                        let string = oneTwo[indexPath.row]
                        print(string)
                    }
                
                
            }
            
        }
        
    }
    
    /*
    //Called, when long press occurred
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("presseddddd")
            let touchPoint = longPressGestureRecognizer.locationInView(self.view)
            if let indexPath = self.tableView.indexPathForRowAtPoint(touchPoint) {
                let cell = tableView(self.tableView, cellForRowAtIndexPath: indexPath)
                if (cell.is)
                {
                     print("you pressed !!!!")
                }
                
               
                
                // your code here, get the row for the indexPath or do whatever you want
            }
        }
    }
    
    
    */
    
    func queryData()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let radiusSearch = defaults.doubleForKey("radiusToSearchWithin")
        print(radiusSearch)
        
        if (radiusSearch != 0)
        {
        var testArray = [PFObject]()
        let currentUser = PFUser.currentUser()
        var query = PFQuery(className: "GameOnSession")
        query.whereKey("open", equalTo: true)
        query.orderByAscending("createdAt")
        query.whereKey("host", notEqualTo: currentUser!)
        query.whereKey("location", nearGeoPoint: usersLocation, withinMiles: radiusSearch)
        query.findObjectsInBackgroundWithBlock{(games: [PFObject]?, error: NSError?) in
            
            if error == nil
            {
                if let games = games {
                    for game in games {
                        //self.gameNames.append((game["gameTitle"] as? String)!)
                        testArray.append(game)
                        self.filterGameResults(game)
                    }
                    self.tableView.reloadData()
                   
                }  
                
            }else{
                print("no success")
            }
            
        }
        }
        else {
            var testArray = [PFObject]()
            let currentUser = PFUser.currentUser()
            var query = PFQuery(className: "GameOnSession")
            query.whereKey("open", equalTo: true)
            query.orderByAscending("createdAt")
            query.whereKey("host", notEqualTo: currentUser!)
            query.findObjectsInBackgroundWithBlock{(games: [PFObject]?, error: NSError?) in
                
                if error == nil
                {
                    if let games = games {
                        for game in games {
                            //self.gameNames.append((game["gameTitle"] as? String)!)
                            testArray.append(game)
                            self.filterGameResults(game)
                        }
                        self.tableView.reloadData()
                        
                    }
                    
                }else{
                    print("no success")
                }
                
            }
        }

    }
    
    func filterGameResults(game:PFObject)
    {
       
        //Game Object is given, check if it matches a certain game title, then
       var gameID = game["gameTitle"]
        
        if (gameID as! String == "Chess")
        {
            chessArray.append(game)
        }
        else if ( gameID as! String == "Monopoly")
        {
            monopolyArray.append(game)
        }
        else if (gameID as! String == "Settlers of Catan")
        {
            settlersArray.append(game)
        }
        else if (gameID as! String == "Splendor")
        {
            splendorArray.append(game)
            //splendorTest(<#T##game: PFObject##PFObject#>)
            //splendorArray = [game]
        }
        else if(gameID as! String == "One Night Ultimate Werewolf")
        {
            werewolfArray.append(game)
        }
        else if(gameID as! String == "Checkers")
        {
            checkersArray.append(game)
        }
        else if(gameID as! String == "Caverna: The Cave Farmers")
        {
            cavernaArray.append(game)
        }
       
         //print(chessArray)
         //print(monopolyArray)
        //print(settlersArray)
        
            
            
       
    }
    
    /*
    func splendorTest(game:PFObject)->[PFObject]
    {
        var splendorArray = [PFObject]()
        
        splendorArray.append(game)
        
        return splendorArray
        
    }*/
    
    //check if array is empty
    func countGames(array: [PFObject])->Bool
    {
        if (array.count > 0)
        {
            return true
        }
        else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let two = setUpView()
               return two.count
    }
    
    /*func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return gameTypes.count
    }*/
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomJoinCell
        
      
        //let test2 = settlersArray[indexPath.row]
        
        
        //cell.boardGameName?.text = test2["gameTitle"] as? String
        
        
        let oneTwo = setUpView()
        
            cell.boardGameName?.text = oneTwo[indexPath.row]
        
        //cell.addGestureRecognizer(longPressRecognizer)
        
        
        return cell
        
    }
    
 
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        enum gameRide{
            case Splendor
            case Monopoly
            case Chess
            case Settlers
        }
        let row = indexPath.row
        let arr = setUpView()
        let stringy = arr[row]
        
        chosenSessions = stringy
        
       if (stringy == "Splendor")
       {
          performSegueWithIdentifier("joinGameSegue", sender: self)        }
        
        else if (stringy == "Monopoly")
        {
        performSegueWithIdentifier("joinGameSegue", sender: self)
        }
        else if (stringy == "Chess")
        {
            performSegueWithIdentifier("joinGameSegue", sender: self)
        }
        else if (stringy == "Settlers of Catan")
        {
            performSegueWithIdentifier("joinGameSegue", sender: self)
        }
        else if (stringy == "Werewolf")
        {
        
            performSegueWithIdentifier("joinGameSegue", sender: self)
        }
        else if (stringy == "Checkers")
        {
            
            performSegueWithIdentifier("joinGameSegue", sender: self)
        }
        else if (stringy == "Caverna: The Cave Farmers")
        {
           
            performSegueWithIdentifier("joinGameSegue", sender: self)
        }
        
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if(segue.identifier == "joinGameSegue") {
            
            var vc = segue.destinationViewController as! AnotherViewController
            
            if (chosenSessions == "Monopoly")
            {
                vc.passedArray = monopolyArray
                vc.usersLocation = usersLocation
            }
            else if (chosenSessions == "Chess")
            {
                vc.passedArray = chessArray
                vc.usersLocation = usersLocation
            }
            else if (chosenSessions == "Checkers")
            {
                vc.passedArray = checkersArray
                vc.usersLocation = usersLocation
            }
            else if (chosenSessions == "Splendor")
            {
                vc.passedArray = splendorArray
                vc.usersLocation = usersLocation
            }
            else if (chosenSessions == "Werewolf")
            {
                vc.passedArray = werewolfArray
                vc.usersLocation = usersLocation
            }
            else if (chosenSessions == "Caverna: The Cave Farmers")
            {
                vc.passedArray = cavernaArray
                vc.usersLocation = usersLocation
            }
          
            
           
        }
    }
    
  
   
 
    /*
    func chooseAnArray(arrayName: String) -> [PFObject]
    {
        if arrayName == "Chess"
        {
            return chessArray
        }
        else if arrayName == "Monopoly"
        {
            return monopolyArray
        }
        else if arrayName == "Checkers"
        {
            return checkersArray
        }
        
    
    
    }*/
    
    
    func setUpView()-> [String]
    {
        var existss = [String]()
        if (countGames(chessArray) == true)
        {
            existss.append("Chess")
        }
        if (countGames(monopolyArray) == true)
        {
            existss.append("Monopoly")
        }
        if (countGames(splendorArray) == true)
        {
            existss.append("Splendor")
        }
        if (countGames(werewolfArray) == true)
        {
            existss.append("Werewolf")
        }
        if (countGames(settlersArray) == true)
        {
            existss.append("Settlers of Catan")
        }
        if (countGames(checkersArray) == true)
        {
            existss.append("Checkers")
        }
        if (countGames(cavernaArray) == true)
        {
            existss.append("Caverna: The Cave Farmers")
        }
        
        return existss
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.splendorArray = [PFObject]()
        self.chessArray = [PFObject]()
        self.monopolyArray = [PFObject]()
        self.settlersArray = [PFObject]()
        self.werewolfArray = [PFObject]()
        self.checkersArray = [PFObject]()
        self.cavernaArray = [PFObject]()
        self.chosenSessions = String()
        queryData()
        tableView.reloadData()
        print("view was loaded & reloaded")
        
        var currLocation = locationManager.location
        usersLocation = PFGeoPoint(location:currLocation)
        
    }
    
    
   
    
    
}
