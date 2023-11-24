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
//        let value = Double(self)
//        let commaSeperateValue = value.formattedWithSeparator
//
//        let valueString = String(format: "%.2f", commaSeperateValue).removeSpecialCharsFromString()
//        return "\(valueString ?? "0.0")"

        
        let balanceValue = Double(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        let formattedNumber = numberFormatter.string(from: NSNumber(value:balanceValue ))
        
        return "\(formattedNumber ?? "0.0")"
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
    func getIntegerValueFromFirstIndex() -> String {
        //let okayChars : Set<Character> =
//            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        let okayChars : Set<Character> =
            Set("1234567890")
        let stringResponseIntegerValuesArray = self.components(separatedBy: ".")
        var stringResponseIntegerValues = ""
        if stringResponseIntegerValuesArray.count > 0 {
            stringResponseIntegerValues = String(stringResponseIntegerValuesArray[1].filter {okayChars.contains($0)})
        }
        
//        return String(self.filter {okayChars.contains($0)})
        return stringResponseIntegerValues
    }
    func getStringValue() -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
       
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
//        let value = self
//        let valueString = String(format: "%.2f", value)
//        let commaSeperateValue = Double(valueString)?.formattedWithSeparator
//        return "\(commaSeperateValue ?? "")"

        
        let balanceValue = Double(self)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        let formattedNumber = numberFormatter.string(from: NSNumber(value:balanceValue ))
        
        return "\(formattedNumber ?? "0.0")"
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


extension Double {
//    func twoDecimal() -> String {
//        let value = self
//        let valueString = String(format: "%.2f", value).removeSpecialCharsFromString()
////        let commaSeperateValue = Double(valueString)?.commaRepresentation
//
//        var amount = "\(valueString)".replace(string: "$", replacement: "")
//        amount = "\(amount)".replace(string: "Rs ", replacement: "")
//
//        let resultValue = Double(amount)!.formattedWithSeparator
//        print(resultValue)
//        return "\(resultValue)"
//    }
//
//    private static var commaFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//
//        return formatter
//    }()
//
//    internal var commaRepresentation: String {
//        return Double.commaFormatter.string(from: Double(self) as NSNumber) ?? ""
//    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
//        formatter.groupingSeparator = " "
        formatter.groupingSeparator = ","
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
