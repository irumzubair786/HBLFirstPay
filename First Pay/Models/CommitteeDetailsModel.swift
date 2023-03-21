//
//  CommitteeDetailsModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 20/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct CommitteeDetailsModel : Mappable {
    var responsecode : Int?
    var comDetailsdata : ComDetailsData?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        comDetailsdata <- map["data"]
        messages <- map["messages"]
    }

}

struct ComDetailsData : Mappable {
    
    var committeeHeadId : Int?
    var committeeCode : String?
    var committeeDescr : String?
    var createdate : Int?
    var createuser : Int?
    var fineAmount : Int?
    var frequency : String?
    var installmentAmount : Int?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var startDate : String?
    var status : String?
    var tenure : String?
    var totalAmount : Int?
    var totalInstallments : String?
    var totalParticipants : Int?
    var updateindex : String?
    var editAllowed : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        committeeHeadId <- map["committeeHeadId"]
        committeeCode <- map["committeeCode"]
        committeeDescr <- map["committeeDescr"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        fineAmount <- map["fineAmount"]
        frequency <- map["frequency"]
        installmentAmount <- map["installmentAmount"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        startDate <- map["startDate"]
        status <- map["status"]
        tenure <- map["tenure"]
        totalAmount <- map["totalAmount"]
        totalInstallments <- map["totalInstallments"]
        totalParticipants <- map["totalParticipants"]
        updateindex <- map["updateindex"]
        editAllowed <- map["editAllowed"]
    }

}
