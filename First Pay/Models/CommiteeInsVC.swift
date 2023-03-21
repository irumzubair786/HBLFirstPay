//
//  CommiteeInsVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 17/06/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation

// MARK: - CommitteeInstallment
import ObjectMapper
struct ComiteeInstallmentModel : Mappable {
    var responsecode : Int?
    var committeedata : [CommitteeInstallment]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        committeedata <- map["data"]
        messages <- map["messages"]
    }

}


struct CommitteeInstallment : Mappable {
    var committeeInstallmentId : Int?
    var committeeHeadId : Int?
    var installmentAmount : Int?
    var dueDate : String?
    var status : String?
    var accountTitle : String?
    var accountNo : String?
    var toAccountId : Int?

    init?(map: Map) {

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
