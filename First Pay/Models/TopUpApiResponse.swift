//
//  TopUpApiResponse.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 12/02/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

class TopUpApiResponse : Mappable {
    var responsecode : Int?
    var data : TopUpInitiateModel?
    var messages : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
