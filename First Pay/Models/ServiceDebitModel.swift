





import Foundation
import ObjectMapper

struct modelservice : Mappable {
    var accountDebitCard : AccountDebitCard?
    var cardchannels : [Cardchannels]?
    var stringlist = [String]()
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        accountDebitCard <- map["accountDebitCard"]
        cardchannels <- map["cardchannels"]
        for chanellist in self.cardchannels!
        {
           
            
            (stringlist.append(chanellist.channel ?? ""))
            (stringlist.append(chanellist.status ?? ""))
        }
    }

}

struct AccountDebitCard : Mappable {
    var accountDebitCardId : Int?
    var accountId : Int?
    var accountNo : String?
    var createdate : Int?
    var createuser : Int?
    var lastupdatedate : Int?
    var lastupdateuser : Int?
    var pan : String?
    var status : String?
    var updateindex : Int?
    var cardId : String?
    var expiryDate : String?
    var debitCardTitle : String?
    var cardExpiryYear : String?
    var cardExpiryMonth : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        accountDebitCardId <- map["accountDebitCardId"]
        accountId <- map["accountId"]
        accountNo <- map["accountNo"]
        createdate <- map["createdate"]
        createuser <- map["createuser"]
        lastupdatedate <- map["lastupdatedate"]
        lastupdateuser <- map["lastupdateuser"]
        pan <- map["pan"]
        status <- map["status"]
        updateindex <- map["updateindex"]
        cardId <- map["cardId"]
        expiryDate <- map["expiryDate"]
        debitCardTitle <- map["debitCardTitle"]
        cardExpiryYear <- map["cardExpiryYear"]
        cardExpiryMonth <- map["cardExpiryMonth"]
    }

}
struct Cardchannels : Mappable {
    var channel : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        channel <- map["channel"]
        status <- map["status"]
    }

}

//main model
struct ServiceModel: Mappable {
    var responsecode : Int?
    var data : modelservice?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
