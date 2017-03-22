//
//  WSignUpFlowTitleCell.swift
//  whale-ios
//
//  Created by Jake on 3/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

class WSignUpFlowTitleCell: UITableViewCell {

    // MARK: - Class Vars
    
    static let estimatedHeight: CGFloat = 33
    
    static let identifier = WSignUpFlowTitleCell.toString()
    
    // MARK: - Subviews
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
