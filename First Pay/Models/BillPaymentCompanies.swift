//
//  BillPaymentCompanies.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 17/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class BillPaymentCompanies: Mappable {
    
    var companies: [SingleCompany]?
    var responsecode: Int?
    var messages:String?

    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        companies <- map["data"]
        
    }
}


class SingleCompany : Mappable {
    
    
    var ubpCompaniesId : Int?
    
    var code : String?
    var createdate : String?
    var createuser : Int?
    var depth : Int?
    var descr : String?
    var lastupdatedate : String?
    var lastupdateuser : Int?
    var name : String?
    var status : String?
    var updateindex : Int?
    var parentId : String?
    var parentName : String?
    var tblTransDoc : String?
    var utilityBillCompanyId : String?
    
    
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        ubpCompaniesId <- map ["ubpCompaniesId"]
        code <- map ["code"]
        createdate <- map ["createdate"]
        createuser <- map ["createuser"]
        depth <- map ["depth"]
        descr <- map ["descr"]
        lastupdatedate <- map ["lastupdatedate"]
        lastupdateuser <- map ["lastupdateuser"]
        name <- map ["name"]
        status <- map ["status"]
        updateindex <- map ["updateindex"]
        parentId <- map ["parentId"]
        parentName <- map ["parentName"]
        tblTransDoc <- map ["tblTransDoc"]
        utilityBillCompanyId <- map ["utilityBillCompanyId"]

    }
}

