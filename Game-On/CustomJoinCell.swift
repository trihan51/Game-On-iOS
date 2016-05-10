//
//  CustomJoinCell.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/4/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit

class CustomJoinCell: MKTableViewCell {
    
    @IBOutlet weak var boardGameName: UILabel!
    
    @IBOutlet weak var boardGameName2: UILabel!
    
    @IBOutlet weak var gamePic: UIImageView!
    
    @IBOutlet weak var numParticipants: UILabel!
    
    @IBOutlet weak var boardGameName3: UILabel!
    
    @IBOutlet weak var specificSession: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
         gamePic?.contentMode = .ScaleAspectFill
       
        
        //initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //configure the view for the selected state
    }

}
