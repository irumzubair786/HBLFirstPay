//
//  UtilityBillCompaniesModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 17/01/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class UtilityBillCompaniesModel: Mappable {
    
    
    var responsecode: Int?
    var messages:String?
    var companies: [SingleCompanyList]?
    var stringCompaniesList = [String]()
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        companies <- map["data"]
        
        for aCompany in self.companies! {
            stringCompaniesList.append(aCompany.name!)
        }
        
    }
}


class SingleCompanyList : Mappable {
    
//    var ubpCompaniesId : Int?
//    var code : String?
//    var createdate : Int?
//    var createuser : Int?
//    var depth : Int?
//    var descr : String?
//    var lastupdatedate : String?
//    var lastupdateuser : String?
//    var name : String?
//    var status : String?
//    var updateindex : String?
//    var parentId : Int?
//    var parentName : String?
//    var tblTransDoc : String?
//
//    required init?(map: Map){ }
//
//    func mapping(map: Map){
//
//        ubpCompaniesId <- map ["ubpCompaniesId"]
//        code <- map ["code"]
//        createdate <- map ["createdate"]
//        createuser <- map ["createuser"]
//        depth <- map ["depth"]
//        descr <- map ["descr"]
//        lastupdatedate <- map ["lastupdatedate"]
//        lastupdateuser <- map ["lastupdateuser"]
//        name <- map ["name"]
//        status <- map ["status"]
//        updateindex <- map ["updateindex"]
//        parentId <- map ["parentId"]
//        parentName <- map ["parentName"]
//        tblTransDoc <- map ["tblTransDoc"]
//
//
//    }
//
//    init(code:String, name: String) {
//        self.code = code
//        self.name = name
//    }
    var ubpCompaniesId : Int?
    var code : String?
    var createdate : String?
    var createuser : Int?
    var depth : Int?
    var descr : String?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var name : String?
    var status : String?
    var updateindex : String?
    var parentId : String?
    var parentName : String?
    var path : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        ubpCompaniesId <- map["ubpCompaniesId"]
        code <- map["code"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        depth <- map["depth"]
        descr <- map["descr"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        name <- map["name"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        parentId <- map["parentId"]
        parentName <- map["parentName"]
        path <- map["path"]
    }
}
