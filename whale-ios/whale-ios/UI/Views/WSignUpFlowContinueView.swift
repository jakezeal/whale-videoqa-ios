//
//  WSignUpFlowContinueView.swift
//  whale-ios
//
//  Created by Jake on 3/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

protocol WSignUpFlowContinueViewDelegate: class {
    func didTap(continueButton: UIButton, on view: WSignUpFlowContinueView)
}

class WSignUpFlowContinueView: UIView {
    
    // MARK: - Class Vars
    
    static let height: CGFloat = 64
    
    // MARK: - Instance Vars
    
    weak var delegate: WSignUpFlowContinueViewDelegate?
    
    var didUpdateConstraints = false
    
    var isLoading = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
            
            continueButton.isUserInteractionEnabled = !isLoading
        }
    }
    
    // MARK: - Subviews
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        return activityIndicator
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 4
        
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        
        addSubviews([continueButton, activityIndicator])
    }
    
    internal func setContinueButton(withTitle title: String) {
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.white]
        let attrStr = NSAttributedString(string: title, attributes: attributes)
        
        continueButton.setAttributedTitle(attrStr, for: .normal)
    }
    
    func button(isEnabled: Bool) {
        continueButton.isUserInteractionEnabled = isEnabled
        continueButton.backgroundColor = isEnabled ? UIColor.blue : UIColor.lightGray
    }
    
    // MARK: - Handle Button Tap
    
    func continueButtonTapped() {
        delegate?.didTap(continueButton: continueButton, on: self)
    }
    
    // MARK: - AutoLayout
    
    func setupConstraints() {
        let buttonWidth: CGFloat = 273
        let buttonHeight: CGFloat = 49
        continueButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        activityIndicator.leadingAnchor.constraint(equalTo: continueButton.leadingAnchor, constant: 15).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor).isActive = true
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            setupConstraints()
            didUpdateConstraints = true
        }
        
        super.updateConstraints()
    }
}
