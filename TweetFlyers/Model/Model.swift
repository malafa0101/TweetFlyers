//
//  Model.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import Foundation

protocol FirebaseModel {
    
    init (dictionary: [String : AnyObject])
    func getValues () -> [String : AnyObject]
}

class Model {
    
    static func toString (date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:MM"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    static func toDate (string: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:MM"
        let date = dateFormatter.date(from: string)
        return date!
    }
}

