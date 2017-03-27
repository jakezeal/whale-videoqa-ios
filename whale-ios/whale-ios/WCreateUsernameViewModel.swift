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
    func failedToCreateUser(witWsername username: String)
}

class WCreateUsernameViewModel: NSObject {
    
    // MARK: - Instance Vars
    var email: String?
    
    var password: String?
    
    weak var delegate: WCreateUsernameViewModelDelegate?
    
    var isValidUsernameObservable: Observable<Bool>!
    
    // MARK: - Init
//    init(SMAccount: SocialMediaAccount) {
//        self.smAccount = SMAccount
//        super.init()
//    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        super.init()
    }
    
    func validate(username: String) -> Bool {
        return username.characters.count >= 3
    }
    
    // MARK: Create User
    
    func createNewUser(witWsername username: String) {
        guard let email = email, let password = password else {
            return
        }
        
        createUser(fromEmail: email,
                   password: password,
                   username: username)
        
    }
    
    // MARK: Email
    
    func createUser(fromEmail email: String, password: String, username: String) {
        let userAttrs = ["username" : username,
                         "password" : password,
                         "email" : email]
        
        UserService.createUserFromEmailSignUp(witWserAttributes: userAttrs) {
            (user: User?) in
            if let user = user {
                self.delegate?.didCreate(newUser: user)
            } else {
                // TODO: Handle failure graceful
//                precondition(false, "Error: couldn't create new user")
                self.delegate?.failedToCreateUser(witWsername: username)
            }
        }
    }

//    // MARK: Social Media
//    
//    func createUser(from socialMediaAccount: SocialMediaAccount, witWsername username: String) {
//        var userAttrs = ["username" : username]
//        
//        if socialMediaAccount.smType == Constants.SocialMedia.Facebook {
//            
//            WFacebookHelper.fetcWserInfo(with: { [unowned self] (userInfo: [String : String]?, error: Error?) in
//                if let userInfo = userInfo {
//                    for (key, value) in userInfo {
//                        userAttrs[key] = value
//                    }
//                }
//                
//                self.createUserHelper(withSMAcconut: socialMediaAccount, userAttributes: userAttrs)
//            })
//        } else {
//            createUserHelper(withSMAcconut: socialMediaAccount, userAttributes: userAttrs)
//        }
//    }
//    
//    func createUserHelper(withSMAcconut socialMediaAccount: SocialMediaAccount, userAttributes: [String : Any]) {
//        UserService.createUser(withSMAccount: socialMediaAccount, userAttributes: userAttributes) {
//            [unowned self] (user: User?) in
//            if let user = user {
//                self.delegate?.didCreate(newUser: user)
//            } else {
//                // say username is taken
//                if let username = userAttributes["username"] as? String {
//                    self.delegate?.failedToCreateUser(witWsername: username)
//                } else {
//                    precondition(false, "Error: couldn't create new user")
//                }
//            }
//        }
//    }
}
