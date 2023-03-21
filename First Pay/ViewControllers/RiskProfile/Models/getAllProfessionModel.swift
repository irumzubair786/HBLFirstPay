//
//  getAllProfessionModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 05/10/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct getAllProfessionModel : Mappable {
    var responsecode : Int?
    var dataprofession : [DataProfession]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        dataprofession <- map["data"]
        messages <- map["messages"]
    }

}


struct DataProfession : Mappable {
        var professionId : Int?
        var createdate : String?
        var createuser : String?
        var lastupdatedate : String?
        var lastupdateuser : String?
        var professionCode : String?
        var professionDescr : String?
        var status : String?
        var updateindex : String?
        var tblCustomers : String?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            professionId <- map["professionId"]
            createdate <- map["createdate"]
            createuser <- map["createuser"]
            lastupdatedate <- map["lastupdatedate"]
            lastupdateuser <- map["lastupdateuser"]
            professionCode <- map["professionCode"]
            professionDescr <- map["professionDescr"]
            status <- map["status"]
            updateindex <- map["updateindex"]
            tblCustomers <- map["tblCustomers"]
        }

}
