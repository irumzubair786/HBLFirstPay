//
//  OtpVerificationModel.swift
//  First Pay
//
//  Created by Irum Butt on 21/03/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct otpVerificationModel : Mappable {
    var responsecode : Int?
    var data : DataModel?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
struct DataModel : Mappable {
    var oTPREQ : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        oTPREQ <- map["OTPREQ"]
    }

}
