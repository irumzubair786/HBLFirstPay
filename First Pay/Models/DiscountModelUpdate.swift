//
//  DiscountModelUpdate.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 26/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct discountCity : Mappable {
    var responsecode : Int?
    var data : [DiscountModelupdated]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}


struct DiscountModelupdated : Mappable {
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
    var lkpDistrict : String?
    var lkpRegion : String?
    var tblCustomers : String?
    var tblBrandLocations : String?
    var lkpBranches : String?

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
        lkpDistrict <- map["lkpDistrict"]
        lkpRegion <- map["lkpRegion"]
        tblCustomers <- map["tblCustomers"]
        tblBrandLocations <- map["tblBrandLocations"]
        lkpBranches <- map["lkpBranches"]
    }

}
