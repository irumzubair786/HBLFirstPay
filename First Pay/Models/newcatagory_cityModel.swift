//
//  newcatagory_cityModel.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 30/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let citycatagory = try? newJSONDecoder().decode(Citycatagory.self, from: jsonData)

import Foundation

// MARK: - Citycatagory
struct Citycatagory: Codable {
    let responsecode: Int
    let data: [DatumM]
    let messages: String
}

// MARK: - Datum
struct DatumM: Codable {
    let discountsID: Int
    let createdate: String
    let createuser: Int
    let discountDetails, discountPercentage: String
    let lastupdatedate, lastupdateuser, updateindex: JSONNull?
    let website: String?
    let fromDate, toDate: Int
    let tblBrand: TblBrandD
    let tblBrandLocation: TblBrandLocationN

    enum CodingKeys: String, CodingKey {
        case discountsID = "discountsId"
        case createdate, createuser, discountDetails, discountPercentage, lastupdatedate, lastupdateuser, updateindex, website, fromDate, toDate, tblBrand, tblBrandLocation
    }
}

// MARK: - TblBrand
struct TblBrandD: Codable {
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
struct TblBrandLocationN: Codable {
    let brandLocationID: Int
    let address, createdate: String
    let createuser: Int
    let image: String
    let lastupdatedate: String?
    let lastupdateuser: Int?
    let latitude, longitude: Double
    let status: String
    let updateindex: Int?
    let lkpCity: LkpCityY
    let tblBrand, tblDiscounts: JSONNull?
    let contactNo, email: String

    enum CodingKeys: String, CodingKey {
        case brandLocationID = "brandLocationId"
        case address, createdate, createuser, image, lastupdatedate, lastupdateuser, latitude, longitude, status, updateindex, lkpCity, tblBrand, tblDiscounts, contactNo, email
    }
}

// MARK: - LkpCity
struct LkpCityY: Codable {
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
