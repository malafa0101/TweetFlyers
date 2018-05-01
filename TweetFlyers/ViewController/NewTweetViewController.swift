//
//  NewTweetViewController.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
    //Variables
    private var auth: FBAuth!
    
    private var newTweetViewModel: NewTweetViewModel!
    
    private var database: FBDatabase!
    
    private var hashtags: [Hashtag] = []
    
    //Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTweetViewModel = NewTweetViewModel()
        database = FBDatabase()
        auth = FBAuth()
    }
    
    //Actions
    
    @IBAction func saveButtonItemClicked(_ sender: UIBarButtonItem) {
        
        newTweetViewModel.text = textView.text
        newTweetViewModel.sendDate = Date()
        
        database.saveTweet(email: (auth.AUTH.currentUser?.email)!, newTweetViewModel: newTweetViewModel) { (key) in
            if self.hashtags.isEmpty { self.dismiss(animated: true, completion: nil) }
            for i in 0..<self.hashtags.count {
                let hashtag = self.hashtags[i]
                hashtag.tweetIDs?.append(key)
                if i == self.hashtags.count-1 {
                    self.database.saveHashtag(newHashtag: hashtag) {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.database.saveHashtag(newHashtag: hashtag, compilation: nil)
                }
            }
        }
        
    }
    
    @IBAction func stopButtonItemClicked(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewTweetViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        hashtags = self.textView.resolveHashTags()
    }
}


extension UITextView {
    
    func resolveHashTags() -> [Hashtag]{
        
        // turn string in to NSString
        let nsText = NSString(string: self.text)
        
        let words = nsText.components(separatedBy: CharacterSet(charactersIn: "#ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_").inverted)
        
        
        // you can staple URLs onto attributed strings
        let attrString = NSMutableAttributedString()
        attrString.setAttributedString(self.attributedText)
        
        var hashTags = [Hashtag]()
        
        // tag each word if it has a hashtag
        for i in 0..<words.count {
            
            let word = words[i]
            let matchRange = nsText.range(of: word)
            
            if word.count < 3 {
                attrString.addAttribute(.foregroundColor, value: UIColor.white, range: matchRange)
                continue
            }
            // found a word that is prepended by a hashtag!
            // homework for you: implement @mentions here too.
            if word.hasPrefix("#") {
                
                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                // drop the hashtag
                let stringifiedWord = word.dropFirst()
                if let firstChar = stringifiedWord.unicodeScalars.first, NSCharacterSet.decimalDigits.contains(firstChar) {
                    attrString.addAttribute(.foregroundColor, value: UIColor.white, range: matchRange)
                    // hashtag contains a number, like "#1"
                    // so don't make it clickable
                } else {
                    // set a link for when the user clicks on this word.
                    // it's not enough to use the word "hash", but you need the url scheme syntax "hash://"
                    // note:  since it's a URL now, the color is set to the project's tint color
                    hashTags.append(Hashtag(id: String(stringifiedWord), tweetIDs: []))
                    attrString.addAttribute(.foregroundColor, value: UIColor(red: 186/255, green: 135/255, blue: 43/255, alpha: 1), range: matchRange)
                }
                
            } else {
                attrString.addAttribute(.foregroundColor, value: UIColor.white, range: matchRange)
            }
        }
        
        // we're used to textView.text
        // but here we use textView.attributedText
        // again, this will also wipe out any fonts and colors from the storyboard,
        // so remember to re-add them in the attrs dictionary above
        self.attributedText = attrString
        return hashTags
    }
}

