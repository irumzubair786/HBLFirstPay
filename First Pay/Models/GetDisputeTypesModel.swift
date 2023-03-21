//
//  GetDisputeTypesModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 25/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class GetDisputeTypesModel: Mappable {
    
    var responsecode: Int?
    var messages:String?
    var disputeTypes: [SingleDispute]?
    var stringDisputesList = [String]()
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        disputeTypes <- map["data"]
        
        
        for aDispute in self.disputeTypes! {
            stringDisputesList.append(aDispute.disputeTypeDescr!)
        }
    }
}

class SingleDispute : Mappable {
    
    var disputeTypeId : Int?
    var createdate : String?
    var createuser : Int?
    var disputeTypeCode : String?
    var disputeTypeDescr : String?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var status : String?
    var updateindex : String?
    var tblDisputeRequests : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        disputeTypeId <- map["disputeTypeId"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        disputeTypeCode <- map["ddisputeTypeCode"]
        disputeTypeDescr <- map["disputeTypeDescr"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        tblDisputeRequests <- map["tblDisputeRequests"]

    }
}
