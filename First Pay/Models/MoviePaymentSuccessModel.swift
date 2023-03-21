//
//  MoviePaymentSuccessModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 26/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class  MoviePaymentSuccessModel: Mappable {
    
    var responsecode: Int?
    var messages:String?
    
    
    var bookmeResponseId:Int?
    var address:String?
    var bookingDate:String?
    var bookingId:String?
    var bookingReference:String?
    var bookingTime:String?
    var bookmeBookingId:String?
    var cinema:String?
    var city:String?
    var createdate:String?
    var createuser:Int?
    var discount:Int?
    var email:String?
    var handlingCharges:Int?
    var lastupdatedate:String?
    var lastupdateuser:String?
    var movie:String?
    var msg:String?
    var name:String?
    var netAmount:Int?
    var orderrefnumber:String?
    var orders:String?
    var phone:String?
    var screen:String?
    var seatNumbers:String?
    var seatPreference:String?
    var seats:Int?
    var status:String?
    var totalAmount:Int?
    var updateindex:String?
    var tblBookmeRequest:String?
    
    
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        
        bookmeResponseId <- map["data.bookmeResponseId"]
        address <- map["data.address"]
        bookingDate <- map["data.bookingDate"]
        bookingId <- map["data.bookingId"]
        bookingReference <- map["data.bookingReference"]
        bookingTime <- map["data.bookingTime"]
        bookmeBookingId <- map["data.bookmeBookingId"]
        cinema <- map["data.cinema"]
        city <- map["data.city"]
        createdate <- map["data.createdate"]
        createuser <- map["data.createuser"]
        discount <- map["data.discount"]
        email <- map["data.email"]
        handlingCharges <- map["data.handlingCharges"]
        lastupdatedate <- map["data.lastupdatedate"]
        lastupdateuser <- map["data.lastupdateuser"]
        movie <- map["data.movie"]
        msg <- map["data.msg"]
        name <- map["data.name"]
        netAmount <- map["data.netAmount"]
        orderrefnumber <- map["data.orderrefnumber"]
        orders <- map["data.orders"]
        phone <- map["data.phone"]
        screen <- map["data.screen"]
        seatNumbers <- map["data.seatNumbers"]
        seatPreference <- map["data.seatPreference"]
        seats <- map["data.seats"]
        status <- map["data.status"]
        totalAmount <- map["data.totalAmount"]
        updateindex <- map["data.updateindex"]
        tblBookmeRequest <- map["data.tblBookmeRequest"]
        
        
        
    }
}
