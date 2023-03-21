//
//  TitleFetchCommitteeModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 20/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class TitleFetchCommitteeModel: Mappable {
    
    var responsecode : Int?
    var messages : String?
    var WalletTitle : String?
    var WalletNumber : String?
   
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        WalletTitle <- map["data.WalletTitle"]
        WalletNumber <- map["data.WalletNumber"]
        
    }
}
