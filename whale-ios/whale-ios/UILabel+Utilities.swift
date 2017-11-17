//
//  UILabel+Utilities.swift
//  humanup
//
//  Created by Chase Wang on 10/5/16.
//  Copyright © 2016 Human Up. All rights reserved.
//

import UIKit

extension UILabel {
    
    // MARK: - Class Methods
    
    func set(kerningValue: CGFloat) {
        let attributes: [String : Any] = [NSKernAttributeName : kerningValue,
                                          NSFontAttributeName : font,
                                          NSForegroundColorAttributeName: textColor]
        
        attributedText = NSAttributedString(string: text ?? "",
                                            attributes: attributes)
    }
}
