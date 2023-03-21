//
//  AllDiscountListModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 27/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let alldiscountList = try? newJSONDecoder().decode(AlldiscountList.self, from: jsonData)

import Foundation

// MARK: - AlldiscountList
struct AlldiscountList: Codable {
    let responsecode: Int
    let data: [Datum]
    let messages: String
    
}

// MARK: - Datum
struct Datum: Codable {
    let discountsID: Int
    let createdate: String
    let createuser: Int
    let discountDetails, discountPercentage: String
    let lastupdatedate: String?
    let lastupdateuser, updateindex: Int?
    let website: String?
    let fromDate, toDate: Int
    let tblBrand: TblBrand
    let tblBrandLocation: TblBrandLocation

    enum CodingKeys: String, CodingKey {
        case discountsID = "discountsId"
        case createdate, createuser, discountDetails, discountPercentage, lastupdatedate, lastupdateuser, updateindex, website, fromDate, toDate, tblBrand, tblBrandLocation
    }
}

// MARK: - TblBrand
struct TblBrand: Codable {
    let brandID: Int
    let banner: String?
    let brandCode, brandDescr, createdate: String
    let createuser: Int
    let image: String
    let lastupdatedate: String
    let lastupdateuser: Int
    let status: Status
    let updateindex: Int
    let lkpCategory, tblBrandLocations: JSONNull?
    let bannerDisplay: BannerDisplay
    let tblDiscounts: JSONNull?

    enum CodingKeys: String, CodingKey {
        case brandID = "brandId"
        case banner, brandCode, brandDescr, createdate, createuser, image, lastupdatedate, lastupdateuser, status, updateindex, lkpCategory, tblBrandLocations, bannerDisplay, tblDiscounts
    }
}

enum BannerDisplay: String, Codable {
    case n = "N"
    case y = "Y"
}

enum Status: String, Codable {
    case a = "A"
}

// MARK: - TblBrandLocation
struct TblBrandLocation: Codable {
    let brandLocationID: Int
    let address, createdate: String
    let createuser: Int
    let image: String?
    let lastupdatedate: String?
    let lastupdateuser: Int?
    let latitude, longitude: Double?
    let status: Status?
    let updateindex: Int?
    let lkpCity: LkpCity
    let tblBrand, tblDiscounts: JSONNull?
    let contactNo, email: String

    enum CodingKeys: String, CodingKey {
        case brandLocationID = "brandLocationId"
        case address, createdate, createuser, image, lastupdatedate, lastupdateuser, latitude, longitude, status, updateindex, lkpCity, tblBrand, tblDiscounts, contactNo, email
    }
}

// MARK: - LkpCity
struct LkpCity: Codable {
    let cityID: Int
    let cityCode: CityCode
    let cityDescr: CityDescr
    let createdate, createuser: Int
    let lastupdatedate, lastupdateuser: JSONNull?
    let sortSeq: Int
    let status: Status
    let updateindex, lkpDistrict, lkpRegion, tblCustomers: JSONNull?
    let tblBrandLocations, lkpBranches: JSONNull?

    enum CodingKeys: String, CodingKey {
        case cityID = "cityId"
        case cityCode, cityDescr, createdate, createuser, lastupdatedate, lastupdateuser, sortSeq, status, updateindex, lkpDistrict, lkpRegion, tblCustomers, tblBrandLocations, lkpBranches
    }
}

enum CityCode: String, Codable {
    case ct0175 = "CT0175"
    case ct0180 = "CT0180"
    case ct0224 = "CT0224"
    case ct0303 = "CT0303"
    case ct0317 = "CT0317"
}

enum CityDescr: String, Codable {
    case gilgit = "GILGIT"
    case islamabad = "ISLAMABAD"
    case lahore = "LAHORE"
    case multan = "MULTAN"
    case peshawar = "PESHAWAR"
}

// MARK: - Encode/decode helpers
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
