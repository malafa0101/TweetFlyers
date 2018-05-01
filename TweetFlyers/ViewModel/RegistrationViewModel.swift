//
//  RegistrationViewModel.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import Foundation

class RegistrationViewModel {
    
    var email: String?
    var password: String?
    var name: String?
    var surname: String?
    var birthDay: Date?
    
    public func getUser() -> User {
        return User(email: email, name: name, surname: surname, birthDay: birthDay, tweetIDs: nil, imageURL: nil)
    }
}
