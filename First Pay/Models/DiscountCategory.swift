//
//  DiscountCategory.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 26/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

class DiscountCategoryModel : Mappable {
    var responsecode : Int?
    var data : [DisCateogory]?
    var messages : String?

    required init?(map: Map) {
        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

    func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}

class DisCateogory : Mappable {
    var categoryId : Int?
    var categoryCode : String?
    var categoryDescr : String?
    var createdate : String?
    var createuser : String?
    var lastupdatedate : String?
    var lastupdateuser : Int?
    var sortSeq : Int?
    var status : String?
    var updateindex : Int?
    var tblBrands : String?

    required init?(map: Map) {
        categoryId <- map["categoryId"]
        categoryCode <- map["categoryCode"]
        categoryDescr <- map["categoryDescr"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        sortSeq <- map["sortSeq"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        tblBrands <- map["tblBrands"]
    }

    func mapping(map: Map) {

        categoryId <- map["categoryId"]
        categoryCode <- map["categoryCode"]
        categoryDescr <- map["categoryDescr"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        sortSeq <- map["sortSeq"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        tblBrands <- map["tblBrands"]
    }

}
