//
//  WAuthenticationViewController.swift
//  whale-ios
//
//  Created by Jake on 3/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

class WAuthenticationViewController: UIViewController {
    
    // MARK: - Subviews
    
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var whaleLabel: UILabel!
    @IBOutlet weak var signUpWithEmailButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brandNameLabel.set(kerningValue: 2)

    }
    
    // MARK: - IBActions

    @IBAction func signUpWithEmailButtonTapped(_ sender: UIButton) {
        // Future Analytics
    }

}
