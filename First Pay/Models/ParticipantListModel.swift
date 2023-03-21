////
////  ParticipantListModel.swift
////  First Wallet
////
////  Created by Syed Uzair Ahmed on 14/07/2020.
////  Copyright © 2020 FMFB Pakistan. All rights reserved.
////
//
//import Foundation
//import ObjectMapper
//
struct ParticipantListModel : Mappable {
    var responsecode : Int?
    var participantData : ParticipantData?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        participantData <- map["data"]
        messages <- map["messages"]
    }

}


struct ParticipantData : Mappable {
    var members : [Members]?
    var totalParticipants : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        members <- map["members"]
        totalParticipants <- map["totalParticipants"]
    }

}



struct Members : Mappable {

    var committeeDetailId : Int?
    var committeeReceived : String?
    var createdate : Int?
    var createuser : Int?
    var drawSequence : Int?
    var initiator : String?
    var installmentsPaid : String?
    var installmentsUnpaid : String?
    var lastupdatedate : Int?
    var lastupdateuser : Int?
    var requestStatus : String?
    var updateindex : Int?
    var tblAccount : String?
    var tblCommitteeHead : String?
    var participantAccountNo : String?
    var participantAccountTitle : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        committeeDetailId <- map["committeeDetailId"]
        committeeReceived <- map["committeeReceived"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        drawSequence <- map["drawSequence"]
        initiator <- map["initiator"]
        installmentsPaid <- map["installmentsPaid"]
        installmentsUnpaid <- map["installmentsUnpaid"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        requestStatus <- map["requestStatus"]
        updateindex <- map["updateindex"]
        tblAccount <- map["tblAccount"]
        tblCommitteeHead <- map["tblCommitteeHead"]
        participantAccountNo <- map["participantAccountNo"]
        participantAccountTitle <- map["participantAccountTitle"]
    }

}

//
//// update model
//
import Foundation
import ObjectMapper

struct ParticipantModelUpdate : Mappable {
    var responsecode : Int?
    var dataobj : [Dataparticipant]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        dataobj <- map["data"]
        messages <- map["messages"]
    }

}


struct Dataparticipant : Mappable {
    var committeeDetailId : Int?
    var committeeReceived : String?
    var createdate : Int?
    var createuser : Int?
    var drawSequence : Int?
    var initiator : String?
    var installmentsPaid : String?
    var installmentsUnpaid : String?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var requestStatus : String?
    var updateindex : String?
    var tblAccount : String?
    var tblCommitteeHead : String?
    var participantAccountNo : String?
    var participantAccountTitle : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        committeeDetailId <- map["committeeDetailId"]
        committeeReceived <- map["committeeReceived"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        drawSequence <- map["drawSequence"]
        initiator <- map["initiator"]
        installmentsPaid <- map["installmentsPaid"]
        installmentsUnpaid <- map["installmentsUnpaid"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        requestStatus <- map["requestStatus"]
        updateindex <- map["updateindex"]
        tblAccount <- map["tblAccount"]
        tblCommitteeHead <- map["tblCommitteeHead"]
        participantAccountNo <- map["participantAccountNo"]
        participantAccountTitle <- map["participantAccountTitle"]
    }

}
