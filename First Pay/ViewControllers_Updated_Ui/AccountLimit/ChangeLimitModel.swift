//
//  ChangeLimitModel.swift
//  First Pay
//
//  Created by Irum Butt on 14/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
//
//struct ChangeLimitModel : Mappable {
//    var responsecode : Int?
//    var data : String?
//    var responseblock : String?
//    var messages : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        responsecode <- map["responsecode"]
//        data <- map["data"]
//        responseblock <- map["responseblock"]
//        messages <- map["messages"]
//    }
//
//}
struct ChangeLimitModel: Codable {
    let responsecode: Int?
    let data, responseblock: JSONNull?
    let messages: String?
}

// MARK: - Encode/decode helpers

//class JSONNull: Codable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
