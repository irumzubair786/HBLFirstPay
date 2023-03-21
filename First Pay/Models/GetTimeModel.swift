//
//  GetTimeModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 28/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetTimeModel : Mappable {
    var responsecode : Int?
    var data : [TimeData]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
struct TimeData : Mappable {
    var departure_city_id : String?
    var departure_city_name : String?
    var arrival_city_id : String?
    var arrival_city_name : String?
    var service_id : String?
    var service_name : String?
    var time_id : String?
    var schedule_id : String?
    var route_id : String?
    var time : String?
    var arrtime : String?
    var original_fare : String?
    var fare : String?
    var handling_charges : String?
    var easypaisa_charges : String?
    var thumb : String?
    var seats : String?
    var busname : String?
    var btype_id : String?
    var bustype : String?
    var available_seats : String?
    var seat_info : String?
    var facilities : [Facilities]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        departure_city_id <- map["departure_city_id"]
        departure_city_name <- map["departure_city_name"]
        arrival_city_id <- map["arrival_city_id"]
        arrival_city_name <- map["arrival_city_name"]
        service_id <- map["service_id"]
        service_name <- map["service_name"]
        time_id <- map["time_id"]
        schedule_id <- map["schedule_id"]
        route_id <- map["route_id"]
        time <- map["time"]
        arrtime <- map["arrtime"]
        original_fare <- map["original_fare"]
        fare <- map["fare"]
        handling_charges <- map["handling_charges"]
        easypaisa_charges <- map["easypaisa_charges"]
        thumb <- map["thumb"]
        seats <- map["seats"]
        busname <- map["busname"]
        btype_id <- map["btype_id"]
        bustype <- map["bustype"]
        available_seats <- map["available_seats"]
        seat_info <- map["seat_info"]
        facilities <- map["facilities"]
    }

}
struct Facilities : Mappable {
    var id : String?
    var name : String?
    var img : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        img <- map["img"]
    }

}
