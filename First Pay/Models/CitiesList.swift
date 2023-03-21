//
//  CitiesList.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 14/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class CitiesList: Mappable {
    
    var responsecode: Int?
    var messages:String?
    var citiesList : [SingleCity]?
    var stringCities = [String]()
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        citiesList <- map["data"]
        
        for aCity in self.citiesList! {
            stringCities.append(aCity.cityDescr!)
        }
    }
}

         
class SingleCity : Mappable {
    
    var cityID : Int?
    var cityDescr : String?
    var districtId : Int?
    var districtDescr : String?
    var provinceId : Int?
    var provinceDescr : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        cityID <- map["cityID"]
        cityDescr <- map ["cityDescr"]
        districtId <- map ["districtId"]
        districtDescr <- map ["districtDescr"]
        provinceId <- map ["provinceId"]
        provinceDescr <- map ["provinceDescr"]
       
    }
}
