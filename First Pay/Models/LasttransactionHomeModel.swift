//
//  LasttransactionHomeModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 08/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import Foundation

// MARK: - Lasttranaction
struct Lasttranaction: Codable {
    let responsecode: Int
    let data: DataClass
    let messages: String
}

// MARK: - DataClass
struct DataClass: Codable {
    let lasttransamt: Int
    let balanceDate: String
}
