//
//  HomeModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 05/11/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct HomeModel : Mappable {
    var responsecode : Int?
    var userData : [UserData]?
    var messages : String?


    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        userData <- map["data"]
        messages <- map["messages"]
    }

}

struct UserData : Mappable {
    
    var customerId : Int?
    var firstName : String?
    var lastName : String?
    var middleName : String?
    var accountId : Int?
    var accountAlias : String?
    var accountNo : String?
    var balanceDate : String?
    var currentBalance : Double?
    var accountTitile : String?
    var lasttransamt : Double?
    var dailyamtlmt : Double?
    var dailytranslmt : Double?
    var monthlyamtlmt : Double?
    var monthlytranslmt : Double?
    var yearlyamtlmt : Double?
    var yearlytranslmt : Double?
    var levelDescr : String?
    var accountPic : String?
    var token : String?
    var accountType : String?
    var insured : String?

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
        insured <- map["insured"]
    }

}
