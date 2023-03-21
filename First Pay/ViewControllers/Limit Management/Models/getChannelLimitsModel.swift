//
//  getChannelLimitsModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 23/12/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper
struct getChangeLimitModel : Mappable {
    var responsecode : Int?
    var limitmangemnetdata : LimitChange?
    var messages : String?
    var stringlist = [String]()
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        messages <- map["messages"]
        limitmangemnetdata <- map["data"]


    }

}
struct LimitChange : Mappable {
    var mB : [MB]?
    var aTM : [ATM]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        mB <- map["MB"]
        aTM <- map["ATM"]
    }

}
struct MB : Mappable {
    var limitId : String?
    var limitAmount : String?
    var channelCode : String?
    var channelName : String?
    var transactionName : String?
    var frequency : String?
    var key : String?
    var identifier : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        limitId <- map["limitId"]
        limitAmount <- map["limitAmount"]
        channelCode <- map["channelCode"]
        channelName <- map["channelName"]
        transactionName <- map["transactionName"]
        frequency <- map["frequency"]
        key <- map["key"]
        identifier <- map["identifier"]
    }

}
struct ATM : Mappable {
    var limitId : String?
    var limitAmount : String?
    var channelCode : String?
    var channelName : String?
    var transactionName : String?
    var frequency : String?
    var key : String?
    var identifier : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        limitId <- map["limitId"]
        limitAmount <- map["limitAmount"]
        channelCode <- map["channelCode"]
        channelName <- map["channelName"]
        transactionName <- map["transactionName"]
        frequency <- map["frequency"]
        key <- map["key"]
        identifier <- map["identifier"]
    }

}
