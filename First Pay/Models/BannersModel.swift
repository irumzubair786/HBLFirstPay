//
//  BannersModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 26/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct BannersModel : Mappable {
    var responsecode : Int?
    var data : [Banners]?
    var messages : String?

    init?(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }


}


struct Banners : Mappable {
    var brandId : Int?
    var banner : String?
    var brandCode : String?
    var brandDescr : String?
    var createdate : String?
    var createuser : Int?
    var image : String?
    var lastupdatedate : String?
    var lastupdateuser : Int?
    var status : String?
    var updateindex : Int?
    var lkpCategory : String?
    var tblBrandLocations : String?
    var bannerDisplay : String?
    var tblDiscounts : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        brandId <- map["brandId"]
        banner <- map["banner"]
        brandCode <- map["brandCode"]
        brandDescr <- map["brandDescr"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        image <- map["image"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        lkpCategory <- map["lkpCategory"]
        tblBrandLocations <- map["tblBrandLocations"]
        bannerDisplay <- map["bannerDisplay"]
        tblDiscounts <- map["tblDiscounts"]
    }
}
