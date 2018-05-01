//
//  FBDatabase.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit
import Foundation
import FirebaseStorage


class FBDatabase {
    
    //Variables
    
    //Tweet functions
    
    public func getTweet (id: String, compilation: ((Tweet?) -> Void)?) {
        
        Refs.databaseTweets.child(id).observe(.value) { (snapshot) in
            DispatchQueue.main.async { () -> Void in
                guard let dictionary = snapshot.value as? [String : AnyObject] else { compilation?(nil); return }
                
                let tweet = Tweet(dictionary: dictionary)
                compilation?(tweet)
            }
        }
    }
    
    public func saveTweet (email: String, newTweetViewModel viewModel: NewTweetViewModel, compilation: ((String) -> Void)?) {
        
        let nameAndSurname = "\(currentUser.name!) \(currentUser.surname!)"
        
        let tweet = Tweet(authorEmail: email, authorName: nameAndSurname, sendDate: Date(), text: viewModel.text)
        
        Refs.databaseTweets.childByAutoId().setValue(tweet.getValues()) { (err, ref) in
            DispatchQueue.main.async { () -> Void in
                
                guard err == nil else { compilation?("Error"); return }
                
                let refID = ref.key
                compilation?(refID)
            }
        }
    }
    
    public func getTweets (compilation: ((Tweet) -> Void)?) {
        
        Refs.databaseTweets.observe(.childAdded) { (snapshot) in
            DispatchQueue.main.async { () -> Void in
                
                guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
                
                let tweet = Tweet(dictionary: dictionary)
                compilation?(tweet)
            }
        }
    }
    
    //User functions
    
    public func getUser (email: String, compilation: ((User?) -> Void)?) {
        
        let id = self.getHashValue(email: email)
        
        Refs.databaseUsers.child(id).observe(.value) { (snapshot) in
            DispatchQueue.main.async { () -> Void in
                
                guard let dictionary = snapshot.value as? [String : AnyObject] else { compilation?(nil); return }
                
                let user = User(dictionary: dictionary)
                compilation?(user)
            }
        }
    }
    
    public func saveUser (newUser user: User, compilation: ((String?) -> Void)?) {
        
        guard let email = user.email else { compilation?(nil); return }
        let id = self.getHashValue(email: email)
        
        Refs.databaseUsers.child(id).setValue(user.getValues()) { (err, ref) in
            DispatchQueue.main.async { () -> Void in
                
                guard err == nil else { compilation?(nil); return }
                
                let refID = ref.key
                compilation?(refID)
            }
        }
    }
    
    public func isExist (email: String, compilation: ((Bool) -> Void)?) {
        
        let id = self.getHashValue(email: email)
        
        Refs.databaseUsers.observeSingleEvent(of: .value) { (snapshot) in
            DispatchQueue.main.async { () -> Void in
                
                guard let dictionary = snapshot.value as? [String : AnyObject] else { compilation?(false); return }
                
                if dictionary[id] == nil { compilation?(false) }
                else { compilation?(true) }
            }
        }
    }
    
    //Hashtag functions
    
    public func getHashtag (name: String, compilation: ((Hashtag?) -> Void)?) {
        
        Refs.databaseHashTags.child(name).observe(.value) { (snapshot) in
            DispatchQueue.main.async { () -> Void in
                
                guard let dictionary = snapshot.value as? [String: String] else { compilation?(nil); return }
                
                let keys: [String] = dictionary.map({ (key, value) -> String in
                    return value
                })
                
                compilation? (Hashtag(id: name, tweetIDs: keys))
            }
        }
    }
    
    public func getHashtags (name: String, similar: Bool, compilation: ((Hashtag) -> Void)?) {
        
        Refs.databaseHashTags.observeSingleEvent(of: .value) { (root_snapshot) in
            DispatchQueue.main.async { () -> Void in
                
                if let root_dictionary = root_snapshot.value as? [String : AnyObject] {
                    
                    let hashtags = Array(root_dictionary.keys)
                    
                    for hashtag in hashtags {
                        
                        if !hashtag.contains(name) { continue }
                        
                        self.getHashtag(name: name, compilation: { (hashtag) in
                            if hashtag != nil {
                                compilation? (hashtag!)
                            }
                        })
                    }
                }
            }
        }
    }
    
    public func saveHashtag (newHashtag: Hashtag, compilation: (() -> Void)?) {
        
        guard let id = newHashtag.id, let tweetIDs = newHashtag.tweetIDs else { compilation?(); return }
        
        for tweetID in tweetIDs {
            Refs.databaseHashTags.child(id).childByAutoId().setValue(tweetID)
        }
    }
    
    //Other functions
    
    private func getHashValue (email: String) -> String {
        
        return "\(email.hashValue)"
    }
    
    //Image functions
    
    public func getImage (url: String, compilation: ((UIImage?) -> Void)?) {
        
        let iURL = URL(string: url)!
        URLSession.shared.dataTask(with: iURL, completionHandler: { (data, res, err) in
            
            guard err == nil else { compilation?(nil); return }
            
            DispatchQueue.main.async { () -> Void in
                compilation? (UIImage(data: data!))
            }
        })
    }
    
    public func saveImage (image: UIImage, compilation: ((String?) -> Void)?) {
        
        let imageName = NSUUID().uuidString
        let uploadData = UIImagePNGRepresentation(image)!
        
        Refs.storageProfileImage.child(imageName).putData(uploadData, metadata: nil) { (metadata, error) in
            
            guard error == nil, let url = metadata?.downloadURL()?.absoluteString else { compilation?(nil); return }
            
            compilation?(url)
        }
    }
    
}

