//
//  Enum+CaseCountable.swift
//  humanup
//
//  Created by Chase Wang on 10/18/16.
//  Copyright © 2016 Human Up. All rights reserved.
//

import Foundation

protocol CaseCountable: RawRepresentable {}

extension CaseCountable where RawValue: Integer {
    static var count: RawValue {
        var i: RawValue = 0
        while let _ = Self(rawValue: i) { i = i + 1 }
        return i
    }
}
