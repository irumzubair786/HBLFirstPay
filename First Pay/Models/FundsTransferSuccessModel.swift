//
//  FundsTransferSuccessModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/12/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

class FundsTransferSuccessModel : Mappable {
    var authIdResponse : String?
    var transDate : String?
    var responseDescr : String?
    var responseCode : Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        authIdResponse <- map["authIdResponse"]
        transDate <- map["transDate"]
        responseDescr <- map["responseDescr"]
        responseCode <- map["responseCode"]
    }
}



