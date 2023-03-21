import Foundation
import ObjectMapper

struct AllCommiteeModel : Mappable {
    var responsecode : Int?
    var AllcommiteeData : [AllCommitee]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        AllcommiteeData <- map["data"]
        messages <- map["messages"]
    }

}


struct AllCommitee : Mappable {
    var committeeInstallmentId : Int?
    var committeeHeadId : Int?
    var installmentAmount : Int?
    var dueDate : String?
    var status : String?
    var fromAccountTitle : String?
    var fromAccountNo : String?
    var toAccountTitle : String?
    var toAccountNo : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        committeeInstallmentId <- map["committeeInstallmentId"]
        committeeHeadId <- map["committeeHeadId"]
        installmentAmount <- map["installmentAmount"]
        dueDate <- map["dueDate"]
        status <- map["status"]
        fromAccountTitle <- map["fromAccountTitle"]
        fromAccountNo <- map["fromAccountNo"]
        toAccountTitle <- map["toAccountTitle"]
        toAccountNo <- map["toAccountNo"]
    }

}

