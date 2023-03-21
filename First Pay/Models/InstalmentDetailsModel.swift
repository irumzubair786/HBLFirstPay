//
//  InstalmentDetailsModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 21/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct InstalmentDetailsModel : Mappable {
    var responsecode : Int?
    var InsDAta : [InstalmentData]?
    var messages : String?

    init?(map: Map) {
        responsecode <- map["responsecode"]
        InsDAta <- map["data"]
        messages <- map["messages"]
    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        InsDAta <- map["data"]
        messages <- map["messages"]
    }

}

struct InstalmentData : Mappable {
    var committeeInstallmentId : Int?
    var committeeHeadId : Int?
    var installmentAmount : Int?
    var dueDate : String?
    var status : String?
    var accountTitle : String?
    var accountNo : String?
    var toAccountId : Int?

    init?(map: Map) {
        committeeInstallmentId <- map["committeeInstallmentId"]
        committeeHeadId <- map["committeeHeadId"]
        installmentAmount <- map["installmentAmount"]
        dueDate <- map["dueDate"]
        status <- map["status"]
        accountTitle <- map["accountTitle"]
        accountNo <- map["accountNo"]
        toAccountId <- map["toAccountId"]
    }

    mutating func mapping(map: Map) {

        committeeInstallmentId <- map["committeeInstallmentId"]
        committeeHeadId <- map["committeeHeadId"]
        installmentAmount <- map["installmentAmount"]
        dueDate <- map["dueDate"]
        status <- map["status"]
        accountTitle <- map["accountTitle"]
        accountNo <- map["accountNo"]
        toAccountId <- map["toAccountId"]
    }

}

