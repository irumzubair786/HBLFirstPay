//
//  UtilityBillPaymentSuccessModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 29/01/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class UtilityBillPaymentSuccessModel  : Mappable {
    
    var responsecode: Int?
    var messages:String?
    var duesDetailId:Int?
    var registrationNo:String?
    var fullName:String?
    var fatherName:String?
    var dueDate:String?
    var totalAmountl:Int?
    var paidAmount:Int?
    var remainingAmount:Int?
    var amountAfterDD:Int?
    var remAmountAftrDD:Int?
    var status:String?
    var token:String?
    
    var responseDescr:String?
    var transDate:String?
    var responseCode:String?
    var authIdResponse:String?
    
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
        
        responseDescr <- map["data.responseDescr"]
        transDate <- map["data.transDate"]
        responseCode <- map["data.responseCode"]
        authIdResponse <- map["data.authIdResponse"]
        
    }
}
