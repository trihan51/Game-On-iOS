//
//  CustomSessionCell.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/16/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit

class CustomSessionCell:UITableViewCell {
    
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var playerEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //configure the view for the selected state
    }
}
