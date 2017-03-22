//
//  UIColor+Utilities.swift
//  whale-ios
//
//  Created by Jake on 3/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

extension UIColor {
    // MARK: - Initializers
    /*
     * Converts hex integer into UIColor
     *
     * Usage: UIColor(hex: 0xFFFFFF)
     *
     */
    private convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    // MARK: - Brand Colors
    static var w_blue: UIColor {
        return UIColor(hex: 0x27c5ec)
    }

}
