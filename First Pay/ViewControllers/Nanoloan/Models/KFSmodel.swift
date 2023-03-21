////
////  KFSmodel.swift
////  First Pay
////
////  Created by Arsalan Amjad on 13/09/2021.
////  Copyright © 2021 FMFB Pakistan. All rights reserved.
////
//
//import Foundation
//import ObjectMapper
//struct KFSModel : Mappable {
//    var responsecode : Int?
//    var KFSdata : Datakfs?
//    var messages : String?
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        responsecode <- map["responsecode"]
//        KFSdata <- map["data"]
//        messages <- map["messages"]
//    }
//
//}
//struct Datakfs : Mappable {
//    var accountTitle : String?
//    var cnic : String?
//    var loanNo : String?
//    var productDescr : String?
//    var loanAmount : Int?
//    var totalInstallments : Int?
//    var repaymentFrequency : String?
//    var markupRate : Int?
//    var processingFee : Int?
//    var installmentAmount : Double?
//    var totalPayableAmount : Double?
//    var epChargesAmount : Int?
//    var lpChargesAmount : Int?
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        accountTitle <- map["accountTitle"]
//        cnic <- map["cnic"]
//        loanNo <- map["loanNo"]
//        productDescr <- map["productDescr"]
//        loanAmount <- map["loanAmount"]
//        totalInstallments <- map["totalInstallments"]
//        repaymentFrequency <- map["repaymentFrequency"]
//        markupRate <- map["markupRate"]
//        processingFee <- map["processingFee"]
//        installmentAmount <- map["installmentAmount"]
//        totalPayableAmount <- map["totalPayableAmount"]
//        epChargesAmount <- map["epChargesAmount"]
//        lpChargesAmount <- map["lpChargesAmount"]
//    }
//
//}
import Foundation
import ObjectMapper

struct KFSModel : Mappable {
    var responsecode : Int?
    var kfsdata : KFS?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        kfsdata <- map["data"]
        messages <- map["messages"]
    }

}
struct KFS : Mappable {
    var accountTitle : String?
    var cnic : String?
    var loanNo : String?
    var productDescr : String?
    var loanAmount : Double?
    var totalInstallments : Double?
    var repaymentFrequency : String?
    var markupRate : Int?
    var processingFee : Double?
    var installmentAmount : Double?
    var totalPayableAmount : Double?
    var epChargesAmount : Double?
    var lpChargesAmount : Double?
    var fedAmount : Int?
    var noOfDaysTenure : Int?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        accountTitle <- map["accountTitle"]
        cnic <- map["cnic"]
        loanNo <- map["loanNo"]
        productDescr <- map["productDescr"]
        loanAmount <- map["loanAmount"]
        totalInstallments <- map["totalInstallments"]
        repaymentFrequency <- map["repaymentFrequency"]
        markupRate <- map["markupRate"]
        processingFee <- map["processingFee"]
        installmentAmount <- map["installmentAmount"]
        totalPayableAmount <- map["totalPayableAmount"]
        epChargesAmount <- map["epChargesAmount"]
        lpChargesAmount <- map["lpChargesAmount"]
        fedAmount <- map["fedAmount"]
        noOfDaysTenure <- map["noOfDaysTenure"]
    }

}
