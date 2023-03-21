//
//  last5transactionModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 04/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper
struct transactionModel : Mappable {
    var responsecode : Int?
    var datatransaction : [lastFiveTransaction]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        datatransaction <- map["data"]
        messages <- map["messages"]
    }

}
struct lastFiveTransaction : Mappable {
    var transactionDate : String?
    var amount : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        transactionDate <- map["transactionDate"]
        amount <- map["amount"]
    }

}
