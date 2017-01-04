//
//  SearchViewController.swift
//  Docent
//
//  Created by Aree Oh on 2016. 12. 6..
//  Copyright © 2016년 Aree Oh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, MTTextToSpeechDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var loadingView: UIView!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    
    // -- MARK: Variables of configuration
    private let playIconName = "player_icon"
    private let pauseIconName = "pause_icon"
    private let searchAPI_URL = "http://104.199.198.37:8080/search/"
    private let speechConfig = [
        TextToSpeechConfigKeyApiKey: "bd5b4961a4a1cdcdcf85db418a23d248",
        TextToSpeechConfigKeyVoiceType: TextToSpeechVoiceTypeWoman
    ]
    
    
    // -- MARK: Variables managing state
    private var isPlaying = false
    private var buttonOfPlaying:UIButton?
    private var textToSpeechClient:MTTextToSpeechClient?
    private var filteredResult = [Piece]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        textToSpeechClient = MTTextToSpeechClient(config: speechConfig)
        textToSpeechClient?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        loadingIndicator.hidesWhenStopped = true
        loadingView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // -- MARK: Speech
    @IBAction func playButtonClicked(_ sender: UIButton) {
        let iconImageNameToBeChanged = isPlaying ? playIconName : pauseIconName
        sender.setImage(UIImage(named: iconImageNameToBeChanged), for: UIControlState.normal)
        
        if isPlaying {
            textToSpeechClient?.stop()
        }
        else {
            let desc = filteredResult[sender.tag].description
            textToSpeechClient?.play(desc)
            buttonOfPlaying = sender
        }
        isPlaying = !isPlaying
    }
    
    public func onError(_ errorCode: MTTextToSpeechError, message: String!) {
        NSLog("MTTextToSpeechError: (\(errorCode)) \(message)")
    }
    
    /**
     * 음성합성 동작이 종료되었을 때 호출된다.
     **/
    public func onFinished() {
        buttonOfPlaying?.setImage(UIImage(named: playIconName), for: UIControlState.normal)
        buttonOfPlaying = UIButton()
    }
    
    func startLoading() {
        tableView.isScrollEnabled = false
        loadingView.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        tableView.isScrollEnabled = true
        loadingIndicator.stopAnimating()
        loadingView.isHidden = true
    }
    
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPieceDetail" {
            let detailVC = segue.destination as! PieceDetailViewController
            detailVC.setPiece(piece: filteredResult[(self.tableView.indexPathForSelectedRow?.row)!])
        }
    }
    
    
    // MARK: - Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!
        NSLog("Query: \(query)")
        
        filteredResult.removeAll()
        search(query: query)
        dismissKeyboard()
    }
    
    private func search(query: String) {
        let url = URL(string: "\(searchAPI_URL)\(query.encodeUrl())")!
        NSLog("URL: \(url)")

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { NSLog("Error: \(error)"); return }

            self.deserialize(data: data!)
            
            // URLSession works in background thread.
            // Never touch the interface except on main thread.
            DispatchQueue.main.async {
                self.stopLoading()
                self.tableView.reloadData()
            }
        }
        task.resume()
        startLoading()
    }
    
    private func deserialize(data:Data) {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            NSLog("Error: failed to deserialized (\(data))")
            return
        }
        
        let list = json as? [[String: Any]] ?? []
        for i in 0..<list.count {
            let pdata = list[i]
            let contents = pdata["contents"] as? NSArray
            let desc = (contents?[0] as! Dictionary<String, String>)["description"]!
            
            filteredResult.append(Piece(title: pdata["title"]! as! String, author: "author(test)", description: desc, reference: self.generateWikiURL(path: pdata["url"] as! String)))
        }
    }
    
    private func generateWikiURL(path: String) -> String {
        return "https://ko.wikipedia.org\(path)"
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
        cell.playButton.tag = indexPath.row
        
        return cell
    }
}

extension String {
    func encodeUrl() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}
