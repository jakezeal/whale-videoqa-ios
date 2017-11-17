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

