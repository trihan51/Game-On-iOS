//
//  CustomJoinCell.swift
//  Game-On
//
//  Created by Manbir Randhawa on 4/4/16.
//  Copyright © 2016 GameOn. All rights reserved.
//

import UIKit

class CustomJoinCell: UITableViewCell {
    
    @IBOutlet weak var boardGameName: UILabel!
    
    @IBOutlet weak var boardGameName2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //configure the view for the selected state
    }

}
