//
//  UIView+Utilities.swift
//  whale-ios
//
//  Created by Jake on 3/27/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

extension UIView {
    // Add multiple subviews
    func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addSubview(subview)
        }
        
        setNeedsUpdateConstraints()
    }
}
