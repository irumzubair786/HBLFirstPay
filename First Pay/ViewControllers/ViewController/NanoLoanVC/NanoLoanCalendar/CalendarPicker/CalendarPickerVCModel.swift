//
//  CalendarPickerVCModel.swift
//  First Pay
//
//  Created by Apple on 12/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation


extension CalendarPickerViewController {
    // MARK: - ModelGetSchCalendar
    struct ModelGetSchCalendar: Codable {
        let messages: String
        let responseblock: JSONNull?
        let data: ModelGetSchCalendarData
        let responsecode: Int
    }

    // MARK: - DataClass
    struct ModelGetSchCalendarData: Codable {
        let endDate: String
        let dates: [String: ModelGetSchCalendarDateValue]
        let startDate: String
    }

    // MARK: - DateValue
    struct ModelGetSchCalendarDateValue: Codable {
        let scheduleDate: String
        let markup: Double
        let dueDate: DueDate
        let markupDiff: Double
    }

    enum DueDate: String, Codable {
        case n = "N"
        case y = "Y"
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
