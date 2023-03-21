//
//  GetdeialformanualSettlement.swift
//  First Pay
//
//  Created by Arsalan Amjad on 12/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper
struct getDetailsForManualSettlement : Mappable {
    var responsecode : Int?
    var datamanualsettlement : DataMS?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        datamanualsettlement <- map["data"]
        messages <- map["messages"]
    }

}
struct DataMS : Mappable {
    var principalAmount : Double?
    var markupAmount : Double?
    var chargesAmount : Double?
    var status : Int?
    var statusDescr : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        principalAmount <- map["principalAmount"]
        markupAmount <- map["markupAmount"]
        chargesAmount <- map["chargesAmount"]
        status <- map["status"]
        statusDescr <- map["statusDescr"]
    }


}
