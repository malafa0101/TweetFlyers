//
//  UIBindingTextField.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit
import AudioToolbox

class UIBindingTextField: UITextField {
    
    private var textChange: (String) -> Void = { _ in }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage()
    }
    
    public func bind (callback: @escaping (String) -> Void) {
        
        self.textChange = callback
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func tintClearImage() {
        for view in subviews {
            if view is UIButton {
                let button = view as! UIButton
                if button.image(for: .highlighted) != nil {
                    button.alpha = 0.5
                    button.setImage(#imageLiteral(resourceName: "clear_icon"), for: .normal)
                    button.setImage(#imageLiteral(resourceName: "clear_icon"), for: .highlighted)
                }
            }
        }
    }
    
    @objc private func textFieldDidChange (_ textField: UITextField) {
        
        self.textChange(textField.text ?? "")
    }
    
    
}

extension UITextField {
    
    public func startAnimation () {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
}




