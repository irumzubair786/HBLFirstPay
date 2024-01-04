//
//  CbsModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 30/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


struct GetCbsModel : Mappable {
    var responsecode : Int?
    var datacbs : [CBsmodeldata]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        datacbs <- map["data"]
        messages <- map["messages"]
    }

}
struct CBsmodeldata : Mappable {
    var accountCategory : String?
    var accountTitle : String?
    var accountType : String?
    var accountCurrency : String?
    var accountNumber : String?
    var accountBranchCode : String?
    var accountStatus : String?
    var accountCategoryCode : String?
    var accountTypeId : String?
    var actualBalance : String?
    var accountStatusCode : String?
    var accountCurrencyId : String?
    var accountBranch : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        accountCategory <- map["accountCategory"]
        accountTitle <- map["accountTitle"]
        accountType <- map["accountType"]
        accountCurrency <- map["accountCurrency"]
        accountNumber <- map["accountNumber"]
        accountBranchCode <- map["accountBranchCode"]
        accountStatus <- map["accountStatus"]
        accountCategoryCode <- map["accountCategoryCode"]
        accountTypeId <- map["accountTypeId"]
        actualBalance <- map["actualBalance"]
        accountStatusCode <- map["accountStatusCode"]
        accountCurrencyId <- map["accountCurrencyId"]
        accountBranch <- map["accountBranch"]
    }

}


