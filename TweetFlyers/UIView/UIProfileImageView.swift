//
//  UIProfileImageView.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit


@IBDesignable
class UIProfileImageView: UIImageView {
    
    @IBInspectable var circle: Bool = false {
        didSet {
            f()
        }
    }
    
    private func f () {
        self.layer.masksToBounds = true
        if circle {
            self.layer.cornerRadius = self.bounds.size.width / 2
        } else {
            self.layer.cornerRadius = 0
        }
    }
}

