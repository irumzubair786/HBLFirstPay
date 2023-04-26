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
