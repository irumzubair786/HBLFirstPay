//
//  GetCBSAccounts.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 23/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


//class GetCBSAccounts: Mappable {
//
//    var responsecode: Int?
//    var messages:String?
//    var accounts: [SingleAccountList]?
//    var stringAccountsList = [String]()
//
//
//    required init?(map: Map){ }
//
//    func mapping(map: Map) {
//
//        responsecode <- map["responsecode"]
//        messages <- map["messages"]
//        accounts <- map["data"]
//
////        for aCompany in self.accounts! {
////            stringAccountsList.append(aCompany.accountNumber!)
////        }
//
//    }
//}


//class SingleAccountList : Mappable {
//
//    var accountCategory:String?
//    var accountTitle:String?
//    var accountType:String?
//    var accountCurrency:String?
//    var accountNumber:String?
//    var accountBranchCode:String?
//    var accountStatus:String?
//    var accountCategoryCode:String?
//    var accountTypeId:String?
//    var actualBalance:String?
//    var accountStatusCode:String?
//    var accountCurrencyId:String?
//    var accountBranch:String?
//
//    var accountCbsLinkId:String?
//    var branchCode:String?
//    var branchName:String?
//    var cbsAccountNo:String?
//    var cbsAccountTitle:String?
//    var cbsAccountType:String?
//    var otpRequired:String?
//    var createdate:String?
//    var createuser:String?
//    var lastupdatedate:String?
//    var lastupdateuser:String?
//    var mobileNo:String?
//    var status:String?
//    var updateindex:String?
//    var tblAccount:String?
//
//    required init?(map: Map){ }
//
//    func mapping(map: Map){
//
//        accountCategory <- map["data.accountCategory"]
//        accountTitle <- map["data.accountTitle"]
//        accountType <- map["data.accountType"]
//        accountCurrency <- map["data.accountCurrency"]
//        accountNumber <- map["data.accountNumber"]
//        accountBranchCode <- map["data.accountBranchCode"]
//        accountStatus <- map["data.accountStatus"]
//        accountCategoryCode <- map["data.accountCategoryCode"]
//        accountTypeId <- map["data.accountTypeId"]
//        actualBalance <- map["data.actualBalance"]
//        accountStatusCode <- map["data.accountStatusCode"]
//        accountCurrencyId <- map["data.accountCurrencyId"]
//        accountBranch <- map["data.accountBranch"]
//
//        accountCbsLinkId <- map["data.accountCbsLinkId"]
//        branchCode <- map["data.branchCode"]
//        branchName <- map["data.branchName"]
//        cbsAccountNo <- map["data.cbsAccountNo"]
//        cbsAccountTitle <- map["data.cbsAccountTitle"]
//        cbsAccountType <- map["data.cbsAccountType"]
//        otpRequired <- map["data.otpRequired"]
//        createdate <- map["data.createdate"]
//        createuser <- map["data.createuser"]
//        lastupdatedate <- map["data.lastupdatedate"]
//        lastupdateuser <- map["data.lastupdateuser"]
//        mobileNo <- map["data.mobileNo"]
//        status <- map["data.status"]
//        updateindex <- map["data.updateindex"]
//        tblAccount <- map["data.tblAccount"]
//
//
//    }
//}

//class GetCBSAccounts : Mappable {
//
//
//    var responsecode : Int?
//    var accdata : [CbsData]?
//    var messages : String?
//
//   required init?(map: Map) {
//
//    }
//
// func mapping(map: Map) {
//
//        responsecode <- map["responsecode"]
//        accdata <- map["data"]
//        messages <- map["messages"]
//
//
//    }
//
//}
//
//
//class CbsData : Mappable {
//    var accountCategory : String?
//    var accountTitle : String?
//    var accountType : String?
//    var accountCurrency : String?
//    var accountNumber : String?
//    var accountBranchCode : String?
//    var accountStatus : String?
//    var accountCategoryCode : String?
//    var accountTypeId : String?
//    var actualBalance : String?
//    var accountStatusCode : String?
//    var accountCurrencyId : String?
//    var accountBranch : String?
//
//   required  init?(map: Map) {
//
//    }
//
//  func mapping(map: Map) {
//
//        accountCategory <- map["accountCategory"]
//        accountTitle <- map["accountTitle"]
//        accountType <- map["accountType"]
//        accountCurrency <- map["accountCurrency"]
//        accountNumber <- map["accountNumber"]
//        accountBranchCode <- map["accountBranchCode"]
//        accountStatus <- map["accountStatus"]
//        accountCategoryCode <- map["accountCategoryCode"]
//        accountTypeId <- map["accountTypeId"]
//        actualBalance <- map["actualBalance"]
//        accountStatusCode <- map["accountStatusCode"]
//        accountCurrencyId <- map["accountCurrencyId"]
//        accountBranch <- map["accountBranch"]
//    }
//
//
//
//}




//new model

struct GetCBSAccounts : Mappable {
    var responsecode : Int?
    var accdata : [CbsData]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        accdata <- map["data"]
        messages <- map["messages"]
    }

}
struct CbsData : Mappable {
    var accountCategory : String?
    var accountTitle : String?
    var accountType : String?
    var accountCurrency : String?
    var accountNumber : String?
    var accountBranchCode : String?
    var accountStatus : String?
    var accountCategoryCode : String?
    var accountTypeId : String?
    var actualBalance : String?
    var accountStatusCode : String?
    var accountCurrencyId : String?
    var accountBranch : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        accountCategory <- map["accountCategory"]
        accountTitle <- map["accountTitle"]
        accountType <- map["accountType"]
        accountCurrency <- map["accountCurrency"]
        accountNumber <- map["accountNumber"]
        accountBranchCode <- map["accountBranchCode"]
        accountStatus <- map["accountStatus"]
        accountCategoryCode <- map["accountCategoryCode"]
        accountTypeId <- map["accountTypeId"]
        actualBalance <- map["actualBalance"]
        accountStatusCode <- map["accountStatusCode"]
        accountCurrencyId <- map["accountCurrencyId"]
        accountBranch <- map["accountBranch"]
    }


}
