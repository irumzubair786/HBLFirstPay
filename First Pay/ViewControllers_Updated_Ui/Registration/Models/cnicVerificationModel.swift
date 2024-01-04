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
    var responseblock : Responseblock!
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        responseblock <- map["responseblock"]
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
struct Responseblock : Mappable {
    var responseType : String?
    var field : String?
    var heading : String?
    var responseDescr : String?
    var responseCode : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responseType <- map["responseType"]
        field <- map["field"]
        heading <- map["heading"]
        responseDescr <- map["responseDescr"]
        responseCode <- map["responseCode"]
    }

}
