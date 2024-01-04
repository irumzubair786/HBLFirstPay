//
//  mobileRegistration.swift
//  First Pay
//
//  Created by Irum Butt on 27/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper
struct mobileRegistrationModel : Mappable {
    var responsecode : Int?
    var data : MobRegistration?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}



struct MobRegistration : Mappable {
    var token : String?
    var OTPTimeOut : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        token <- map["token"]
        OTPTimeOut <- map["OTPTimeOut"]
    }

}
