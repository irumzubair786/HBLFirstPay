//
//  getAllProvienceModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 05/10/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct getAllprovince : Mappable {
    var responsecode : Int?
    var Allprovince : [getAllProvincedata]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        Allprovince <- map["data"]
        messages <- map["messages"]
    }

}
struct getAllProvincedata : Mappable {
    var provinceId : Int?
    var provinceCode : String?
    var provinceDescr : String?
    var sortSeq : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        provinceId <- map["provinceId"]
        provinceCode <- map["provinceCode"]
        provinceDescr <- map["provinceDescr"]
        sortSeq <- map["sortSeq"]
        status <- map["status"]
    }

}
