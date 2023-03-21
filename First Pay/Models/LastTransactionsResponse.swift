//
//  LastTransactionsResponse.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 12/02/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct LastTransactionsResponse : Mappable {
    var transactionDate : String?
    var amount : Int?
     
     init?(map: Map) {

    }

    mutating  func mapping(map: Map) {

        transactionDate <- map["transactionDate"]
        amount <- map["amount"]
       
    }

}
