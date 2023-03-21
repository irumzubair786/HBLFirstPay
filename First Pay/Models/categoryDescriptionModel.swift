
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ctegoryDescription = try? newJSONDecoder().decode(CtegoryDescription.self, from: jsonData)

import Foundation

// MARK: - CtegoryDescription
struct CtegoryDescriptionModel: Codable {
    let responsecode: Int
    let data: [Datummodel]
    let messages: String
}

// MARK: - Datum
struct Datummodel: Codable {
    let discountsID: Int
    let createdate: String
    let createuser: Int
    let discountDetails, discountPercentage: String
    let lastupdatedate, lastupdateuser, updateindex: JSONNull?
    let website: String?
    let fromDate, toDate: Int
    let tblBrand: TblBrandmodel
    let tblBrandLocation: TblBrandLocationmodel

    enum CodingKeys: String, CodingKey {
        case discountsID = "discountsId"
        case createdate, createuser, discountDetails, discountPercentage, lastupdatedate, lastupdateuser, updateindex, website, fromDate, toDate, tblBrand, tblBrandLocation
    }
}

// MARK: - TblBrand
struct TblBrandmodel: Codable {
    let brandID: Int
    let banner: JSONNull?
    let brandCode, brandDescr, createdate: String
    let createuser: Int
    let image: String
    let lastupdatedate: String
    let lastupdateuser: Int
    let status: String
    let updateindex: Int
    let lkpCategory, tblBrandLocations: JSONNull?
    let bannerDisplay: String
    let tblDiscounts: JSONNull?

    enum CodingKeys: String, CodingKey {
        case brandID = "brandId"
        case banner, brandCode, brandDescr, createdate, createuser, image, lastupdatedate, lastupdateuser, status, updateindex, lkpCategory, tblBrandLocations, bannerDisplay, tblDiscounts
    }
}

// MARK: - TblBrandLocation
struct TblBrandLocationmodel: Codable {
    let brandLocationID: Int
    let address, createdate: String
    let createuser: Int
    let image: String
    let lastupdatedate, lastupdateuser: JSONNull?
    let latitude, longitude: Double
    let status: String
    let updateindex: JSONNull?
    let lkpCity: LkpCitymodel
    let tblBrand, tblDiscounts: JSONNull?
    let contactNo, email: String

    enum CodingKeys: String, CodingKey {
        case brandLocationID = "brandLocationId"
        case address, createdate, createuser, image, lastupdatedate, lastupdateuser, latitude, longitude, status, updateindex, lkpCity, tblBrand, tblDiscounts, contactNo, email
    }
}

// MARK: - LkpCity
struct LkpCitymodel: Codable {
    let cityID: Int
    let cityCode, cityDescr: String
    let createdate, createuser: Int
    let lastupdatedate, lastupdateuser: JSONNull?
    let sortSeq: Int
    let status: String
    let updateindex, lkpDistrict, lkpRegion, tblCustomers: JSONNull?
    let tblBrandLocations, lkpBranches: JSONNull?

    enum CodingKeys: String, CodingKey {
        case cityID = "cityId"
        case cityCode, cityDescr, createdate, createuser, lastupdatedate, lastupdateuser, sortSeq, status, updateindex, lkpDistrict, lkpRegion, tblCustomers, tblBrandLocations, lkpBranches
    }
}

// MARK: - Encode/decode helpers

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
