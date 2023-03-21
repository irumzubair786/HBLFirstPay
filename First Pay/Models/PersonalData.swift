//
//  PersonalData.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 14/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class PersonalData: Mappable {
    
    var responsecode: Int?
    var messages:String?
    var customerId : Int?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        customerId <- map["data.customerId"]
    }
}
