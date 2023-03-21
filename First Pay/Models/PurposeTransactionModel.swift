//
//  PurposeTransactionModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 17/08/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct PurposeTransactionModel : Mappable {
    
    var responsecode : Int?
    var purposeData : [PurposeData]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        purposeData <- map["data"]
        messages <- map["messages"]
        
    }

}

struct PurposeData : Mappable {
    
    var transactionPurposeId : Int?
    var code : String?
    var createdate : Int?
    var createuser : Int?
    var descr : String?
    var lastupdatedate : Int?
    var lastupdateuser : Int?
    var sortSeq : String?
    var status : String?
    var updateindex : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        transactionPurposeId <- map["transactionPurposeId"]
        code <- map["code"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        descr <- map["descr"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        sortSeq <- map["sortSeq"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        
    }

}
