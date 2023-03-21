//
//  GetBeneficiaryTitleModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 25/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class GetBeneficiaryTitleModel: Mappable {
    
    var responsecode: Int?
    var messages: String?
    
    var lng: String?
    var accountTitle : String?
    var accountNo: String?
    var iban : String?
    var imei: String?
    var cnic: String?
    var responseDescr: String?
    var lat : String?
    var accountIMD:String?
    var responseCode:String?
    var OTPREQ: String?
   
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        
        lng <- map["data.lng"]
        accountTitle <- map["data.accountTitle"]
        accountNo <- map["data.accountNo"]
        iban <- map["data.iban"]
        imei <- map["data.imei"]
        cnic <- map["data.cnic"]
        responseDescr <- map["data.responseDescr"]
        lat <- map["data.lat"]
        accountIMD <- map["data.accountIMD"]
        responseCode <- map["data.responseCode"]
        OTPREQ <- map["data.OTPREQ"]
       
    }
}
