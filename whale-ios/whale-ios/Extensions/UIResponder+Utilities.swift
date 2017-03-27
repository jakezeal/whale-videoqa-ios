//
//  UIResponder+Utilities.swift
//  whale-ios
//
//  Created by Jake on 3/26/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

extension UIResponder {
    class func toString() -> String {
        let name = NSStringFromClass(self)
        let components = name.components(separatedBy: ".")
        
        guard let classString = components.last
            else { fatalError("Error: couldn't convert class name to string.") }
        
        return classString
    }
    
    class func w_nibNamed(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: Bundle.main)
    }
    
    class func w_nib() -> UINib {
        return w_nibNamed(nibName: self.toString())
    }
    
    class func w_instantiateWithNibNamed<T>(nibName: String, withType type: T.Type) -> T {
        let nib = w_nibNamed(nibName: nibName)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        
        guard let object = objects.first else {
            fatalError("Error: couldn't create nib named \(nibName)")
        }
        
        return object as! T
    }
    
    // REVIEW: Better way to do this? Look more into generics
    
    class func w_instantiateFromNib<T>(withType type: T.Type) -> T {
        return w_instantiateWithNibNamed(nibName: self.toString(), withType: T.self)
    }
}
