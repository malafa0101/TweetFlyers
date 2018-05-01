//
//  TweetsViewController.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    
    //Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //Variables
    
    private var tweets: [Tweet]!
    
    private var database: FBDatabase!
    
    //Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweets = []
        database = FBDatabase()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        loadTweets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadTweets()
    }
    
    private func loadTweets () {
        
        tweets = []
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.database.getTweets { (tweet) in
                
                self.tweets.append(tweet)
                self.tableView.reloadData()
            }
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetsCellIdentifier", for: indexPath) as! TweetTableViewCell
        
        let tweet = tweets[indexPath.row]
        cell.loadData (fromTweet: tweet, database: database)
        
        return cell
    }
    
    
    
    
}

