//
//  TopUpInitiateModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 12/02/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

class TopUpInitiateModel : Mappable {
    var utilityBillCompany : String?
    var oTPREQ : String?
    var lastTransactions : [LastTransactionsResponse]?
    var utilityConsumerNo : String?
    var stringlist = [String]()

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        utilityBillCompany <- map["utilityBillCompany"]
        oTPREQ <- map["OTPREQ"]
        lastTransactions <- map["lastTransactions"]
        utilityConsumerNo <- map["utilityConsumerNo"]
        
//       
        
    }

}
