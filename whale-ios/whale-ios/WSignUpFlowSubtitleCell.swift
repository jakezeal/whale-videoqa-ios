//
//  WSignUpFlowSubtitleCell.swift
//  whale-ios
//
//  Created by Jake on 3/22/17.
//  Copyright © 2017 Jake. All rights reserved.
//

import UIKit

class WSignUpFlowSubtitleCell: UITableViewCell {
    
    // MARK: - Class Vars
    
    static let estimatedHeight: CGFloat = 45
    
    static let identifier = WSignUpFlowSubtitleCell.toString()
    
    // MARK: - Subviews
    
    @IBOutlet weak var subtitleLabel: UILabel!

    // MARK: - Cell Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
