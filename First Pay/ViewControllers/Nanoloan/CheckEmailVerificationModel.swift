//
//  CheckEmailVerificationModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 12/11/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation

import ObjectMapper





struct checkEmailVerification : Mappable {
    var responsecode : Int?
    var EmailData : EmailDataModel?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        EmailData <- map["data"]
        messages <- map["messages"]
    }

}

struct EmailDataModel : Mappable {
    var checkEmailVerified : String?
    var checkEmail : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        checkEmailVerified <- map["checkEmailVerified"]
        checkEmail <- map["checkEmail"]
    }

}
