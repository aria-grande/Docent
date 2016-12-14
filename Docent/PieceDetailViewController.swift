//
//  PieceDetailViewController.swift
//  Docent
//
//  Created by Aree Oh on 2016. 12. 6..
//  Copyright © 2016년 Aree Oh. All rights reserved.
//

import UIKit

class PieceDetailViewController: UIViewController {

    @IBOutlet var pieceTitle: UILabel!
    
    @IBOutlet var author: UILabel!
    
    @IBOutlet var pieceDescription: UITextView!
    
    @IBOutlet var reference: UIButton!
    
    private var piece = Piece()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pieceTitle.text = self.piece.title
        self.author.text = self.piece.author
        self.pieceDescription.text = self.piece.description
        self.reference.setTitle(self.piece.reference, for: .normal)
    }

    func setPiece(piece:Piece) {
        self.piece = piece
    }

    @IBAction func clickedReference(_ sender: UIButton) {
        let url = URL(string: self.piece.reference)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
