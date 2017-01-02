//
//  SearchViewController.swift
//  Docent
//
//  Created by Aree Oh on 2016. 12. 6..
//  Copyright © 2016년 Aree Oh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, MTTextToSpeechDelegate {
    private var filteredResult = [Piece]()
    
    @IBOutlet var tableView: UITableView!
    
    // -- MARK: Variables of configuration
    private let playIconName = "player_icon"
    private let pauseIconName = "pause_icon"
    private let speechConfig = [
        TextToSpeechConfigKeyApiKey: "bd5b4961a4a1cdcdcf85db418a23d248",
        TextToSpeechConfigKeyVoiceType: TextToSpeechVoiceTypeWoman
    ]
    
    
    // -- MARK: Variables managing state
    private var isPlaying = false
    private var buttonOfPlaying:UIButton?
    private var textToSpeechClient:MTTextToSpeechClient?
    
    
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
    
    /**
     * 에러 상황 시 호출된다.
     *
     * @param errorCode MTTextToSpeechError errorCode
     * @param message 에러 메시지.
     **/
    public func onError(_ errorCode: MTTextToSpeechError, message: String!) {
        print("MTTextToSpeechError: (\(errorCode)) \(message)")
    }
    
    /**
     * 음성합성 동작이 종료되었을 때 호출된다.
     **/
    public func onFinished() {
        buttonOfPlaying?.setImage(UIImage(named: playIconName), for: UIControlState.normal)
        buttonOfPlaying = UIButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textToSpeechClient = MTTextToSpeechClient(config: speechConfig)
        textToSpeechClient?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // test
        filteredResult.append(Piece(title: "자화상", author: "고흐", description: "《별이 빛나는 밤》은 네덜란드의 화가 빈센트 반 고흐의 가장 널리 알려진 작품이다. 정신병을 앓고 있을 당시의 고흐가 그린 작품이다. 1889년 상 레미의 정신병원에서 그린 그림으로써, 당시 고흐는 정신장애로 인한 고통을 그림 속의 소용돌이로 묘사했다. 빈센트 반 고흐의 대표작 중 하나로 꼽히는 '별이 빛나는 밤'은 그가 고갱과 다툰 뒤 자신의 귀를 자른 사건 이후 생레미의 요양원에 있을 때 그린 것이다. 고흐에게 밤하늘은 무한함을 표현하는 대상이었고, 이보다 먼저 제작된 아를의 '밤의 카페 테라스'나 '론 강 위로 별이 빛나는 밤'에서도 별이 반짝이는 밤의 정경을 다루었다. 비연속적이고 동적인 터치로 그려진 하늘은 굽이치는 두꺼운 붓놀림으로 사이프러스와 연결되고, 그 아래의 마을은 대조적으로 고요하고 평온한 상태를 보여준다. 교회 첨탑은 그의 고향인 네덜란드를 연상시킨다. 그는 병실 밖으로 내다보이는 밤 풍경을 상상과 결합시켜 그렸는데, 이는 자연에 대한 반 고흐의 내적이고 주관적인 표현을 구현하고 있다. 수직으로 높이 뻗어 땅과 하늘을 연결하는 사이프러스는 전통적으로 무덤이나 애도와 연관된 나무이지만, 반 고흐는 죽음을 불길하게 보지 않았다.", reference: "http://wikipedia.co.kr/aria-bab"))
        self.tableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        print("Query: \(query)")
        filteredResult.append(Piece(title: "자화상", author: "고흐", description: "《별이 빛나는 밤》은 네덜란드의 화가 빈센트 반 고흐의 가장 널리 알려진 작품이다. 정신병을 앓고 있을 당시의 고흐가 그린 작품이다. 1889년 상 레미의 정신병원에서 그린 그림으로써, 당시 고흐는 정신장애로 인한 고통을 그림 속의 소용돌이로 묘사했다. 빈센트 반 고흐의 대표작 중 하나로 꼽히는 '별이 빛나는 밤'은 그가 고갱과 다툰 뒤 자신의 귀를 자른 사건 이후 생레미의 요양원에 있을 때 그린 것이다. 고흐에게 밤하늘은 무한함을 표현하는 대상이었고, 이보다 먼저 제작된 아를의 '밤의 카페 테라스'나 '론 강 위로 별이 빛나는 밤'에서도 별이 반짝이는 밤의 정경을 다루었다. 비연속적이고 동적인 터치로 그려진 하늘은 굽이치는 두꺼운 붓놀림으로 사이프러스와 연결되고, 그 아래의 마을은 대조적으로 고요하고 평온한 상태를 보여준다. 교회 첨탑은 그의 고향인 네덜란드를 연상시킨다. 그는 병실 밖으로 내다보이는 밤 풍경을 상상과 결합시켜 그렸는데, 이는 자연에 대한 반 고흐의 내적이고 주관적인 표현을 구현하고 있다. 수직으로 높이 뻗어 땅과 하늘을 연결하는 사이프러스는 전통적으로 무덤이나 애도와 연관된 나무이지만, 반 고흐는 죽음을 불길하게 보지 않았다.", reference: "http://wikipedia.co.kr/aria-bab"))
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
        cell.playButton.tag = indexPath.row
        
        return cell
    }
}
