//
//  RegistrationPageTwoViewController.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class RegistrationPageTwoViewController: UIViewController {

   
    //Outlets
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var birthDayDatePicker: UIDatePicker!
    
    @IBOutlet weak var registrationButton: UIGradientButton!
    
    @IBOutlet weak var nameTextField: UIBindingTextField! {
        didSet {
            self.nameTextField.bind { self.registrationViewModel.name = $0 }
        }
    }
    
    @IBOutlet weak var surnameTextField: UIBindingTextField! {
        didSet {
            self.surnameTextField.bind { self.registrationViewModel.surname = $0 }
        }
    }
    
    @IBOutlet weak var passwordTextField: UIBindingTextField! {
        didSet {
            self.passwordTextField.bind { self.registrationViewModel.password = $0 }
        }
    }
    
    @IBOutlet weak var registrationButtonActivityIndicator: UIBindingActivityIndicatorView! {
        didSet {
            self.registrationButtonActivityIndicator.bind(button: self.registrationButton)
        }
    }
    
    //Variables
    
    private var auth: FBAuth!
    
    private var database: FBDatabase!
    
    var registrationViewModel: RegistrationViewModel!
    
    //Functions
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        auth = FBAuth()
        database = FBDatabase()
        
        initKeyboardActions()
    }
    
    private func backToSignInViewController () {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    private func makeWrongMessage () {
        
    }
    
    //Actions
    
    @IBAction func registrationButtonClicked (_ sender: UIGradientButton) {
        
        registrationButtonActivityIndicator.startAnimating()
        
        registrationViewModel.birthDay = birthDayDatePicker.date
        
        auth.registration(registrationViewModel: registrationViewModel) { (success) in
            
            self.registrationButtonActivityIndicator.stopAnimating()
            
            if success {
                self.backToSignInViewController()
            } else {
                self.makeWrongMessage()
            }
        }
    }
    
    @IBAction func signInButtonClicked (_ sender: UIButton) {
        
        self.backToSignInViewController()
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        nameTextField.endEditing(false)
        surnameTextField.endEditing(false)
        passwordTextField.endEditing(false)
    }
    
}

extension RegistrationPageTwoViewController {
    
    private func initKeyboardActions() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        
        guard self.mainStackView.spacing != 15 else { return }
        
        UIView.animate(withDuration: 0.5) {
            self.mainStackView.spacing = 10
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        
        guard self.mainStackView.spacing != 30 else { return }
        
        UIView.animate(withDuration: 0.5) {
            self.mainStackView.spacing = 15
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

