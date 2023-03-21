//
//  GetDebitCardCheckModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 10/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


struct GetDebitCardCheckModel : Mappable {
    var responsecode : Int?
    var data : DebitCardData?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}

struct DebitCardData : Mappable {
    var dcChargesWithDelivery : String?
    var otpReq : String?
    var address : String?
    var dcCharges : String?
    var customerName : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        dcChargesWithDelivery <- map["DcChargesWithDelivery"]
        otpReq <- map["otpReq"]
        address <- map["Address"]
        dcCharges <- map["DcCharges"]
        customerName <- map["CustomerName"]
    }

}
