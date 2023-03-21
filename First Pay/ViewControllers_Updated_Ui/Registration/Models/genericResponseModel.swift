//
//  CustomerKycModel.swift
//  First Pay
//
//  Created by Irum Butt on 27/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct GenericResponseModel : Mappable {
    var responsecode : Int?
    var data : String?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
