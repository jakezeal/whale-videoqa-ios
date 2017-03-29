//
//  UserRouter.swift
//  whale-ios
//
//  Created by Jake on 3/27/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import Foundation
import Alamofire

enum UserRouter: URLRequestConvertible {
    
    case logIn(String, String)
    case create([String : Any])
    case fetchCurrentUserQuestion
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .fetchCurrentUserQuestion:
                return .get
            case .logIn, .create:
                return .post
            }
        }
        
        let params: ([String : Any]?) = {
            switch self {
            case .logIn(let email, let password):
                return ["email" : email, "password" : password]
            case .create(let userDict):
                return ["attributes" : userDict]
            case .fetchCurrentUserQuestion:
                return nil
            }
        }()
        
        let relativePath: String = {
            switch self {
            case .logIn:
                return "/login"
            case .create:
                return "/users"
            case .fetchCurrentUserQuestion:
                guard let user = User.current else {
                    fatalError()
                }
                
                return "/users/\(user.userID)/goals"
            }
        }()
        
        let url: URL = {
            var url = URL(string: WAPIManager.baseURLString)!
            url.appendPathComponent(relativePath, isDirectory: false)
            
            return url
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        let encoding = JSONEncoding.default
        
        return try encoding.encode(urlRequest, with: params)
    }
}
