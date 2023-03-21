//
//  CustomerTypeModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 07/10/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct CustomerTypeModel : Mappable {
    var responsecode : Int?
    var Customerdata : [CustomerType]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        Customerdata <- map["data"]
        messages <- map["messages"]
    }

}
struct CustomerType : Mappable {
    var customerTypeId : Int?
    var createdate : String?
    var createuser : String?
    var customerTypeCode : String?
    var customerTypeDescr : String?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var status : String?
    var updateindex : String?
    var tblCustomers : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        customerTypeId <- map["customerTypeId"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        customerTypeCode <- map["customerTypeCode"]
        customerTypeDescr <- map["customerTypeDescr"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        tblCustomers <- map["tblCustomers"]
    }

}
