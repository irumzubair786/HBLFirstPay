//
//  MockSeatCreater.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 06/08/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation


struct SeatStub {
    let id: String
    let number: Int
    let salable: Bool
    let hall: Bool
}

class MockSeatCreater {
    
    func create(count: Int) -> [SeatStub] {
        var list = [SeatStub]()
        (1...count).forEach { (count) in
            let isHall = (count - 2) % 5 == 0
            let stub = SeatStub(id: UUID().uuidString,
                                number: count,
                                salable: true,
                                hall: false)
            list.append(stub)
        }
        return list
    }
    
}
