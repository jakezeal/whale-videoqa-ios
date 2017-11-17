//
//  WCreateUsernameViewModel.swift
//  whale-ios
//
//  Created by Jake on 3/26/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol WCreateUsernameViewModelDelegate: class {
    func didCreate(newUser: User)
    func failedToCreateUser(withUsername username: String)
}

class WCreateUsernameViewModel: NSObject {
    
    // MARK: - Instance Vars
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    
    
    weak var delegate: WCreateUsernameViewModelDelegate?
    
    var isValidUsernameObservable: Observable<Bool>!
    
    // MARK: - Init
//    init(SMAccount: SocialMediaAccount) {
//        self.smAccount = SMAccount
//        super.init()
//    }
    
    init(email: String, password: String, firstName: String, lastName: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        super.init()
    }
    
    func validate(username: String) -> Bool {
        return username.characters.count >= 3
    }
    
    // MARK: Create User
    
    func createNewUser(withusername username: String) {
        createUser(fromEmail: email,
                   password: password,
                   username: username,
                   firstName: firstName,
                   lastName: lastName)
        
    }
    
    // MARK: Email
    
    func createUser(fromEmail email: String, password: String, username: String, firstName: String, lastName: String) {
        let userAttrs = ["username" : username,
                         "password" : password,
                         "email" : email,
                         "first_name" : firstName,
                         "last_name" : lastName]
        
        UserService.create(withUserAttributes: userAttrs) { (user: User?) in
            if let user = user {
                self.delegate?.didCreate(newUser: user)
            } else {
                // TODO: Handle failure graceful
                //                precondition(false, "Error: couldn't create new user")
                self.delegate?.failedToCreateUser(withUsername: username)
            }

        }
    }
}
