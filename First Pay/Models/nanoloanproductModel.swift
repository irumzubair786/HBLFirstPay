//
//  nanoloanproductModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 24/06/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation

struct NanoloanProductModelUpdate: Codable {
    let responsecode: Int
    let data: [nanoloanmodel]
    let messages: String
}

// MARK: - Datum
struct nanoloanmodel: Codable {
    let nlProductID, maxAmount, minAmount: Int
    let nlProductDescr, repaymentFrequency: String

    enum CodingKeys: String, CodingKey {
        case nlProductID = "nlProductId"
        case maxAmount, minAmount, nlProductDescr, repaymentFrequency
    }
}
