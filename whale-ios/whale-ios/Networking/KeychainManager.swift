//
//  KeychainManager.swift
//  whale-ios
//
//  Created by Jake on 3/29/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import Foundation

final class KeychainManager {
    static func checkForAuthToken() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: Constants.UserDefaults.isAuthTokenSet)
    }
    
    static func set(authToken: String) {
        let keychainWrapper = KeychainWrapper()
        keychainWrapper.mySetObject(authToken, forKey: "auth_token")
        keychainWrapper.writeToKeychain()
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Constants.UserDefaults.isAuthTokenSet)
    }
}
