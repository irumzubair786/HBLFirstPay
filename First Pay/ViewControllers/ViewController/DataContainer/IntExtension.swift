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
        
        print("\(commaSeperateValue ?? "")".removeSpecialCharsFromString())
        return "\(commaSeperateValue ?? "")".removeSpecialCharsFromString()
    }
}

extension String {
    func removeSpecialCharsWithOutCommaFromString() -> String {
        //let okayChars : Set<Character> =
//            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        let okayChars : Set<Character> =
            Set("1234567890.")
        return String(self.filter {okayChars.contains($0) })
    }
    func removeSpecialCharsFromString() -> String {
        //let okayChars : Set<Character> =
//            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        let okayChars : Set<Character> =
            Set("1234567890.,")
        return String(self.filter {okayChars.contains($0) })
    }
    
    func getIntegerValue() -> String {
        //let okayChars : Set<Character> =
//            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        let okayChars : Set<Character> =
            Set("1234567890")
        let stringResponseIntegerValuesArray = self.components(separatedBy: ".")
        var stringResponseIntegerValues = ""
        if stringResponseIntegerValuesArray.count > 2 {
            stringResponseIntegerValues = String(stringResponseIntegerValuesArray[1].filter {okayChars.contains($0)})
        }
        else if stringResponseIntegerValuesArray.count > 0 {
            stringResponseIntegerValues = String(stringResponseIntegerValuesArray.first!.filter {okayChars.contains($0)})
        }
//        return String(self.filter {okayChars.contains($0)})
        return stringResponseIntegerValues
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
