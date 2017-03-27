//
//  WSignUpFlowPasswordViewModel.swift
//  whale-ios
//
//  Created by Jake on 3/26/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WSignUpFlowPasswordViewModel: NSObject {
    
    // MARK: - Instance Vars
    
    let email: String
    
    var isValidPasswordObservable: Observable<Bool>!
    
    // MARK: - Init
    
    init(email: String) {
        self.email = email
        super.init()
    }
    
    func validate(password: String) -> Bool {
        return password.characters.count > 6
    }
}
