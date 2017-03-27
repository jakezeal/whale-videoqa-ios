//
//  User.swift
//  whale-ios
//
//  Created by Jake on 3/27/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    
    static var current: User?
    
    // MARK: - Class Methods
    
    class func set(currentUser: User) {
        // Set current user
        current = currentUser
    }
    
    // MARK: - Instance Vars
    
    var userID: Int
    
    var email: String
    
    var username: String
    
//    var profilePictureURL: URL?
    
    var firstName: String
    
    var lastName: String
    
    // MARK: - Init
    init(userID: Int, email: String, username: String, profilePictureURL: URL? = nil, firstName: String = "", lastName: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.userID = userID
        self.email = email
        self.username = username
        
        // profile picture url doesn't always exist
//        self.profilePictureURL = profilePictureURL
        
        super.init()
    }
    
    init(json: JSON) {
        self.userID = json["id"].intValue
        self.email = json["email"].stringValue
        self.username = json["username"].stringValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        
        // profile picture url doesn't always exist
//        let imageURLString = json["profile_picture_url"].stringValue
//        if !imageURLString.isEmpty {
//            self.profilePictureURL = URL(string: imageURLString)
//        }
        
        super.init()
    }
}

