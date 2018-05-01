//
//  Hashtag.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import Foundation

class Hashtag {
    
    var id: String?
    var tweetIDs: [String]?
    
    init () {
        
        tweetIDs = []
    }
    
    init (id: String?, tweetIDs: [String]?) {
        self.id = id
        self.tweetIDs = tweetIDs
    }
    
    init (dictionary: [String : AnyObject]) {
        
    }
    
    public func getValues () -> [String : AnyObject] {
        return [:]
    }
    
}
