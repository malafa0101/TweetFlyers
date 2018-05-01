//
//  Refs.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import Firebase
import FirebaseStorage

struct Refs {
    
    static let databaseRoot = Database.database().reference()
    
    static let databaseTweets = databaseRoot.child(ReferenceChilds.TWEETS.rawValue)
    
    static let databaseUsers = databaseRoot.child(ReferenceChilds.USERS.rawValue)
    
    static let databaseHashTags = databaseRoot.child(ReferenceChilds.HASHTAGS.rawValue)
    
    static let storageRoot = Storage().reference()
    
    static let storageProfileImage = storageRoot.child(ReferenceChilds.PROFILE_IMAGE.rawValue)
}

enum ReferenceChilds: String {
    
    case TWEETS = "TWEETS"
    case USERS = "USERS"
    case HASHTAGS = "HASHTAGS"
    case PROFILE_IMAGE = "PROFILE_IMAGES"
}

