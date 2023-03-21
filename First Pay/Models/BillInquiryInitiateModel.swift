//
//  BillinuiryInitiateModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 12/02/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

class BillInquiryInitiateModel : Mappable {
    var billingMonth : String?
    var totalAmountPayableWithinDueDate : String?
    var oTPREQ : String?
    var transactionLogId : String?
    var utilityCompanyId : String?
    var responseDescr : String?
    var responseCode : String?
    var paymentDueDate : String?
    var authIdResponse : String?
    var subscriberName : String?
    var billStatus : String?
    var actualDueAmount : String?
    var lastTransactions : [LastTransactionsResponse]?
    var totalAmountPayableAfterDueDate : String?
    var additionalData : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        billingMonth <- map["billingMonth"]
        totalAmountPayableWithinDueDate <- map["totalAmountPayableWithinDueDate"]
        oTPREQ <- map["OTPREQ"]
        transactionLogId <- map["transactionLogId"]
        utilityCompanyId <- map["utilityCompanyId"]
        responseDescr <- map["responseDescr"]
        responseCode <- map["responseCode"]
        paymentDueDate <- map["paymentDueDate"]
        authIdResponse <- map["authIdResponse"]
        subscriberName <- map["subscriberName"]
        billStatus <- map["billStatus"]
        actualDueAmount <- map["actualDueAmount"]
        lastTransactions <- map["lastTransactions"]
        totalAmountPayableAfterDueDate <- map["totalAmountPayableAfterDueDate"]
        additionalData <- map["additionalData"]
    }

}
