//
//  GetLoanPurposeModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 24/06/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation

import ObjectMapper

struct getloanpuppose : Mappable {
    var responsecode : Int?
    var data : [loanpurpose]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}


struct loanpurpose : Mappable {
    var nlPurposeId : Int?
    var nlPurposeCode : String?
    var nlPurposeDescr : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        nlPurposeId <- map["nlPurposeId"]
        nlPurposeCode <- map["nlPurposeCode"]
        nlPurposeDescr <- map["nlPurposeDescr"]
    }

}
