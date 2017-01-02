//
//  PieceTableViewCell2.swift
//  Docent
//
//  Created by Aree Oh on 2017. 1. 2..
//  Copyright © 2017년 Aree Oh. All rights reserved.
//

import UIKit

class PieceTableViewCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    
    @IBOutlet var author: UILabel!
    
    @IBOutlet var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
}
