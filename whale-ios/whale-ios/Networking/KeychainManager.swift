//
//  KeychainManager.swift
//  whale-ios
//
//  Created by Jake on 3/29/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import Foundation
import KeychainSwift

final class KeychainManager {
    static func checkForAuthToken() {
        let keychain = KeychainSwift(keyPrefix: <#T##String#>)
        set(bearerToken: bearerToken)
    }
}
