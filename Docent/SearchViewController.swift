//
//  SearchViewController.swift
//  Docent
//
//  Created by Aree Oh on 2016. 12. 6..
//  Copyright © 2016년 Aree Oh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    private var filteredResult = [Piece]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showPieceDetail" {
            let detailVC = segue.destination as! PieceDetailViewController
            detailVC.setPiece(piece: filteredResult[(self.tableView.indexPathForSelectedRow?.row)!])
        }
    }
    
    
    // MARK: - Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!
        print("Query: \(query)")
        filteredResult.append(Piece(title: "자화상", author: "고흐", description: "설명이야 뿌잉뿌잉", reference: "http://wikipedia.co.kr/aria-bab"))
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResult.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data:Piece = filteredResult[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "pieceCell", for: indexPath) as! PieceTableViewCell
        cell.title.text = data.title
        cell.author.text = data.author
        
        return cell
    }
}
