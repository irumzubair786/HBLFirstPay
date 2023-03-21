//
//  Last5Trasaction.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 12/02/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

class LastTransactions : Mappable {
    var transactionDate : String?
    var amount : Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        transactionDate <- map["transactionDate"]
        amount <- map["amount"]
    }

}

