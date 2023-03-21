//
//  LoginActionModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 14/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


//class LoginActionModel: Mappable {
//
//    var responsecode: Int?
//    var messages:String?
//    var customerId : Int?
//    var firstName:String?
//    var lastName:String?
//    var middleName:String?
//    var accountId : Int?
//    var accountAlias:String?
//    var accountNo:String?
//    var balanceDate:String?
//    var currentBalance : Int?
//    var accountTitile:String?
//    var lasttransamt:Int?
//    var dailyamtlmt:Int?
//    var dailytranslmt:Int?
//    var monthlyamtlmt:Int?
//    var monthlytranslmt:Int?
//    var yearlyamtlmt:Int?
//    var yearlytranslmt:Int?
//    var levelDescr:String?
//    var accountPic:String?
//    var token:String?
//
//
//    required init?(map: Map){ }
//
//    func mapping(map: Map) {
//
//        responsecode <- map["responsecode"]
//        messages <- map["messages"]
//        customerId <- map["data.customerId"]
//        firstName <- map["data.firstName"]
//        lastName <- map["data.lastName"]
//        middleName <- map["data.middleName"]
//        accountId <- map["data.accountId"]
//        accountAlias <- map["data.accountAlias"]
//        accountNo <- map["data.accountNo"]
//        balanceDate <- map["data.balanceDate"]
//        currentBalance <- map["data.currentBalance"]
//        accountTitile <- map["data.accountTitile"]
//        lasttransamt <- map["data.lasttransamt"]
//        dailyamtlmt <- map["data.dailyamtlmt"]
//        dailytranslmt <- map["data.dailytranslmt"]
//        monthlyamtlmt <- map["data.monthlyamtlmt"]
//        monthlytranslmt <- map["data.monthlytranslmt"]
//        yearlyamtlmt <- map["data.yearlyamtlmt"]
//        yearlytranslmt <- map["data.yearlytranslmt"]
//        levelDescr <- map["data.levelDescr"]
//        accountPic <- map["data.accountPic"]
//        token <- map["data.token"]
//
//
//    }
//}


struct LoginActionModel : Mappable {
    var responsecode : Int?
    var userData : LoginUserData?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        userData <- map["data"]
        messages <- map["messages"]
    }

}

struct LoginUserData : Mappable {
    var token : String?
    var customerHomeScreens : [CustomerHomeScreens]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        token <- map["token"]
        customerHomeScreens <- map["customerHomeScreens"]
    }

}

struct CustomerHomeScreens : Mappable {
    
    var customerId : Int?
    var firstName : String?
    var lastName : String?
    var middleName : String?
    var accountId : Int?
    var accountAlias : String?
    var accountNo : String?
    var balanceDate : String?
    var currentBalance : Int?
    var accountTitile : String?
    var lasttransamt : Int?
    var dailyamtlmt : Int?
    var dailytranslmt : Int?
    var monthlyamtlmt : Int?
    var monthlytranslmt : Int?
    var yearlyamtlmt : Int?
    var yearlytranslmt : Int?
    var levelDescr : String?
    var accountPic : String?
    var token : String?
    var accountType : String?
    var checkEmailVerified : String?
    var nanoloan : String?
    var checkEmail : String?
    var riskProfile : String?
 
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        customerId <- map["customerId"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        middleName <- map["middleName"]
        accountId <- map["accountId"]
        accountAlias <- map["accountAlias"]
        accountNo <- map["accountNo"]
        balanceDate <- map["balanceDate"]
        currentBalance <- map["currentBalance"]
        accountTitile <- map["accountTitile"]
        lasttransamt <- map["lasttransamt"]
        dailyamtlmt <- map["dailyamtlmt"]
        dailytranslmt <- map["dailytranslmt"]
        monthlyamtlmt <- map["monthlyamtlmt"]
        monthlytranslmt <- map["monthlytranslmt"]
        yearlyamtlmt <- map["yearlyamtlmt"]
        yearlytranslmt <- map["yearlytranslmt"]
        levelDescr <- map["levelDescr"]
        accountPic <- map["accountPic"]
        token <- map["token"]
        accountType <- map["accountType"]
        nanoloan <- map["nanoloan"]
        checkEmailVerified <- map["checkEmailVerified"]
        checkEmail <- map["checkEmail"]
        riskProfile <- map["riskProfile"]
//        insured <- map["insured"]
    }

}



