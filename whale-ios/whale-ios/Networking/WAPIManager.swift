//
//  WAPIManager.swift
//  whale-ios
//
//  Created by Jake on 3/27/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import Foundation
import Alamofire

final class WAPIManager {
    
    static let baseURLString = "https://whale2-elixir.herokuapp.com/api/v1"
    
    // MARK: - Singleton
    static let shared = WAPIManager()
    
    // MARK: - Class Methods
//    static func checkForBearerToken(from response: HTTPURLResponse?) {
//        guard let res = response,
//            let bearerToken = res.allHeaderFields[Constants.HeaderFields.authorization] as? String
//            else { return }
//        
//        set(bearerToken: bearerToken)
//    }
//    
//    static func set(bearerToken: String) {
//        let keychainWrapper = KeychainWrapper()
//        keychainWrapper.mySetObject(bearerToken, forKey: kSecValueData)
//        keychainWrapper.writeToKeychain()
//        
//        let defaults = UserDefaults.standard
//        defaults.set(true, forKey: Constants.UserDefaults.isBearerTokenSet)
//        
//        shared.setOrRefreshHeaderAdapter()
//    }
    
    // MARK: - Instance Vars
    private var sessionManager: SessionManager!
    
    // MARK: - Init
    private init() {
        sessionManager = Alamofire.SessionManager.default
        //        setOrRefreshHeaderAdapter()
    }
    
    // MARK: - Headers
    
//    private func setOrRefreshHeaderAdapter() {
//        sessionManager.adapter = WHeadersAdapter()
//    }
    
    func request(route: URLRequestConvertible) -> DataRequest {
        return sessionManager.request(route)
            .validate(statusCode: 200..<300)
    }
}

