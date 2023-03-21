//
//  NanoloangetProductModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 24/06/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct NanoloangetProductModel : Mappable {
    var responsecode : Int?
    var data : [nanoLoanProduct]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
struct nanoLoanProduct : Mappable {
    var nlProductId : Int?
    var maxAmount : Int?
    var minAmount : Int?
    var nlProductDescr : String?
    var repaymentFrequency : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        nlProductId <- map["nlProductId"]
        maxAmount <- map["maxAmount"]
        minAmount <- map["minAmount"]
        nlProductDescr <- map["nlProductDescr"]
        repaymentFrequency <- map["repaymentFrequency"]
    }

}
