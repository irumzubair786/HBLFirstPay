//
//  GetTransportServiceModel.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 28/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetTransportServiceModel : Mappable {
    var responsecode : Int?
    var data : [SingleTransportData]?
    var messages : String?
    var stringServicesList = [String]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
        
        
        if let dataTransport = self.data{
            
            for aService in dataTransport {
                stringServicesList.append(aService.serviceName!)
            }
        }
        
        
    }
    
}

struct SingleTransportData : Mappable {
    var serviceId : String?
    var serviceName : String?
    var address : String?
    var phone : String?
    var cPhone : String?
    var status : String?
    var cod : String?
    var flexifare : String?
    var thumbnail : String?
    var background : String?
    var backgroundImg : String?
    var facilities : String?
    var careem : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        serviceId <- map["serviceId"]
        serviceName <- map["serviceName"]
        address <- map["address"]
        phone <- map["phone"]
        cPhone <- map["cPhone"]
        status <- map["status"]
        cod <- map["cod"]
        flexifare <- map["flexifare"]
        thumbnail <- map["thumbnail"]
        background <- map["background"]
        backgroundImg <- map["backgroundImg"]
        facilities <- map["facilities"]
        careem <- map["careem"]
    }
    
}
