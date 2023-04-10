//
//  IntExtension.swift
//  First Pay
//
//  Created by Apple on 10/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation


extension Int {
    func twoDecimal() -> String {
        let value = Double(self)
        let valueString = String(format: "%.2f", value)
        let commaSeperateValue = Double(valueString)?.commaRepresentation
        return "\(commaSeperateValue ?? "")".replace(string: "$", replacement: "")
    }
    
}
extension Double {
    func twoDecimal() -> String {
        let value = self
        let valueString = String(format: "%.2f", value)
        let commaSeperateValue = Double(valueString)?.commaRepresentation
        return "\(commaSeperateValue ?? "")".replace(string: "$", replacement: "")
    }
    
    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        return formatter
    }()

    internal var commaRepresentation: String {
        return Double.commaFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
