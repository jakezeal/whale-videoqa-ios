//
//  UserService.swift
//  whale-ios
//
//  Created by Jake on 3/27/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UserService {
    class func logIn(withEmail email: String, password: String, completion: @escaping (User?) -> Void) {
        
        WAPIManager.shared.request(route: UserRouter.logIn(email, password))
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success(let value):
//                    WAPIManager.checkForBearerToken(from: response.response)
                    
                    let json = JSON(value)
                    let user = User(json: json)
                    User.set(currentUser: user)
                    completion(user)
                    
                case .failure:
                    completion(nil)
                }
        }
    }
    
    class func createUserFromEmailSignUp(withUserAttributes attributes: [String : Any], completion: @escaping (User?) -> Void) {
        
        let signupData: [String : Any] = ["signup_type" : "email"]
        
        self.create(withUserAttributes: attributes, signupData: signupData, completion: completion)
    }
    
    class func create(withUserAttributes attributes: [String : Any], signupData: [String : Any], completion: @escaping (User?) -> Void) {
        WAPIManager.shared
            .request(route: UserRouter.create(attributes, signupData))
            .responseJSON { (response: DataResponse<Any>) in
                switch response.result {
                case .success(let value):
//                    WAPIManager.checkForBearerToken(from: response.response)
                    
                    let json = JSON(value)
                    let user = User(json: json)
                    User.set(currentUser: user)
                    completion(user)
                    
                case .failure:
                    completion(nil)
                }
        }
    }
}

