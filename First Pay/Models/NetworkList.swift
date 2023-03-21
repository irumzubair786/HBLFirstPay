//
//  NetworkList.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 13/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import ObjectMapper


class NewtorkList: Mappable {
    
    var responsecode: Int?
    var messages:String?
    var networkList : [SingleNetwork]?
    var stringNetworks = [String]()

    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        responsecode <- map["responsecode"]
        messages <- map["messages"]
        networkList <- map["data"]
        
        for aNetwork in self.networkList! {
            stringNetworks.append(aNetwork.networkDescr!)
        }
    }
}

class SingleNetwork : Mappable {
    
    var networkId : Int?
    var createdate : Int?
    var createuser : Int?
    var lastupdatedate : String?
    var lastupdateuser : String?
    var networkCode : String?
    var networkDescr : String?
    var sortSeq : Int?
    var status : String?
    var updateindex : String?
 
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        networkId <- map["networkId"]
        createdate <- map ["createdate"]
        createuser <- map ["createuser"]
        lastupdatedate <- map ["lastupdatedate"]
        lastupdateuser <- map ["lastupdateuser"]
        networkCode <- map ["networkCode"]
        networkDescr <- map ["networkDescr"]
        sortSeq <- map ["sortSeq"]
        status <- map ["status"]
        updateindex <- map ["updateindex"]
        
    }
}
