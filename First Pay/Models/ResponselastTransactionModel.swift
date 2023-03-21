//
//  ResponselastTransactionModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 04/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct TransactionResponse : Mappable {
    var responsecode : Int?
    var data : [lasttransactionupdated]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }
}
struct lasttransactionupdated : Mappable {
    var transactionDate : String?
    var amount : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        transactionDate <- map["transactionDate"]
        amount <- map["amount"]
    }

}
