//
//  UIBindingActivityIndicatorView.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class UIBindingActivityIndicatorView: UIActivityIndicatorView {

 
    private weak var button: UIButton? = nil
    private var currentTitle: String?
    
    func bind (button: UIButton) {
        self.button = button
        self.currentTitle = button.titleLabel?.text
    }
    
    override func stopAnimating() {
        super.stopAnimating()
        button?.isEnabled = true
        button?.setTitle(currentTitle, for: .normal)
    }
    
    override func startAnimating() {
        super.startAnimating()
        button?.isEnabled = false
        button?.setTitle("", for: .normal)
    }
    
}

