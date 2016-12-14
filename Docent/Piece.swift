//
//  Piece.swift
//  Docent
//
//  Created by Aree Oh on 2016. 12. 6..
//  Copyright © 2016년 Aree Oh. All rights reserved.
//

import Foundation

class Piece {
    var title:String = ""
    var author:String = ""
    var description:String = ""
    var reference:String = ""
    
    convenience init(title:String, author:String, description:String, reference:String) {
        self.init()
        self.title = title
        self.author = author
        self.description = description
        self.reference = reference
    }
}
