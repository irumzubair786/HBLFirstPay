//
//  GenericResponse.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class GenericResponse: Mappable {
    
    var responsecode : Int?
    var messages : String?
    var token : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        token <- map["data.token"]
    
    }
}
