//
//  MoviesSeatModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 18/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


struct MoviesSeatModel : Mappable {
    var responsecode : Int?
    var message : String?
    var data : DataMovies?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        message <- map["message"]
        data <- map["data"]
    }
    

    
}

class DataMovies: Mappable {
    
    var showId : String?
    var hallId : String?
    var hallName : String?
    var rows : String?
    var cols : String?
    var movieShowHallSeatPlans : [Seat_plan]?
    var booked_seats : [String]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        showId <- map["showId"]
        hallId <- map["hallId"]
        hallName <- map["hallName"]
        rows <- map["rows"]
        cols <- map["cols"]
        movieShowHallSeatPlans <- map["movieShowHallSeatPlans"]
        booked_seats <- map["booked_seats"]
        
    }
}

class Seat_plan : Mappable {
    
    var row : String?
    var place : String?
    var movieShowHallSeatsDetail : [Seats]?
    
    required init?(map: Map){ }
    
   func mapping(map: Map) {
        
        row <- map["row"]
        place <- map["place"]
        movieShowHallSeatsDetail <- map["movieShowHallSeatsDetail"]
    }
}

class Seats : Mappable {
    var seatId : String?
    var seatRowName : String?
    var seatNumber : String?
    var seatType : String?
    var status : Int?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        seatId <- map["seatId"]
        seatRowName <- map["seatRowName"]
        seatNumber <- map["seatNumber"]
        seatType <- map["seatType"]
        status <- map["status"]
    }
}
