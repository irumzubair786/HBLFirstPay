//
//  FBEventLog.swift
//  First Pay
//
//  Created by Apple on 30/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
import FirebaseAnalytics

struct FBEvents {
    enum name: String {
        //MARK:- NanoLoan
        case titleOne = "titleOne"
        case titleTwo = "titleTwo"
    }
    
    static func logEvent(title: FBEvents.name, description: String) {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let titleName = title.rawValue
        Analytics.logEvent(titleName, parameters: [
          "userId": "id-\(userCnic!)",
          "eventName": titleName,
        ])
    }
}


