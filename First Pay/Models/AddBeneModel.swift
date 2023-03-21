//
//  AddBeneModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 24/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class AddBeneModel: Mappable {
    
    var beneficiaries: [SingleBeneficiary]?
    var responsecode: Int?
    var messages:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        beneficiaries <- map["data"]
        
        
    }
}


class SingleBeneficiary : Mappable {
    
    var benificiaryId : Int?
    var beneficiaryAccountNo : String?
    var beneficiaryAccountTitle : String?
    var beneficiaryEmail : String?
    var beneficiaryImd : String?
    var beneficiaryMobileNo : String?
    var beneficiaryType : String?
    var beneficiaryNickName : String?
    var createdate : String?
    var createuser : String?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var status : String?
    var updateindex : String?
    var tblCustomer : String?
    var parentCompanyId : String?
    var bankName : String?
    var code : String?
    var imdListId : Int?
    var imdNo: String?
    var beneficiaryImdId : Int?
    

    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        benificiaryId <- map["benificiaryId"]
        beneficiaryAccountNo <- map ["beneficiaryAccountNo"]
        beneficiaryAccountTitle <- map ["beneficiaryAccountTitle"]
        beneficiaryEmail <- map ["beneficiaryEmail"]
        beneficiaryImd <- map ["beneficiaryImd"]
        beneficiaryMobileNo <- map ["beneficiaryMobileNo"]
        beneficiaryType <- map ["beneficiaryType"]
        beneficiaryNickName <- map ["beneficiaryNickName"]
        createdate <- map ["createdate"]
        createuser <- map ["createuser"]
        lastupdatedate <- map ["lastupdatedate"]
        lastupdateuser <- map ["lastupdateuser"]
        status <- map ["status"]
        updateindex <- map ["updateindex"]
        tblCustomer <- map ["tblCustomer"]
        parentCompanyId <- map ["parentCompanyId"]
        bankName <- map ["bankName"]
        code <- map ["code"]
        imdListId <- map ["imdListId"]
        imdNo <- map ["imdNo"]
        beneficiaryImdId <- map ["beneficiaryImdId"]
        
        
        
        
        
    }
}
