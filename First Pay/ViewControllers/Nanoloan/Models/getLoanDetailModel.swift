//
//  getLoanDetailModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 15/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct getloanDetail : Mappable {
    var responsecode : Int?
    var loandetail : [LoanDatam]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        loandetail <- map["data"]
        messages <- map["messages"]
    }

}
struct LoanDatam : Mappable {
    var schNo : Int?
    var installmentAmount : Double?
    var balanceAmount : Double?
    var status : String?
    var schStartDate : String?
    var schEndDate : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        schNo <- map["schNo"]
        installmentAmount <- map["installmentAmount"]
        balanceAmount <- map["balanceAmount"]
        status <- map["status"]
        schStartDate <- map["schStartDate"]
        schEndDate <- map["schEndDate"]
    }

}
