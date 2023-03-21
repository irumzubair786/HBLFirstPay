//
//  VerifyOTP.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 14/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class VerifyOTP: Mappable {

    var responsecode: Int?
    var messages:String?
    var customerAllId : Int?
    var token : String?
    var firstName : String?
    var middleName : String?
    var lastName : String?


    required init?(map: Map){ }

    func mapping(map: Map) {

        responsecode <- map["responsecode"]
        messages <- map["messages"]
        customerAllId <- map["data.customerAllId"]
        token <- map["data.token"]
        firstName <- map["data.firstName"]
        middleName <- map["data.middleName"]
        lastName <- map["data.lastName"]

    }
}

//

//
//
