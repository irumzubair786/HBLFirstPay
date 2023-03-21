//
//  DiscountCityModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 28/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct DiscountCityModel : Mappable {
    var responsecode : Int?
    var citiesdata : [String]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        citiesdata <- map["data"]
        messages <- map["messages"]
    }

}
