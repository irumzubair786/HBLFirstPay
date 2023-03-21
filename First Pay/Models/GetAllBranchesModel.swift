//
//  GetAllBranchesModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetAllBranchesModel : Mappable {
    var responsecode : Int?
    var data : [BranchData]?
    var messages : String?
    var stringBranch = [String]()
    

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
        
        
        for aBranch in self.data! {
            stringBranch.append(aBranch.branchDescr!)
        }
    }
}

struct BranchData : Mappable {
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
    }

}
