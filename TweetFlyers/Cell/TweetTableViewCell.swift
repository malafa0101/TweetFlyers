//
//  TweetTableViewCell.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    //Outlets
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var sendDateLabel: UILabel!
    
    //Functions
    
    public func loadData (fromTweet tweet: Tweet, database: FBDatabase) {
        
        nameLabel.text = tweet.authorName ?? ""
        textView.text = tweet.text
        sendDateLabel.text = getDate(date: tweet.sendDate!)
        backgroundColor = UIColor.clear
        
        database.getUser(email: tweet.authorEmail!) { (user) in
            if let url = user?.imageURL {
                database.getImage(url: url, compilation: { (image) in
                    self.userImage.image = image
                })
            }
        }
    }
    
    private func getDate (date: Date) -> String {
        _ = Date().compare(date)
        
        return ""
    }
    
    
}

