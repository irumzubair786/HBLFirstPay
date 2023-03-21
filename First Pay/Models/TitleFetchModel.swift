//
//  TitleFetchModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 16/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class TitleFetchModel: Mappable {
    
    var responsecode: Int?
    var messages:String?
    var accountTitle : String?
    var accountNo : String?
   
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        accountTitle <- map["data.accountTitle"]
        accountNo <- map["data.accountNo"]
        
    }
}
