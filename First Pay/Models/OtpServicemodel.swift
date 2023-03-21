//
//  OtpServicemodel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 02/07/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct OTPserviceModel : Mappable {
    var responsecode : Int?
    var data : String?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
