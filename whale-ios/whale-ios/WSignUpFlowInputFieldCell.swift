//
//  WSignUpFlowInputFieldCell.swift
//  whale-ios
//
//  Created by Jake on 3/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

class WSignUpFlowInputFieldCell: UITableViewCell {
    
    // MARK: - Class Vars
    
    static let estimatedHeight: CGFloat = WSignUpFlowInputFieldCell.height
    
    static let height: CGFloat = 89
    
    static let identifier = WSignUpFlowInputFieldCell.toString()
    
    // MARK: - Instance Vars
    
    override var canBecomeFirstResponder: Bool {
        return inputTextField.canBecomeFirstResponder
    }

    // MARK: - Subviews
    
    @IBOutlet weak var inputTitleLabel: UILabel!

    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var inputFieldBottomBorder: UIView!
    
    // MARK: - Methods
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        return inputTextField.becomeFirstResponder()
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        return inputTextField.resignFirstResponder()
    }
    
    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputTextField.text = ""
        selectionStyle = .none
    }
}
