//
//  DiscountsModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 28/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct DiscountsModel : Mappable {
    var responsecode : Int?
    var discountData : [DiscountData]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        discountData <- map["data"]
        messages <- map["messages"]
    }

}

struct DiscountData : Mappable {
    var discountId : Int?
    var address : String?
    var category : String?
    var city : String?
    var createdate : String?
    var createuser : Int?
    var discountDetails : String?
    var discountPartner : String?
    var discountPercentage : Int?
    var nameOfCity : String?
    var noOfCity : String?
    var status : Int?
    var website : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        discountId <- map["discountId"]
        address <- map["address"]
        category <- map["category"]
        city <- map["city"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        discountDetails <- map["discountDetails"]
        discountPartner <- map["discountPartner"]
        discountPercentage <- map["discountPercentage"]
        nameOfCity <- map["nameOfCity"]
        noOfCity <- map["noOfCity"]
        status <- map["status"]
        website <- map["website"]
    }

}
