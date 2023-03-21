//
//  GetcityAgainstProvincedidModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 05/10/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


struct getcityProvinceIDModel : Mappable {
    var responsecode : Int?
    var getCityprovinceId : [getCityprovinceIdData]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        getCityprovinceId <- map["data"]
        messages <- map["messages"]
    }

}
struct getCityprovinceIdData : Mappable {
    var cityId : Int?
    var cityCode : String?
    var cityDescr : String?
    var createdate : Int?
    var createuser : Int?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var sortSeq : Int?
    var status : String?
    var updateindex : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        cityId <- map["cityId"]
        cityCode <- map["cityCode"]
        cityDescr <- map["cityDescr"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        sortSeq <- map["sortSeq"]
        status <- map["status"]
        updateindex <- map["updateindex"]
    }

}
