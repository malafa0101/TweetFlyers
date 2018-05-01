//
//  SignInViewController.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    //Outlets
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var signInButton: UIGradientButton!
    
    @IBOutlet weak var emailTextField: UIBindingTextField! {
        didSet {
            self.emailTextField.bind { self.signInViewModel.email = $0 }
        }
    }
    
    @IBOutlet weak var passwordTextField: UIBindingTextField! {
        didSet {
            self.passwordTextField.bind { self.signInViewModel.password = $0 }
        }
    }
    
    @IBOutlet weak var signInButtonActivityIndicator: UIBindingActivityIndicatorView! {
        didSet {
            self.signInButtonActivityIndicator.bind(button: self.signInButton)
        }
    }
    
    
    //Variables
    
    private var auth: FBAuth!
    
    private var database: FBDatabase!
    
    private var signInViewModel: SignInViewModel!
    
    //Functions
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        auth = FBAuth()
        database = FBDatabase()
        signInViewModel = SignInViewModel()
        
        initKeyboardActions()
    }
    
    private func makeWrongMessage () {
        
        self.emailTextField.startAnimation()
        self.passwordTextField.startAnimation()
    }
    
    //Actions
    
    @IBAction func signInClicked (_ sender: UIGradientButton) {
        
        self.signInButtonActivityIndicator.startAnimating()
        
        auth.signIn(signInViewModel: signInViewModel) { (success) in
            
            self.signInButtonActivityIndicator.stopAnimating()
            
            if (success) {
                self.database.getUser(email: self.signInViewModel.email!) { (user) in
                    currentUser = user!
                    self.performSegue(withIdentifier: "SIGNINP_USERP", sender: self)
                }
            } else {
                self.makeWrongMessage()
            }
            
        }
    }
    
    @IBAction func tapGesture (_ sender: UITapGestureRecognizer) {
        
        emailTextField.endEditing(false)
        passwordTextField.endEditing(false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}


extension SignInViewController {
    
    private func initKeyboardActions() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow (sender: NSNotification) {
        
        guard self.mainStackView.spacing != 15 else { return }
        
        UIView.animate(withDuration: 0.5) {
            self.mainStackView.spacing = 15
        }
    }
    
    @objc func keyboardWillHide (sender: NSNotification) {
        
        guard self.mainStackView.spacing != 30 else { return }
        
        UIView.animate(withDuration: 0.5) {
            self.mainStackView.spacing = 30
        }
    }
    
}

