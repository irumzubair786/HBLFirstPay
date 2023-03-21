//
//  GetDeparturesModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 28/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetDeparturesModel : Mappable {
    var responsecode : Int?
    var data : [DepartureData]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
        
        
    }

}

struct DepartureData : Mappable {
    var originCityId : String?
    var originCityName : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        originCityId <- map["originCityId"]
        originCityName <- map["originCityName"]
    }

}
