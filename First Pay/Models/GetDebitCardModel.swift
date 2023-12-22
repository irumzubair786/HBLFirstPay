//
//  GetDebitCardModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 21/10/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetDebitCardModel : Mappable {
    
    
    var responsecode : Int?
    var data : DebitCardDetailsData!
    var messages : String?
    var responseblock : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
        responseblock <- map["responseblock"]
    }
    
//    var responsecode : Int?
//    var debitCardData : [DebitCardDetailsData]?
//    var messages : String?
//    var responseblock : String?
//    var newCarddata : CardData?
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        responsecode <- map["responsecode"]
//        debitCardData <- map["data"]
//        messages <- map["messages"]
//        newCarddata <- map["data"]
//        responseblock <- map["responseblock"]
//
//    }
    struct DebitCardDetailsData : Mappable {
    var accountDebitCardId : Int?
    var accountId : Int?
    var accountNo : String?
    var createdate : String?
    var createuser : Int?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var pan : String?
    var status : String?
    var updateindex : String?
    var cardId : String?
    var expiryDate : String?
    var debitCardTitle : String?
    var cardExpiryYear : String?
    var cardExpiryMonth : String?
    var lkpBranch : String?
    var apiFlow : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        accountDebitCardId <- map["accountDebitCardId"]
        accountId <- map["accountId"]
        accountNo <- map["accountNo"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        pan <- map["pan"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        cardId <- map["cardId"]
        expiryDate <- map["expiryDate"]
        debitCardTitle <- map["debitCardTitle"]
        cardExpiryYear <- map["cardExpiryYear"]
        cardExpiryMonth <- map["cardExpiryMonth"]
        lkpBranch <- map["lkpBranch"]
        apiFlow <- map["apiFlow"]

         
//        var accountDebitCardId : Int?
//        var accountId : Int?
//        var accountNo : String?
//        var createdate : String?
//        var createuser : Int?
//        var lastupdatedate : String?
//        var lastupdateuser : String?
//        var pan : String?
//        var status : String?
//        var updateindex : String?
//        var cardId : String?
//        var expiryDate : String?
//        var debitCardTitle : String?
//        var cardExpiryYear : String?
//        var cardExpiryMonth : String?
//        var lkpBranch : String?
//        var apiFlow : String?
//
//        init?(map: Map) {
//
//        }
//
//        mutating func mapping(map: Map) {
//
//            accountDebitCardId <- map["accountDebitCardId"]
//            accountId <- map["accountId"]
//            accountNo <- map["accountNo"]
//            createdate <- map["createdate"]
//            createuser <- map["createuser"]
//            lastupdatedate <- map["lastupdatedate"]
//            lastupdateuser <- map["lastupdateuser"]
//            pan <- map["pan"]
//            status <- map["status"]
//            updateindex <- map["updateindex"]
//            cardId <- map["cardId"]
//            expiryDate <- map["expiryDate"]
//            debitCardTitle <- map["debitCardTitle"]
//            cardExpiryYear <- map["cardExpiryYear"]
//            cardExpiryMonth <- map["cardExpiryMonth"]
//            lkpBranch <- map["lkpBranch"]
//            apiFlow <- map["apiFlow"]
        }
    }
//
//struct CardData : Mappable {
//    var accountDebitCardId : Int?
//    var accountId : String?
//    var accountNo : String?
//    var createdate : String?
//    var createuser : String?
//    var lastupdatedate : String?
//    var lastupdateuser : String?
//    var pan : String?
//    var status : String?
//    var updateindex : String?
//    var cardId : String?
//    var expiryDate : String?
//    var debitCardTitle : String?
//    var cardExpiryYear : String?
//    var cardExpiryMonth : String?
//    var lkpBranch : String?
//    var apiFlow : String?
//    var dcStatus : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        accountDebitCardId <- map["accountDebitCardId"]
//        accountId <- map["accountId"]
//        accountNo <- map["accountNo"]
//        createdate <- map["createdate"]
//        createuser <- map["createuser"]
//        lastupdatedate <- map["lastupdatedate"]
//        lastupdateuser <- map["lastupdateuser"]
//        pan <- map["pan"]
//        status <- map["status"]
//        updateindex <- map["updateindex"]
//        cardId <- map["cardId"]
//        expiryDate <- map["expiryDate"]
//        debitCardTitle <- map["debitCardTitle"]
//        cardExpiryYear <- map["cardExpiryYear"]
//        cardExpiryMonth <- map["cardExpiryMonth"]
//        lkpBranch <- map["lkpBranch"]
//        apiFlow <- map["apiFlow"]
//        dcStatus <- map["dcStatus"]
//    }
//
//
//
//
//}
}
