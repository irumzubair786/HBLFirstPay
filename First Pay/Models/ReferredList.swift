//
//  ReferredList.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 27/01/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//



import Foundation
import ObjectMapper

class RefferedList: Mappable {
    required init?(map: Map) {
    }
    
    var responsecode : Int?
    var data : [RefferList]?
    var messages : String?
    var stringlist = [String]()
    func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
        
        for refferlist in self.data!
        {
            (stringlist.append(refferlist.descr ?? "11"))
        }
        
    }

}

class RefferList: Mappable {
    required init?(map: Map) {
    }
    
    var referredById : Int?
    var code : String?
    var descr : String?
    var sortSeq : String?
    var status : String?

    func mapping(map: Map) {

        referredById <- map["referredById"]
        code <- map["code"]
        descr <- map["descr"]
        sortSeq <- map["sortSeq"]
        status <- map["status"]
    }

}

//class RefferedList: Mappable {
//
//
//    var responsecode : Int?
//    var messages:String?
//    var referredById : Int?
//    var code : String?
//    var descr : String?
//    var sortSeq : String?
//    var status : String?
//    var rfrlist : [RefferList]?
//    var stringlist = [String]()
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//        messages <- map["message"]
//        referredById <- map["referredById"]
//        code <- map["code"]
//        descr <- map["descr"]
//        sortSeq <- map["sortSeq"]
//        status <- map["status"]
//        rfrlist <- map["data"]
//
//        for refferlist in self.rfrlist!
//        {
//            (stringlist.append(refferlist.refferDescription ?? "11"))
//        }
//    }
//
//}
//
//
//class RefferList : Mappable {
//    var refferID : Int?
//    var responsecode : Int?
//    var refferDescription : String?
//    var data1 : [Data]?
//    var messages : String?
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        refferDescription <- map["refferDesc"]
//        refferID <- map["refferID"]
//        responsecode <- map["responsecode"]
//        data1 <- map["data"]
//        messages <- map["messages"]
//    }
//
//}
