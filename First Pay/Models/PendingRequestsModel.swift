//
//  PendingRequestsModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 16/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct PendingRequestsModel : Mappable {
    var responsecode : Int?
    var pendingData : [PendingData]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        pendingData <- map["data"]
        messages <- map["messages"]
    }

}


struct PendingData : Mappable {
    var amount : Int?
    var comments : String?
    var status : String?
    var statusDescr : String?
    var accountTitle : String?
    var requesterMoneyId : Int?
    var requestDate : String?
    var accountNo : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        amount <- map["amount"]
        comments <- map["comments"]
        status <- map["status"]
        statusDescr <- map["statusDescr"]
        accountTitle <- map["accountTitle"]
        requesterMoneyId <- map["requesterMoneyId"]
        requestDate <- map["requestDate"]
        accountNo <- map["accountNo"]
        
    }

}
