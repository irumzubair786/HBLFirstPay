////
////  TestCheckLoanEligiblityModel.swift
////  First Pay
////
////  Created by Syed Uzair Ahmed on 24/06/2021.
////  Copyright © 2021 FMFB Pakistan. All rights reserved.
////
//
//import Foundation
//import ObjectMapper
//
//struct CheckLoan : Mappable {
//    var responsecode : Int?
//    var data : [Data]?
//    var messages : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        responsecode <- map["responsecode"]
//        data <- map["data"]
//        messages <- map["messages"]
//    }
//
//}
//struct Data : Mappable {
//    var nlProductId : Int?
//    var maxAmount : Int?
//    var minAmount : Int?
//    var nlProductDescr : String?
//    var repaymentFrequency : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        nlProductId <- map["nlProductId"]
//        maxAmount <- map["maxAmount"]
//        minAmount <- map["minAmount"]
//        nlProductDescr <- map["nlProductDescr"]
//        repaymentFrequency <- map["repaymentFrequency"]
//    }
//
//}
//
