//
//  GameOnSession.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/11/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import Foundation
import Parse

class GameOnSession: PFObject, PFSubclassing{
    
    
    static func parseClassName() -> String {
        return "GameOnSession"
    }
    
    var gameTitle: String? {
        get{
            return self["gameTitle"] as? String
            
        }
        set {
            self["gameTitle"] = newValue
        }
    }
}
