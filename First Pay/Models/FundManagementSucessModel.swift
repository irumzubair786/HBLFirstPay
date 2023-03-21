//
//  FundManagementSucessModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 05/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper



class FundManagementSucessModel: Mappable {
    
    var responsecode: Int?
    var messages: String?
    var authIdResponse : String?
    var transDate : String?
    var responseDescr : String?
    var responseCode : String?
    
    
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        authIdResponse <- map["data.authIdResponse"]
        transDate <- map["data.transDate"]
        responseDescr <- map["data.responseDescr"]
        responseCode <- map["data.responseCode"]
        
    }
}
