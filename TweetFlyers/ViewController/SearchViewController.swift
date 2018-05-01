//
//  SearchViewController.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    //Outlets
    
    @IBOutlet weak var seachBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    
    private var database: FBDatabase!
    
    private var tweets: [Tweet]!
    
    //Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database = FBDatabase()
        tweets = []
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        loadData()
    }
    
    private func loadData () {
        tweets = []
        tableView.reloadData()
        
        self.database.getHashtags(name: self.seachBar.text!.lowercased(), similar: true) { (hashtag) in
            
            for id in hashtag.tweetIDs ?? [] {
                
                self.database.getTweet(id: id) { (tweet) in
                    
                    guard tweet != nil else { return }
                    self.tweets.append(tweet!)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        loadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serchTableViewCell", for: indexPath) as! TweetTableViewCell
        
        let tweet = tweets[indexPath.row]
        cell.loadData(fromTweet: tweet, database: database)
        
        return cell
    }
    
}

