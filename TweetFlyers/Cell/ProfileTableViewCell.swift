//
//  ProfileTableViewCell.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameAndSurnameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIProfileImageView!
    
    public func loadData (user: User, database: FBDatabase) {
        
        nameAndSurnameLabel.text = "\(user.name!) \(user.surname!)"
        emailLabel.text = user.email
        
        if let url = user.imageURL {
            database.getImage(url: url) { (image) in
                self.profileImageView.image = image
            }
        }
    }
}

