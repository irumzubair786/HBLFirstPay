//
//  stringExtension.swift
//  First Pay
//
//  Created by Apple on 20/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation

extension String {
    var allNumbers: Int {
        let numbersInStrings = Int(self.components(separatedBy: .decimalDigits.inverted).joined())
        print(numbersInStrings)
        return numbersInStrings!
    }
}
extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}

public extension [String: [String]] {
    func toBase64() -> String? {
        guard let data = self.stringArrayToData(stringArray: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

//    func fromBase64() -> String? {
//        let data2 = Data(self.utf8)
//
//        guard let data = self.dataToStringArray(data:Data(self)) else {
//            return nil
//        }
//
//        return Data(self.utf8).base64EncodedString()
//    }
    
    func stringArrayToData(stringArray: [String: [String]]) -> Data? {
      return try? JSONSerialization.data(withJSONObject: stringArray, options: [])
    }
    
    func dataToStringArray(data: Data) -> [String]? {
      return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String]
    }
}
