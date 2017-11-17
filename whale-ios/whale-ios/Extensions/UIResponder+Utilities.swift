//
//  UIResponder+Utilities.swift
//  humanup
//
//  Created by Chase Wang on 9/26/16.
//  Copyright © 2016 Human Up. All rights reserved.
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
    
    class func hu_nibNamed(nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: Bundle.main)
    }
    
    class func hu_nib() -> UINib {
        return hu_nibNamed(nibName: self.toString())
    }
    
    class func hu_instantiateWithNibNamed<T>(nibName: String, withType type: T.Type) -> T {
        let nib = hu_nibNamed(nibName: nibName)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        
        guard let object = objects.first else {
            fatalError("Error: couldn't create nib named \(nibName)")
        }
        
        return object as! T
    }
    
    // REVIEW: Better way to do this? Look more into generics
    
    class func hu_instantiateFromNib<T>(withType type: T.Type) -> T {
        return hu_instantiateWithNibNamed(nibName: self.toString(), withType: T.self)
    }
}
