//
//  User.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit
import Foundation

class User: Model, FirebaseModel {
    
    var email: String?
    var name: String?
    var surname: String?
    var birthDay: Date?
    var imageURL: String?
    var tweetIDs: [String]? = []
    
    override init () {  }
    
    init (email: String?, name: String?, surname: String?, birthDay: Date?, tweetIDs: [String]?, imageURL: String?) {
        
        self.imageURL = imageURL
        self.email = email
        self.name = name
        self.surname = surname
        self.birthDay = birthDay
        self.tweetIDs = tweetIDs
    }
    
    required init (dictionary: [String : AnyObject]) {
        super.init()
        
        loadData(dictionary: dictionary)
    }
    
    private func loadData (dictionary: [String : AnyObject]) {
        email = dictionary[UserKeys.EMAIL.rawValue] as? String
        name = dictionary[UserKeys.NAME.rawValue] as? String
        surname = dictionary[UserKeys.SURNAME.rawValue] as? String
        birthDay = Model.toDate(string: (dictionary[UserKeys.BIRTH_DAY.rawValue] as? String)!)
        tweetIDs = dictionary[UserKeys.TWEETS_IDS.rawValue] as? [String]
    }
    
    public func getValues () -> [String : AnyObject] {
        
        let data: [String : AnyObject] = [
            UserKeys.EMAIL.rawValue : email as AnyObject,
            UserKeys.NAME.rawValue : name as AnyObject,
            UserKeys.SURNAME.rawValue : surname as AnyObject,
            UserKeys.BIRTH_DAY.rawValue : Model.toString(date: birthDay!) as AnyObject,
            UserKeys.TWEETS_IDS.rawValue : tweetIDs as AnyObject
        ]
        return data
    }
    
    private enum UserKeys: String {
        
        case EMAIL = "EMAIL"
        case NAME = "NAME"
        case SURNAME = "SURNAME"
        case BIRTH_DAY = "BIRTH_DAY"
        case TWEETS_IDS = "TWEETS_IDS"
    }
}

