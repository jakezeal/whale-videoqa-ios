//
//  WSignUpFlowPasswordInputCell.swift
//  whale-ios
//
//  Created by Jake on 3/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

class WSignUpFlowPasswordInputCell: UITableViewCell {

    // MARK: - Class Vars
    
    static let estimatedHeight: CGFloat = WSignUpFlowPasswordInputCell.height
    
    static let height: CGFloat = 89
    
    static let identifier = WSignUpFlowPasswordInputCell.toString()
    
    // MARK: - Instance Vars
    
    override var canBecomeFirstResponder: Bool {
        return passwordTextField.canBecomeFirstResponder
    }
    
    var hidePasswordVisibility = true
    
    // MARK: - Subviews
    
    @IBOutlet weak var passwordInputBottomBorder: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var togglePasswordVisibilityButton: UIButton!
    
    @IBOutlet weak var passwordTitleLabel: UILabel!
    
    // MARK: - Methods
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        return passwordTextField.becomeFirstResponder()
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        return passwordTextField.resignFirstResponder()
    }
    
    // REVIEW: This logic probably shouldn't be in the view
    @IBAction func togglePasswordVisibilityButtonTapped(_ sender: UIButton) {
        hidePasswordVisibility = !hidePasswordVisibility
        passwordTextField.isSecureTextEntry = hidePasswordVisibility
        
        let buttonTitle = hidePasswordVisibility ? "SHOW" : "HIDE"
        let attributes = [NSForegroundColorAttributeName : UIColor.w_blue,
                          NSFontAttributeName : UIFont(name: "OpenSans-Bold", size: 13)!,
                          NSKernAttributeName : NSNumber(value: 1)]
        
        let attrStr = NSAttributedString(string: buttonTitle, attributes: attributes)
        
        // Remove UIButton animation from changing title
        // http://stackoverflow.com/q/18946490/4230779
        UIView.performWithoutAnimation { [unowned self] in
            self.togglePasswordVisibilityButton.setAttributedTitle(attrStr, for: .normal)
            self.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var togglePasswordVisibilityButtonTapped: UITextField!
    
    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        passwordTextField.text = ""
        selectionStyle = .none
        passwordTextField.isSecureTextEntry = hidePasswordVisibility
    }
}
