//
//  AtmBranchModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 29/12/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper
struct BranchAtmLocator : Mappable {
    var responsecode : Int?
    var dataBranchAtm : [DataBranch]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        dataBranchAtm <- map["data"]
        messages <- map["messages"]
    }

}
struct DataBranch : Mappable {
    var branchId : Int?
    var area : String?
    var branchCode : String?
    var branchDescr : String?
    var branchGroup : String?
    var createdate : Int?
    var createuser : Int?
    var email : String?
    var landline : String?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var lkpRegionId : Int?
    var mobile : String?
    var updateindex : String?
    var status : String?
    var branchCodeAndDescr : String?
    var regionDescr : String?
    var address1 : String?
    var address2 : String?
    var lkpCity : String?
    var tblAccountDebitCards : String?
    var tblDebitCardRequests : String?
    var lkpProvince : String?
    var atm : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        branchId <- map["branchId"]
        area <- map["area"]
        branchCode <- map["branchCode"]
        branchDescr <- map["branchDescr"]
        branchGroup <- map["branchGroup"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        email <- map["email"]
        landline <- map["landline"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        lkpRegionId <- map["lkpRegionId"]
        mobile <- map["mobile"]
        updateindex <- map["updateindex"]
        status <- map["status"]
        branchCodeAndDescr <- map["branchCodeAndDescr"]
        regionDescr <- map["regionDescr"]
        address1 <- map["address1"]
        address2 <- map["address2"]
        lkpCity <- map["lkpCity"]
        tblAccountDebitCards <- map["tblAccountDebitCards"]
        tblDebitCardRequests <- map["tblDebitCardRequests"]
        lkpProvince <- map["lkpProvince"]
        atm <- map["atm"]
    }

}

