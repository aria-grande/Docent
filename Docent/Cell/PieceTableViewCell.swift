//
//  PieceTableViewCell.swift
//  Docent
//
//  Created by Aree Oh on 2016. 12. 6..
//  Copyright © 2016년 Aree Oh. All rights reserved.
//

import UIKit

class PieceTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    
    @IBOutlet var author: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }
    
    @IBAction func readDescription(_ sender: UIButton) {
        print("let's play!")
    }

}
