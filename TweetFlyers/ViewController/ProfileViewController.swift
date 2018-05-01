//
//  ProfileViewController.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    //Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //Valriables
    
    private var tweets: [Tweet]!
    
    private var database: FBDatabase!
    
    //Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweets = []
        database = FBDatabase()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        
        reloadTweets()
    }
    
    //Funcitons
    
    private func reloadTweets () {
        DispatchQueue.main.async(execute: { () -> Void in
            self.database.getTweets { (tweet) in
                if tweet.authorEmail == currentUser.email {
                    self.tweets.append(tweet)
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func profileImageTap(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            database.saveImage(image: selectedImage) { (key) in
                self.database.saveUser(newUser: User(email: currentUser.email, name: nil, surname: nil, birthDay: nil, tweetIDs: nil, imageURL: key), compilation: nil)
                currentUser.imageURL = key
                self.tableView.reloadData()
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 125
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            
            cell.loadData (user: currentUser, database: database)
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "tweetsCellIdentifier", for: indexPath) as! TweetTableViewCell
            
            let tweet = tweets[indexPath.row-1]
            cell.loadData(fromTweet: tweet, database: database)
            
            return cell
        }
        
    }
    
}

