//
//  InviteFriendModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 14/02/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct InviteFriendModelz : Mappable {
    var responsecode : Int?
    var dataInvitee : [InvitorModel]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        dataInvitee <- map["data"]
        messages <- map["messages"]
    }

}
struct InvitorModel : Mappable {
    var mobNo : String?
    var name : String?
    var isAccepted : String?
    var inVitorIncentiveAmount : Double?
    var isInvitorCredited : String?
    var isInviteeCredited : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        mobNo <- map["mobNo"]
        name <- map["name"]
        isAccepted <- map["isAccepted"]
        inVitorIncentiveAmount <- map["inVitorIncentiveAmount"]
        isInvitorCredited <- map["isInvitorCredited"]
        isInviteeCredited <- map["isInviteeCredited"]
    }

}
