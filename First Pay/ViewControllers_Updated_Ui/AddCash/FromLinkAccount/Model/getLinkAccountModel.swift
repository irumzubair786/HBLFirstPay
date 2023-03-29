//
//  getLinkAccountModel.swift
//  First Pay
//
//  Created by Irum Butt on 22/03/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct getLinkedAccountModel : Mappable {
    var responsecode : Int?
    var data : [LinkedAccountModel]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
struct LinkedAccountModel : Mappable {
    var accountCbsLinkId : Int?
    var branchCode : String?
    var branchName : String?
    var cbsAccountNo : String?
    var cbsAccountTitle : String?
    var cbsAccountType : String?
    var otpRequired : String?
    var createdate : String?
    var createuser : String?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var mobileNo : String?
    var status : String?
    var updateindex : String?
    var tblAccount : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        accountCbsLinkId <- map["accountCbsLinkId"]
        branchCode <- map["branchCode"]
        branchName <- map["branchName"]
        cbsAccountNo <- map["cbsAccountNo"]
        cbsAccountTitle <- map["cbsAccountTitle"]
        cbsAccountType <- map["cbsAccountType"]
        otpRequired <- map["otpRequired"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        mobileNo <- map["mobileNo"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        tblAccount <- map["tblAccount"]
    }

}

