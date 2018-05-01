//
//  Tweet.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class Tweet: Model, FirebaseModel {
    
    var authorEmail: String?
    var authorName: String?
    var sendDate: Date?
    var text: String?
    
    override init () { }
    
    init (authorEmail: String?, authorName: String?, sendDate: Date, text: String?) {
        
        self.authorEmail = authorEmail
        self.authorName = authorName
        self.sendDate = sendDate
        self.text = text
    }
    
    required init (dictionary: [String : AnyObject]) {
        super.init()
        
        loadData(dictionary: dictionary)
    }
    
    private func loadData (dictionary: [String : AnyObject]) {
        
        authorEmail = dictionary[TweetKeys.AUTHOR_EMAIL.rawValue] as? String
        authorName = dictionary[TweetKeys.AUTHOR_NAME.rawValue] as? String
        sendDate = Model.toDate(string: (dictionary[TweetKeys.SEND_DATE.rawValue] as? String)!)
        text = dictionary[TweetKeys.TEXT.rawValue] as? String
    }
    
    public func getValues () -> [String : AnyObject] {
        
        let data: [String : AnyObject] = [
            TweetKeys.AUTHOR_EMAIL.rawValue : authorEmail as AnyObject,
            TweetKeys.AUTHOR_NAME.rawValue : authorName as AnyObject,
            TweetKeys.SEND_DATE.rawValue : Model.toString(date: sendDate!) as AnyObject,
            TweetKeys.TEXT.rawValue: text as AnyObject
        ]
        return data
    }
    
    private enum TweetKeys: String {
        case AUTHOR_EMAIL = "AUTHOR_EMAIL"
        case AUTHOR_NAME = "AUTHOR_NAME"
        case SEND_DATE = "SEND_DATE"
        case TEXT = "TEXT"
    }
}

