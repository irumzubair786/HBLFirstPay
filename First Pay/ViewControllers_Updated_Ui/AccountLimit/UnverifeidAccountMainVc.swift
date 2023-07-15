//
//  UnverifeidAccountMainVc.swift
//  First Pay
//
//  Created by Irum Butt on 12/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import ObjectMapper

class UnverifeidAccountMainVc: BaseClassVC {
    var levelCode :String?
    var totalDailyLimitDr : Int?
    var totalMonthlyLimitDr : Int?
    var totalYearlyLimitDr : Int?
    var totalDailyLimitCr : Int?
    var totalMonthlyLimitCr : Int?
    var totalYearlyLimitCr : Int?
    var balanceLimit : Int?
    var totalDailyLimitDr1 : Int?
    var totalMonthlyLimitDr1 : Int?
    var totalYearlyLimitDr1 : Int?
    var totalDailyLimitCr1 : Int?
    var totalMonthlyLimitCr1 : Int?
    var totalYearlyLimitCr1 : Int?
    var balanceLimit1 : Int?
    var fingerPrintVerification: FingerPrintVerification!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func buttonViewDetail(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnVerifiedAccountVC") as! UnVerifiedAccountVC
        vc.balanceLimit = balanceLimit
        vc.balanceLimit1 = balanceLimit1
        vc.totalDailyLimitCr =  totalDailyLimitCr
        vc.totalDailyLimitCr1 =  totalDailyLimitCr1
        vc.totalMonthlyLimitCr = totalMonthlyLimitCr
        vc.totalMonthlyLimitCr1 = totalMonthlyLimitCr1
        vc.totalYearlyLimitCr =  totalYearlyLimitCr
        vc.totalYearlyLimitCr1 =  totalYearlyLimitCr1
        vc.totalDailyLimitDr = totalDailyLimitDr
        vc.totalDailyLimitDr1 = totalDailyLimitDr1
        vc.totalMonthlyLimitDr =  totalMonthlyLimitDr
        vc.totalMonthlyLimitDr1 =  totalMonthlyLimitDr1
        vc.totalYearlyLimitDr = totalYearlyLimitDr
        vc.totalYearlyLimitDr1 = totalYearlyLimitDr1
        self.present(vc, animated: true)
//        UnVerifiedAccountVC
    }
    
    @IBAction func buttonUpgrade(_ sender: UIButton) {
        // call sdk fingerPrint
        fingerPrintVerification = FingerPrintVerification()
        DispatchQueue.main.async {
            self.fingerPrintVerification.fingerPrintVerification(viewController: self)
        }
        
//        self.showAlertCustomPopup(title: "", message: "Please visit your nearest HBLMfB branch", iconName: .iconSucess, buttonNames: [
//
//            ["buttonName": "OK",
//            "buttonBackGroundColor": UIColor.clrOrange,
//            "buttonTextColor": UIColor.white]
//        ] as? [[String: AnyObject]])
    }
}

extension UnverifeidAccountMainVc: FingerPrintVerificationDelegate {
    func onEightFingerComplition(success: Bool, fingerPrintApiHitCount: Int, apiResponseMessage: String) {
        if fingerPrintApiHitCount == 8 {
            self.showAlertCustomPopup(title: "Success", message: apiResponseMessage)
        }
    }
    
    func onScanComplete(fingerprintsList: [FingerPrintVerification.Fingerprints]?) {
        if fingerprintsList?.count ?? 0 > 0 {
            for fingerprint in fingerprintsList! {
                fingerPrintVerification.acccountLevelUpgrade(fingerprints: fingerprint)
            }
        }
    }
}
