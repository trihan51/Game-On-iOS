//
//  HostGameViewController.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/3/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit
import Parse

class HostGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gameNames = [String]()
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = "Host view screen"
        queryData()
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

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gameNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! CustomJoinCell
        
        cell.boardGameName2?.text = gameNames[indexPath.row]
        
        return cell
        
    }
    
}