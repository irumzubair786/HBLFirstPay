//
//  DonationListModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 02/08/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct DonationListModelll : Mappable {
    var responsecode : Int?
    var data : [Donation]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
struct Donation : Mappable {
    var donationId : Int?
    var branchAddress : String?
    var branchCode : String?
    var donationAccountNo : String?
    var donationAccountTitle : String?
    var donationIban : String?
    var donationImd : String?
    var donationSwiftCode : String?
    var donationType : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        donationId <- map["donationId"]
        branchAddress <- map["branchAddress"]
        branchCode <- map["branchCode"]
        donationAccountNo <- map["donationAccountNo"]
        donationAccountTitle <- map["donationAccountTitle"]
        donationIban <- map["donationIban"]
        donationImd <- map["donationImd"]
        donationSwiftCode <- map["donationSwiftCode"]
        donationType <- map["donationType"]
        status <- map["status"]
    }

}
