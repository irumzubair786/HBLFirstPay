//
//  genericQuickIoModel.swift
//  First Pay
//
//  Created by Irum Butt on 20/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
struct GenericModel: Codable {
    let responsecode: Int
    let data: JSONNull?
    let messages: String
}
