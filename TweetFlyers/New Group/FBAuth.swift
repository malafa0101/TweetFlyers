//
//  FBAuth.swift
//  Flyers
//
//  Created by Жанибек on 01.05.18.
//  Copyright © 2018 Жанибек. All rights reserved.
//

import FirebaseAuth

class FBAuth {
    
    private var auth: Auth
    private var database: FBDatabase?
    
    init () {
        auth = Auth.auth()
        database = FBDatabase()
    }
    
    var AUTH: Auth {
        return auth
    }
    
    var UID: String? {
        return auth.currentUser?.uid
    }
    
    public func signIn (signInViewModel viewModel: SignInViewModel, compilation: @escaping (Bool) -> Void) {
        
        guard let email = viewModel.email, let password = viewModel.password else { compilation(false); return }
        
        auth.signIn(withEmail: email, password: password) { (usr, err) in
            
            guard err == nil else { compilation(false); return }
            
            compilation(true)
        }
    }
    
    public func signOut () -> Bool {
        do { try auth.signOut(); return true }
        catch { return false }
    }
    
    public func registration (registrationViewModel viewModel: RegistrationViewModel, compilation: @escaping (Bool) -> Void) {
        
        guard let email = viewModel.email, let password = viewModel.password else { compilation(false); return }
        
        auth.createUser(withEmail: email, password: password) { (usr, err) in
            
            guard err == nil else { compilation(false); return }
            
            let user = viewModel.getUser()
            self.database?.saveUser(newUser: user) { (result) in
                
                compilation(true)
            }
        }
    }
}

