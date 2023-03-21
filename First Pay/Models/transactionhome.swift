//
//  transactionhome.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 04/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//




import Foundation
import ObjectMapper

struct lasttransaction : Mappable {
    var responsecode : Int?
    var data : Data?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }


struct Data : Mappable {
    var lasttransamt : Int?
    var balanceDate : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        lasttransamt <- map["lasttransamt"]
        balanceDate <- map["balanceDate"]
    }

}


}
