//
//  MiniStatementModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 16/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class MiniStatementModel: Mappable {
    
    var responsecode: Int?
    var messages:String?
    var ministatement: [SingleMiniStatement]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        ministatement <- map["data"]
        
    }
}


class SingleMiniStatement : Mappable {
    
    var rowkey : Int?
    var transDocsDescr : String?
    var transDate : String?
    var transRefnum : String?
    var refNum: String?
    var txnAmt : Int?
    var fedAmt : Int?
    var feeAmt : Int?
    var amountType : String?
    var toAccountTitle : String?
    var accountId : Int?
    var fromAccountNo : String?
    var fromAccountTitle : String?
    var taccountId : Int?
    var toAccountNo : String?
    var latitude : String?
    var longitude : String?
    var comments : String?
    var openingbalance : Int?
    var closingBalance : Int?
    var printflag : String?
    var transDocsCode : String?
    var valueDate : String?
    var totaltransamount : String?
    var one_link_amt : String?
    var stan: String?
    var status : String?
    var ubpCompanyId : Int?
    var getUbpCompanyId : Int?
    var disputeComments: String?
    var disputeDescr : String?
    var disputeDate : String?
    var sourceBank : String?
    var destinationBank : String?
    var channel : String?
    var whtAmt : Int?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        rowkey <- map["rowkey"]
        transDocsDescr <- map["transDocsDescr"]
        transDate <- map ["transDate"]
        transRefnum <- map ["transRefnum"]
        refNum <- map ["refNum"]
        txnAmt <- map ["txnAmt"]
        fedAmt <- map ["fedAmt"]
        feeAmt <- map ["feeAmt"]
        amountType <- map["amountType"]
        toAccountTitle <- map ["toAccountTitle"]
        accountId <- map ["accountId"]
        fromAccountNo <- map ["fromAccountNo"]
        fromAccountTitle <- map ["fromAccountTitle"]
        taccountId <- map ["taccountId"]
        toAccountNo <- map["toAccountNo"]
        latitude <- map ["latitude"]
        longitude <- map ["longitude"]
        comments <- map ["comments"]
        openingbalance <- map ["openingbalance"]
        closingBalance <- map ["closingBalance"]
        printflag <- map ["printflag"]
        transDocsCode <- map ["transDocsCode"]
        valueDate <- map ["valueDate"]
        totaltransamount <- map ["totaltransamount"]
        one_link_amt <- map ["one_link_amt"]
        stan <- map ["stan"]
        status <- map ["status"]
        ubpCompanyId <- map ["ubpCompanyId"]
        getUbpCompanyId <- map ["getUbpCompanyId"]
        disputeComments <- map ["disputeComments"]
        disputeDescr <- map ["disputeDescr"]
        disputeDate <- map ["disputeDate"]
        sourceBank <- map ["sourceBank"]
        destinationBank <- map ["destinationBank"]
        channel <- map ["channel"]
        
    }
}

