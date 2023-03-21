//
//  InvitationFriendModel.swift
//  First Pay
//
//  Created by Arsalan Amjad on 02/02/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct InvitationFriendModel : Mappable {
    var responsecode : Int?
    var Invitedata : [inviteFriend]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        Invitedata <- map["data"]
        messages <- map["messages"]
    }

}

struct inviteFriend : Mappable {
    var friendInviteId : Int?
    var mobileNo : String?
    var name : String?
    var invitorName : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        friendInviteId <- map["friendInviteId"]
        mobileNo <- map["mobileNo"]
        name <- map["name"]
        invitorName <- map["invitorName"]
    }

}
