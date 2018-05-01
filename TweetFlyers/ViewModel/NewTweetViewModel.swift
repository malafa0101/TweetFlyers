//
//  NewTweetViewModel.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import Foundation

class NewTweetViewModel {
    
    var text: String?
    var sendDate: Date?
    
    init () { }
    
    init (text: String, sendDate: Date) {
        
        self.text = text
        self.sendDate = sendDate
    }
    
}
