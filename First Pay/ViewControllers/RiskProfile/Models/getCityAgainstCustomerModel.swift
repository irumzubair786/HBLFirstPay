//
//  getCityAgainstCustomerModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 05/10/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct getCityAgainstCustomer : Mappable {
    var responsecode : Int?
    var getCityCustomer : String?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        getCityCustomer <- map["data"]
        messages <- map["messages"]
    }

}
