//
//  WSignUpFlowEmailViewMode.swift
//  whale-ios
//
//  Created by Jake on 3/26/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HUSignUpFlowEmailViewModel: NSObject {
    
    // MARK: - Instance Vars
    
    var isValidEmailObservable: Observable<Bool>!
    
    // MARK: - Validation
    
    func validate(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
