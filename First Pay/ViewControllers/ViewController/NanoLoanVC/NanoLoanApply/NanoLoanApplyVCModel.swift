//
//  NanoLoanApplyVCModel.swift
//  First Pay
//
//  Created by Apple on 10/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation

extension NanoLoanApplyViewController {
    // This file was generated from JSON Schema using quicktype, do not modify it directly.
    // To parse the JSON, add this file to your project and do:
    
    // MARK: - ModelGetActiveLoan
    struct ModelGetActiveLoan: Codable {
        let messages: String
        let responseblock: JSONNull?
        let responsecode: Int
        let data: ModelActiveLoanData?
    }
    
    // MARK: - DataClass
    struct ModelActiveLoanData: Codable {
        let loanHistory, currentLoan: [ModelCurrentLoan]
    }
    
    // MARK: - CurrentLoan
    struct ModelCurrentLoan: Codable {
        let nlDisbursementID, daysTillDueDate, accountID: Int?
            let loanAvailDate: String?
            let totalPayable: Double?
            let dueDate: String?
            let markupAmountOS: Double?
            let loanAvailedAmount, principalAmountOS: Int?

            enum CodingKeys: String, CodingKey {
                case nlDisbursementID = "nlDisbursementId"
                case daysTillDueDate
                case accountID = "accountId"
                case loanAvailDate, totalPayable, dueDate
                case markupAmountOS = "markupAmountOs"
                case loanAvailedAmount
                case principalAmountOS = "principalAmountOs"
            }
    }
    
    // MARK: - ModelNanoLoanEligibilityCheck
    struct ModelNanoLoanEligibilityCheck: Codable {
        let responsecode: Int?
        let data: [ModelNanoLoanEligibilityCheckData]?
        let responseblock: JSONNull?
        let messages: String?
    }
    
    // MARK: - Datum
    struct ModelNanoLoanEligibilityCheckData: Codable {
        let repaymentFrequency: String
            let noOfDays: JSONNull?
            let minAmount, nlProductID: Int
            let loanAmount: JSONNull?
            let markupfee: Int
            let redirect: JSONNull?
            let maxAmount: Int
            let markupAmountPerDay: JSONNull?
            let nlProductDescr: String
            let avgAmount: Int
            let processingFeeAmount: JSONNull?

            enum CodingKeys: String, CodingKey {
                case repaymentFrequency, noOfDays, minAmount
                case nlProductID = "nlProductId"
                case loanAmount, markupfee, redirect, maxAmount, markupAmountPerDay, nlProductDescr, avgAmount, processingFeeAmount
            }
    }
    
    // MARK: - ModelGetLoanCharges
    struct ModelGetLoanCharges: Codable {
        let responsecode: Int
        let data: ModelGetLoanChargesData
        let responseblock: JSONNull?
        let messages: String
    }

    // MARK: - DataClass
    struct ModelGetLoanChargesData: Codable {
        let loanAmount, processingFeeAmount: Int
        let loanDuration, dueDate: String
        let markupAmountPerDay: Double
        let markupAmountTotal, amountToBeRepaid: Int
        let fed: Double
    }
    
    // MARK: - Encode/decode helpers
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
}
