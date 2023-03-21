//
//  MoviesListModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 19/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class MoviesListModel: Mappable {
    
    var movies: [SingleMovie]?
    var responsecode: Int?
    var message:String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        message <- map["message"]
        movies <- map["data"]
        
        
    }
}


class SingleMovie : Mappable {
    
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
 
    }
}
