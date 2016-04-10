//
//  JoinGameViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/3/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse

class JoinGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gameNames = [String]()
    var test = ["manny", "sam", "bob"]
    
    
    @IBOutlet weak var testLabel: UILabel!
   
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        testLabel.text = "Join An Open Game Screen"
        queryData()
        
        
        
    }
    
    func queryData()
    {
        var query = PFQuery(className: "GameOnSession")
        query.whereKey("Open", equalTo: true)
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock{(games: [PFObject]?, error: NSError?) in
            
            if error == nil
            {
                if let games = games {
                    for game in games {
                        self.gameNames.append(game["gameTitle"] as! String)
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
               return gameNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomJoinCell
        
        cell.boardGameName?.text = gameNames[indexPath.row]
        
        return cell
        
    }
    
   
    
    
}
