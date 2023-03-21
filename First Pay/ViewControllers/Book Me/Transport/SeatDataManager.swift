//
//  SeatDataManager.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 06/08/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import Foundation
import ALBusSeatView

class SeatDataManager {
    var seatList = [[SeatStub]]()
    var selectedSeatlist = [SeatStub]()
}


extension SeatDataManager: ALBusSeatViewDelegate {
    
    func seatView(_ seatView: ALBusSeatView,
                  didSelectAtIndex indexPath: IndexPath,
                  seatType: ALBusSeatType, selectionType: ALSelectionType) {
        
        var stub = seatList[indexPath.section][indexPath.item]
    //    stub.gender = selectionType == .man ? true : false
        print(stub)
        selectedSeatlist.append(stub)
        
       
        let number = "\(stub.number)"
        let myDict = ["number":number] as [String : String]
        
        NotificationCenter.default.post(name: Notification.Name("busSeatsSelected"), object: nil , userInfo: myDict)
        seatView.reload()
    }
    
    func seatView(_ seatView: ALBusSeatView,
                  deSelectAtIndex indexPath: IndexPath,
                  seatType: ALBusSeatType) {
        
        let stub = seatList[indexPath.section][indexPath.item]
        selectedSeatlist.removeAll(where: { $0.id == stub.id })
        
        let number = "\(stub.number)"
        let myDict = ["number":number] as [String : String]
        
        NotificationCenter.default.post(name: Notification.Name("busSeatsDeleted"), object: nil , userInfo: myDict)
        
        seatView.reload()
    }
}

extension SeatDataManager:  ALBusSeatViewDataSource  {
    
    func seatView(_ seatView: ALBusSeatView,
                  seatNumberForIndex indexPath: IndexPath) -> String {
        
        let stub = seatList[indexPath.section][indexPath.item]
        return "\(stub.number)"
    }
    
    func seatView(_ seatView: ALBusSeatView,
                  seatTypeForIndex indexPath: IndexPath) -> ALBusSeatType {
        
        let stub = seatList[indexPath.section][indexPath.item]
        
        if stub.hall { // Hall area
            return .none
        } else if selectedSeatlist.contains(where: { $0.id == stub.id }) { // Selected
            return .selected
        } else if stub.salable { // Open for sale
            return .empty
        } else { // Else not a seat
            return .none
        }
    }
    
    func numberOfSections(in seatView: ALBusSeatView) -> Int {
        
        return seatList.count
    }
    
    func seatView(_ seatView: ALBusSeatView,
                  numberOfSeatInSection section: Int) -> Int {
        
        return seatList[section].count
    }
}
