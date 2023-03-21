//
//  WeatherModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 24/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherModel: Mappable {
    
    var wx_desc:String?
    var temp_c:Int?

    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        wx_desc <- map["wx_desc"]
        temp_c <- map["temp_c"]
    }
}
