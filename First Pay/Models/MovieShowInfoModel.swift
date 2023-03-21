//
//  MovieShowInfoModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 19/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class MovieShowInfoModel: Mappable {
    
    var responsecode: Int?
    var messages:String?
    var movieShows: [SingleMovieShow]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        movieShows <- map["data"]
    }
}


class SingleMovieShow : Mappable {
    
    var movie_id : String?
    var imdb_id : String?
    var title : String?
    var genre : String?
    var language : String?
    var director : String?
    var producer : String?
    var release_date : String?
    var cast : String?
    var ranking : String?
    var length : String?
    var thumbnail : String?
    var music_director : String?
    var country : String?
    var synopsis : String?
    var details : String?
    var trailer_link : String?
    var date : String?
    var booking_type : String?
    var points : String?
    var update_date : String?
    var close_date : String?
    var status : String?
    var movieShowsDetail : [SingleShowInfo]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        movie_id <- map["movie_id"]
        imdb_id <- map ["imdb_id"]
        title <- map ["title"]
        genre <- map ["genre"]
        language <- map ["language"]
        director <- map ["director"]
        producer <- map ["producer"]
        release_date <- map ["release_date"]
        cast <- map ["cast"]
        ranking <- map ["ranking"]
        length <- map ["length"]
        thumbnail <- map ["thumbnail"]
        music_director <- map ["music_director"]
        country <- map ["country"]
        synopsis <- map ["synopsis"]
        details <- map ["details"]
        trailer_link <- map ["trailer_link"]
        date <- map ["date"]
        booking_type <- map ["booking_type"]
        points <- map ["points"]
        update_date <- map ["update_date"]
        close_date <- map ["close_date"]
        status <- map ["status"]
        movieShowsDetail <- map ["movieShowsDetail"]

        
    }
}

class SingleShowInfo : Mappable {
    
    var city_id : String?
    var city_name : String?
    var show_id : String?
    var showMovieId : String?
    var showCenimaId : String?
    var cinemaName : String?
    var hallId : String?
    var hallName : String?
    var areaCode : String?
    var showDate : String?
    var showStartTime : String?
    var showTime : String?
    var ticketPrice : String?
    var handlingCharges : Double?
    var easypaisaCharges : String?
    var houseFull : String?
    var eticket : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        city_id <- map["city_id"]
        city_name <- map ["city_name"]
        show_id <- map ["show_id"]
        showMovieId <- map ["showMovieId"]
        showCenimaId <- map ["showCenimaId"]
        cinemaName <- map ["cinemaName"]
        hallId <- map ["hallId"]
        hallName <- map ["hallName"]
        areaCode <- map ["areaCode"]
        showDate <- map ["showDate"]
        showStartTime <- map ["showStartTime"]
        showTime <- map ["showTime"]
        ticketPrice <- map ["ticketPrice"]
        handlingCharges <- map ["handlingCharges"]
        easypaisaCharges <- map ["easypaisaCharges"]
        houseFull <- map ["houseFull"]
        eticket <- map ["eticket"]
 
    }
}
