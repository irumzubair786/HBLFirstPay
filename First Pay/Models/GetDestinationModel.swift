//
//  GetDestinationModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 28/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetDestinationModel : Mappable {
    var responsecode : Int?
    var data : [DestinationData]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
        
        
    }

}

struct DestinationData : Mappable {
    var destinationCityId : String?
    var destinationCityName : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        destinationCityId <- map["destinationCityId"]
        destinationCityName <- map["destinationCityName"]
    }

}
