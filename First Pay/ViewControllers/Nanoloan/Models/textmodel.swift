

import Foundation
import ObjectMapper



struct CheckEligilibityModel: Mappable {
    var responsecode : Int?
    var data : [Datamodel]?
    var messages : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        responsecode <- map["responsecode"]
        data <- map["data"]
        messages <- map["messages"]
    }

}
struct Datamodel : Mappable {
        var nlProductId : Int?
        var maxAmount : Int?
        var minAmount : Int?
        var nlProductDescr : String?
        var repaymentFrequency : String?
        var processingFeeAmount : Double?
        var markupfee : Double?
        var noOfDays : Int?
        var markupAmountPerDay : Int?
        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            nlProductId <- map["nlProductId"]
            maxAmount <- map["maxAmount"]
            minAmount <- map["minAmount"]
            nlProductDescr <- map["nlProductDescr"]
            repaymentFrequency <- map["repaymentFrequency"]
            processingFeeAmount <- map["processingFeeAmount"]
            markupfee <- map["markupfee"]
            noOfDays <- map["noOfDays"]
            markupAmountPerDay <- map["markupAmountPerDay"]
        }

    }



