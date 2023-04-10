//
//  IntExtension.swift
//  First Pay
//
//  Created by Apple on 10/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation


extension Int {

    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    internal var commaRepresentation: String {
        return Int.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
