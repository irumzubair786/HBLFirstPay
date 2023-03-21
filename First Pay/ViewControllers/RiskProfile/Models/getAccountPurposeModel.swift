//
//  getAccountPurposeModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 05/10/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper
struct getAccountPurpose : Mappable {
    var responsecode : Int?
    var accountpurpose : [AccountPurpose]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        accountpurpose <- map["data"]
        messages <- map["messages"]
    }

}
struct AccountPurpose : Mappable {
    var accountPurposeId : Int?
    var accountPurposeCode : String?
    var accountPurposeDescr : String?
    var createdate : String?
    var createuser : String?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var status : String?
    var updateindex : String?
    var tblCustomers : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        accountPurposeId <- map["accountPurposeId"]
        accountPurposeCode <- map["accountPurposeCode"]
        accountPurposeDescr <- map["accountPurposeDescr"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        tblCustomers <- map["tblCustomers"]
    }

}
