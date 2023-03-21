//
//  cnicVerificationModel.swift
//  First Pay
//
//  Created by Irum Butt on 27/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct cnicVerficationModel : Mappable {
    var responsecode : Int?
    var data : cnicVer?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
struct cnicVer : Mappable {
    var firstName : String?
    var lastName : String?
    var motherNamesList : [String]?
    var middleName : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        firstName <- map["firstName"]
        lastName <- map["lastName"]
        motherNamesList <- map["motherNamesList"]
        middleName <- map["middleName"]
    }

}
