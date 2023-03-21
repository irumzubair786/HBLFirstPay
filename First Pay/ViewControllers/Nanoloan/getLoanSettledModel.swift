//
//  getLoanSettledModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 09/11/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//


import Foundation
import ObjectMapper

struct getLoanSettledModel : Mappable {
    var responsecode : Int?
    var MyLoan : [MyLoanModel]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        MyLoan <- map["data"]
        messages <- map["messages"]
    }

}
struct MyLoanModel : Mappable {
    var nl_disbursement_id : Int?
    var loan_amount : Int?
    var start_date : String?
    var installment_amount : Double?
    var loan_no : String?
    var markup_rate : Int?
    var total_installments : Int?
    var end_date : String?
    var total_markup_amount : Int?
    var account_no : String?
    var account_title : String?
    var nl_product_descr : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        nl_disbursement_id <- map["nl_disbursement_id"]
        loan_amount <- map["loan_amount"]
        start_date <- map["start_date"]
        installment_amount <- map["installment_amount"]
        loan_no <- map["loan_no"]
        markup_rate <- map["markup_rate"]
        total_installments <- map["total_installments"]
        end_date <- map["end_date"]
        total_markup_amount <- map["total_markup_amount"]
        account_no <- map["account_no"]
        account_title <- map["account_title"]
        nl_product_descr <- map["nl_product_descr"]
    }

}
