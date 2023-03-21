////
////  CompleteAllDiscountList.swift
////  First Pay
////
////  Created by Syed Uzair Ahmed on 27/05/2021.
////  Copyright © 2021 FMFB Pakistan. All rights reserved.
////
//
//import Foundation
//import ObjectMapper
//
//struct Json4Swift_Base : Mappable {
//    var responsecode : Int?
//    var data : [Data]?
//    var messages : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        responsecode <- map["responsecode"]
//        data <- map["data"]
//        messages <- map["messages"]
//    }
//
//}
//struct Data : Mappable {
//    var discountsId : Int?
//    var createdate : String?
//    var createuser : Int?
//    var discountDetails : String?
//    var discountPercentage : String?
//    var lastupdatedate : String?
//    var lastupdateuser : String?
//    var updateindex : String?
//    var website : String?
//    var fromDate : Int?
//    var toDate : Int?
//    var tblBrand : TblBrand?
//    var tblBrandLocation : TblBrandLocation?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        discountsId <- map["discountsId"]
//        createdate <- map["createdate"]
//        createuser <- map["createuser"]
//        discountDetails <- map["discountDetails"]
//        discountPercentage <- map["discountPercentage"]
//        lastupdatedate <- map["lastupdatedate"]
//        lastupdateuser <- map["lastupdateuser"]
//        updateindex <- map["updateindex"]
//        website <- map["website"]
//        fromDate <- map["fromDate"]
//        toDate <- map["toDate"]
//        tblBrand <- map["tblBrand"]
//        tblBrandLocation <- map["tblBrandLocation"]
//    }
//
//}
//struct LkpCity : Mappable {
//    var cityId : Int?
//    var cityCode : String?
//    var cityDescr : String?
//    var createdate : Int?
//    var createuser : Int?
//    var lastupdatedate : Int?
//    var lastupdateuser : Int?
//    var sortSeq : Int?
//    var status : String?
//    var updateindex : Int?
//    var lkpDistrict : String?
//    var lkpRegion : String?
//    var tblCustomers : String?
//    var tblBrandLocations : String?
//    var lkpBranches : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        cityId <- map["cityId"]
//        cityCode <- map["cityCode"]
//        cityDescr <- map["cityDescr"]
//        createdate <- map["createdate"]
//        createuser <- map["createuser"]
//        lastupdatedate <- map["lastupdatedate"]
//        lastupdateuser <- map["lastupdateuser"]
//        sortSeq <- map["sortSeq"]
//        status <- map["status"]
//        updateindex <- map["updateindex"]
//        lkpDistrict <- map["lkpDistrict"]
//        lkpRegion <- map["lkpRegion"]
//        tblCustomers <- map["tblCustomers"]
//        tblBrandLocations <- map["tblBrandLocations"]
//        lkpBranches <- map["lkpBranches"]
//    }
//
//}
//struct TblBrand : Mappable {
//    var brandId : Int?
//    var banner : String?
//    var brandCode : String?
//    var brandDescr : String?
//    var createdate : String?
//    var createuser : Int?
//    var image : String?
//    var lastupdatedate : String?
//    var lastupdateuser : Int?
//    var status : String?
//    var updateindex : Int?
//    var lkpCategory : String?
//    var tblBrandLocations : String?
//    var bannerDisplay : String?
//    var tblDiscounts : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        brandId <- map["brandId"]
//        banner <- map["banner"]
//        brandCode <- map["brandCode"]
//        brandDescr <- map["brandDescr"]
//        createdate <- map["createdate"]
//        createuser <- map["createuser"]
//        image <- map["image"]
//        lastupdatedate <- map["lastupdatedate"]
//        lastupdateuser <- map["lastupdateuser"]
//        status <- map["status"]
//        updateindex <- map["updateindex"]
//        lkpCategory <- map["lkpCategory"]
//        tblBrandLocations <- map["tblBrandLocations"]
//        bannerDisplay <- map["bannerDisplay"]
//        tblDiscounts <- map["tblDiscounts"]
//    }
//
//}
//struct TblBrandLocation : Mappable {
//    var brandLocationId : Int?
//    var address : String?
//    var createdate : String?
//    var createuser : Int?
//    var image : String?
//    var lastupdatedate : String?
//    var lastupdateuser : Int?
//    var latitude : Double?
//    var longitude : Double?
//    var status : String?
//    var updateindex : Int?
//    var lkpCity : LkpCity?
//    var tblBrand : String?
//    var tblDiscounts : String?
//    var contactNo : String?
//    var email : String?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        brandLocationId <- map["brandLocationId"]
//        address <- map["address"]
//        createdate <- map["createdate"]
//        createuser <- map["createuser"]
//        image <- map["image"]
//        lastupdatedate <- map["lastupdatedate"]
//        lastupdateuser <- map["lastupdateuser"]
//        latitude <- map["latitude"]
//        longitude <- map["longitude"]
//        status <- map["status"]
//        updateindex <- map["updateindex"]
//        lkpCity <- map["lkpCity"]
//        tblBrand <- map["tblBrand"]
//        tblDiscounts <- map["tblDiscounts"]
//        contactNo <- map["contactNo"]
//        email <- map["email"]
//    }
//
//}
