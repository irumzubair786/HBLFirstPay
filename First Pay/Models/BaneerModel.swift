//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let banersModel = try? newJSONDecoder().decode(BanersModel.self, from: jsonData)
//
import Foundation
//
//// MARK: - BanersModel
//struct MYBanersModel: Codable {
//    let responsecode: Int
//    let data: [Datumm]
//    let messages: String
//}
//
//// MARK: - Datum
//struct Datumm: Codable {
//    let brandID: Int
//    let banner: String?
//    let brandCode, brandDescr, createdate: String
//    let createuser: Int
//    let image: JSONNull?
//    let lastupdatedate: String
//    let lastupdateuser: Int
//    let status: String
//    let updateindex: Int
//    let lkpCategory, tblBrandLocations: JSONNull?
//    let bannerDisplay: String
//    let tblDiscounts: JSONNull?
//
//    enum CodingKeys: String, CodingKey {
//        case brandID = "brandId"
//        case banner, brandCode, brandDescr, createdate, createuser, image, lastupdatedate, lastupdateuser, status, updateindex, lkpCategory, tblBrandLocations, bannerDisplay, tblDiscounts
//    }
//}
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
//
//
//// MARK: - Encode/decode helpers
////
////class JSONNull: Codable, Hashable {
////
////    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
////        return true
////    }
////
////    public var hashValue: Int {
////        return 0
////    }
////
////    public init() {}
////
////    public required init(from decoder: Decoder) throws {
////        let container = try decoder.singleValueContainer()
////        if !container.decodeNil() {
////            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
////        }
////    }
////
////    public func encode(to encoder: Encoder) throws {
////        var container = encoder.singleValueContainer()
////        try container.encodeNil()
////    }
////}
////
struct MYBanersModel: Codable {
    let responsecode: Int?
    let data: [Datumm]
    let messages: String?
}

// MARK: - Datum
struct Datumm: Codable {
    let brandID: Int
    let banner: String?
    let brandCode, brandDescr, createdate: String
    let createuser: Int?
    let image: String?
    let lastupdatedate: String?
    let lastupdateuser: Int?
    let status: String?
    let updateindex: Int?
    let lkpCategory, tblBrandLocations: JSONNull?
    let bannerDisplay: String?
    let tblDiscounts: JSONNull?

    enum CodingKeys: String, CodingKey {
        case brandID = "brandId"
        case banner, brandCode, brandDescr, createdate, createuser, image, lastupdatedate, lastupdateuser, status, updateindex, lkpCategory, tblBrandLocations, bannerDisplay, tblDiscounts
    }
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
