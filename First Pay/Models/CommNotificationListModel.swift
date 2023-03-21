//
//  CommNotificationListModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 14/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct CommNotificationListModel : Mappable {
    var responsecode : Int?
    var notificationData : [Notificationdata]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        notificationData <- map["data"]
        messages <- map["messages"]
    }

}

struct Notificationdata : Mappable {
    
    var committeeNotificationId : Int?
    var createdate : Int?
    var createuser : Int?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var notificationMessage : String?
    var status : String?
    var updateindex : String?
    var tblAccount : String?
    var tblCommitteeHead : TblCommitteeHead?
    var committeeName : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        committeeNotificationId <- map["committeeNotificationId"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        notificationMessage <- map["notificationMessage"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        tblAccount <- map["tblAccount"]
        tblCommitteeHead <- map["tblCommitteeHead"]
        committeeName <- map["committeeName"]
    }

}


struct TblCommitteeHead : Mappable {
    
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
    var adminAccountNo : String?
    var adminAccountTitle : String?

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
        adminAccountNo <- map["adminAccountNo"]
        adminAccountTitle <- map["adminAccountTitle"]
    }

}
