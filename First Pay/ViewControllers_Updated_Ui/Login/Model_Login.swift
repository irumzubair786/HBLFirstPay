//
//  Model_Login.swift
//  First Pay
//
//  Created by Irum Butt on 14/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper
struct login : Mappable {
    var responsecode : Int?
    var data : DataUser?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
struct DataUser : Mappable {
    var token : String?
    var customerHomeScreens : [HomeScreen]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        token <- map["token"]
        customerHomeScreens <- map["customerHomeScreens"]
    }

}
struct HomeScreen : Mappable {
    var customerId : Int?
    var firstName : String?
    var lastName : String?
    var middleName : String?
    var accountId : Int?
    var accountAlias : String?
    var accountNo : String?
    var balanceDate : String?
    var currentBalance : String?
    var accountTitile : String?
    var lasttransamt : String?
    var dailyamtlmt : String?
    var dailytranslmt : String?
    var monthlyamtlmt : String?
    var monthlytranslmt : String?
    var yearlyamtlmt : String?
    var yearlytranslmt : String?
    var levelDescr : String?
    var accountPic : String?
    var token : String?
    var accountType : String?
    var insured : String?
    var emailVerified : String?

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
        emailVerified <- map["emailVerified"]
    }

}
