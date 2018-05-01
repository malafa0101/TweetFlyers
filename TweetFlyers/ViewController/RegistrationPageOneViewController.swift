//
//  RegistrationPageOneViewController.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import UIKit

class RegistrationPageOneViewController: UIViewController {

   
    //Outlets
    
    @IBOutlet weak var nextButton: UIGradientButton!
    
    @IBOutlet weak var emailTextField: UIBindingTextField! {
        didSet {
            self.emailTextField.bind { self.registrationViewModel.email = $0 }
        }
    }
    
    @IBOutlet weak var nextButtonActivityIndicator: UIBindingActivityIndicatorView! {
        didSet {
            self.nextButtonActivityIndicator.bind(button: self.nextButton)
        }
    }
    
    //Variables
    
    private var database: FBDatabase!
    
    private var registrationViewModel: RegistrationViewModel!
    
    //Functions
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        database = FBDatabase()
        registrationViewModel = RegistrationViewModel()
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? RegistrationPageTwoViewController else { return }
        
        destination.registrationViewModel = self.registrationViewModel
    }
    
    private func makeWrongMessage () {
        
        emailTextField.startAnimation()
    }
    
    //Actions
    
    @IBAction func nextButtonClicked (_ sender: UIGradientButton) {
        
        guard let email = registrationViewModel.email else { return }
        
        nextButtonActivityIndicator.startAnimating()
        
        database.isExist(email: email) { (isExist) in
            
            self.nextButtonActivityIndicator.stopAnimating()
            
            if isExist {
                self.makeWrongMessage()
            } else {
                self.performSegue(withIdentifier: "REGPONE_REGPTWO", sender: self)
            }
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapGesture (_ sender: UITapGestureRecognizer) {
        
        emailTextField.endEditing(false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
}

