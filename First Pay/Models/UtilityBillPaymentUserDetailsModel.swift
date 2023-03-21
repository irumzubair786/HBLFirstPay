//
//  UtilityBillPaymentUserDetailsModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 17/01/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class UtilityBillPaymentUserDetailsModel: Mappable {
    
    var responsecode: Int?
    var messages:String?
    var duesDetailId:Int?
    var registrationNo:String?
    var fullName:String?
    var fatherName:String?
    var dueDate:String?
    var totalAmountl:Int?
    var paidAmount:Int?
    var remainingAmount:String?
    var amountAfterDD:Int?
    var remAmountAftrDD:String?
    var status:String?
    var token:String?
    var authIdResponse:String?
    var transDate:String?
    var responseDescr:String?
    var responseCode:String?
    
    var billingMonth:String?
    var totalAmountPayableWithinDueDate:String?
    var OTPREQ:String?
    var transactionLogId:String?
    var utilityCompanyId:String?
    var paymentDueDate:String?
    var subscriberName:String?
    var billStatus:String?
    var actualDueAmount:String?
    var totalAmountPayableAfterDueDate:String?
    var additionalData:String?
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        duesDetailId <- map["data.duesDetailId"]
        registrationNo <- map["data.registrationNo"]
        fullName <- map["data.fullName"]
        fatherName <- map["data.fatherName"]
        dueDate <- map["data.dueDate"]
        totalAmountl <- map["data.totalAmountl"]
        paidAmount <- map["data.paidAmount"]
        remainingAmount <- map["data.remainingAmount"]
        amountAfterDD <- map["data.amountAfterDD"]
        remAmountAftrDD <- map["data.remAmountAftrDD"]
        status <- map["data.status"]
        token <- map["data.token"]
        
        authIdResponse <- map["data.authIdResponse"]
        transDate <- map["data.transDate"]
        responseDescr <- map["data.responseDescr"]
        responseCode <- map["data.responseCode"]
        
        
        billingMonth <- map["data.billingMonth"]
        totalAmountPayableWithinDueDate <- map["data.totalAmountPayableWithinDueDate"]
        OTPREQ <- map["data.OTPREQ"]
        transactionLogId <- map["data.transactionLogId"]
        utilityCompanyId <- map["data.utilityCompanyId"]
        paymentDueDate <- map["data.paymentDueDate"]
        subscriberName <- map["data.subscriberName"]
        billStatus <- map["data.billStatus"]
        actualDueAmount <- map["data.actualDueAmount"]
        totalAmountPayableAfterDueDate <- map["data.totalAmountPayableAfterDueDate"]
        additionalData <- map["data.additionalData"]
    
        
    }
}
