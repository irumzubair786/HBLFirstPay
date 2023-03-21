//
//  GetReasonsModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 02/09/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetReasonsModel : Mappable {
    var responsecode : Int?
    var reasonsData : [ReasonsData]?
    var messages : String?
    var stringReasons = [String]()
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        reasonsData <- map["data"]
        messages <- map["messages"]
        
        if let singleReasons = self.reasonsData{
               for aReason in singleReasons {
                   stringReasons.append(aReason.descr!)
               }
           }
    }

}

struct ReasonsData : Mappable {
    
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
