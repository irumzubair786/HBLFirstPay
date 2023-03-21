//
//  Mothername.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 14/04/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


//class   GetVerifyOTp : Mappable {
  //  var responsecode : Int?
  //  var motherdata : [UpdateModelAfterMotherName]?
  //  var stringlist = [String]()
  //  var messages : String?

  //  required init?(map: Map) {
//
  //  }

   // func mapping(map: Map) {

     //   responsecode <- map["responsecode"]
     //   motherdata <- map["data"]
       // messages <- map["messages"]
        
        
        
  //for motherlist in self.motherdata ?? []
        //{
           // (stringlist.append(motherlist.motherNamesList![0] ?? ""))
        //}
    //}

//}
//import Foundation
//// MARK: - GetVerifyOTp
//struct GetVerifyOTp: Codable {
//    let responsecode: Int
//    let data: DataClass
//    let messages: String
//}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//    let firstName, lastName: String
//    let motherNamesList: [String]
//    let middleName: String
//}
//
//
//class UpdateModelAfterMotherName: Mappable {
//    var firstName : String?
//    var lastName : String?
//    var motherNamesList : [String]?
//    var middleName : String?
//
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//
//        firstName <- map["firstName"]
//        lastName <- map["lastName"]
//        motherNamesList <- map["motherNamesList"]
//        middleName <- map["middleName"]
//    }
//}




struct GetVerifyOTp : Mappable {
    var responsecode : Int?
    var datalist: UpdateMotherName!
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        datalist <- map["data"]
        messages <- map["messages"]
    }

}
struct UpdateMotherName : Mappable {
    var firstName : String?
    var lastName : String?
    var motherNamesList : [String]?
    var middleName : String?

    
    init?(map: Map) {
//        firstName <- map["firstName"]
//        lastName <- map["lastName"]
//        motherNamesList <- map["motherNamesList"]
//        middleName <- map["middleName"]
    }

    mutating func mapping(map: Map) {

        firstName <- map["firstName"]
        lastName <- map["lastName"]
        motherNamesList <- map["motherNamesList"]
        middleName <- map["middleName"]
    }

}
