//
//  LiveChatModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 26/07/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//


import Foundation
import ObjectMapper

//struct livechatModel : Mappable {
//    init?(map: Map) {
//
//    }
//
//    var responsecode : Int?
//    var data : String?
//    var messages : String?
//
//
//    mutating func mapping(map: Map) {
//
//        responsecode <- map["responsecode"]
//        data <- map["data"]
//        messages <- map["messages"]
//    }
//
//}
//struct ChatLive: Mappable {
//    var recipient_id : String?
//    var text : String?
//    var buttons : [Buttons]?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        recipient_id <- map["recipient_id"]
//        text <- map["text"]
//        buttons <- map["buttons"]
//    }
//
//}
//struct Buttons : Mappable {
//    var payload : String?
//    var title : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        payload <- map["payload"]
//        title <- map["title"]
//    }
//
//}
struct livechatModel : Mappable {
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
