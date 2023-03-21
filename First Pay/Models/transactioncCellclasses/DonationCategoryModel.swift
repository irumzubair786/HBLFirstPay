//
//  DonationCategoryModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 02/08/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct DonationcateogoryModel : Mappable {
    var responsecode : Int?
    var datalists : [DonationList]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        datalists <- map["data"]
        messages <- map["messages"]
    }

}

struct DonationList : Mappable {
    var donationCategoryId : Int?
    var categoryCode : String?
    var categoryDescr : String?
    var sortSeq : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        donationCategoryId <- map["donationCategoryId"]
        categoryCode <- map["categoryCode"]
        categoryDescr <- map["categoryDescr"]
        sortSeq <- map["sortSeq"]
        status <- map["status"]
    }

}
