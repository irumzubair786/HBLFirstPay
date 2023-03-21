//
//  FundInitiateModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/12/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//
//
//import Foundation
//import ObjectMapper
//
//
//class FundInitiateModel: Mappable {
//
//    var responsecode: Int?
//    var messages: String?
//
//    var responseDescr: String?
//    var accountTitle : String?
//    var accountNo: String?
//    var iban: String?
//    var OTPREQ: String?
//
//
//
//    required init?(map: Map){ }
//
//    func mapping(map: Map) {
//
//        responsecode <- map["responsecode"]
//        messages <- map["messages"]
//
//        responseDescr <- map["data.responseDescr"]
//        accountTitle <- map["data.accountTitle"]
//        accountNo <- map["data.accountNo"]
//        iban <- map["data.iban"]
//        OTPREQ <- map["data.OTPREQ"]
//
//    }
//}





//initiate mmodel
import Foundation
import ObjectMapper

class FundInitiateModel : Mappable {
    var accountTitle : String?
    var accountNo : String?
    var iban : String?
    var oTPREQ : String?
    var lastTransactions : [LastTransactionsResponse]?
    var responseDescr : String?
    var responseCode : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        accountTitle <- map["accountTitle"]
        accountNo <- map["accountNo"]
        iban <- map["iban"]
        oTPREQ <- map["OTPREQ"]
        lastTransactions <- map["lastTransactions"]
        responseDescr <- map["responseDescr"]
        responseCode <- map["responseCode"]
    }

}

