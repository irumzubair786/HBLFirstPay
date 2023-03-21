//
//  TransportSeatsModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 07/05/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct TransportSeatsModel : Mappable {
    var responsecode : Int?
    var seatsData : SeatsData?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        seatsData <- map["data"]
        messages <- map["messages"]
    }

}

struct SeatsData : Mappable {
    var seatplan : Seatplan?
    var totalSeats : String?
    var totalAvailable : String?
    var availableSeats : String?
    var totalOccupied : String?
    var occupiedSeatsMale : String?
    var occupiedSeatsFemale : String?
    var totalReserved : String?
    var reservedSeatsMale : String?
    var reservedSeatsFemale : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        seatplan <- map["seatplan"]
        totalSeats <- map["totalSeats"]
        totalAvailable <- map["totalAvailable"]
        availableSeats <- map["availableSeats"]
        totalOccupied <- map["totalOccupied"]
        occupiedSeatsMale <- map["occupiedSeatsMale"]
        occupiedSeatsFemale <- map["occupiedSeatsFemale"]
        totalReserved <- map["totalReserved"]
        reservedSeatsMale <- map["reservedSeatsMale"]
        reservedSeatsFemale <- map["reservedSeatsFemale"]
    }

}

struct Seatplan : Mappable {
    var rows : String?
    var cols : String?
    var seats : String?
  //  var seatplan : [Seatplan]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        rows <- map["rows"]
        cols <- map["cols"]
        seats <- map["seats"]
     //   seatplan <- map["seatplan"]
    }

}

