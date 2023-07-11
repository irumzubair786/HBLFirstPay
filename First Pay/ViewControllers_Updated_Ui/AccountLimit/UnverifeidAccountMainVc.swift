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
import FingerprintSDK

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
//        call sdk
        DispatchQueue.main.async {
            self.fingerPrintVerification()
        }
        
//        self.showAlertCustomPopup(title: "", message: "Please visit your nearest HBLMfB branch", iconName: .iconSucess, buttonNames: [
//
//            ["buttonName": "OK",
//            "buttonBackGroundColor": UIColor.clrOrange,
//            "buttonTextColor": UIColor.white]
//        ] as? [[String: AnyObject]])
    }
    
    func fingerPrintVerification() {
        //#if targetEnvironment(simulator)
        //        #else
        let fingerprintConfig = FingerprintConfig(mode: .EXPORT_WSQ,
                                                  hand: .BOTH_HANDS,
                                                  fingers: .EIGHT_FINGERS,
                                                  isPackPng: true)
        let vc = FaceoffViewController.init(nibName: "FaceoffViewController", bundle: Bundle(for: FaceoffViewController.self))
        vc.fingerprintConfig = fingerprintConfig
        vc.fingerprintResponseDelegate = self
        self.present(vc, animated: true, completion: nil)
        //        #endif
    }
    
}

extension UnverifeidAccountMainVc: FingerprintResponseDelegate {
    
    func onScanComplete(fingerprintResponse: FingerprintResponse) {
        //Shakeel ! added
        if fingerprintResponse.response == Response.SUCCESS_WSQ_EXPORT {
            let vc = UIStoryboard.init(name: "AccountLevel", bundle: nil).instantiateViewController(withIdentifier: "AccountUpgradeSuccessullVC") as! AccountUpgradeSuccessullVC
            DispatchQueue.main.async {
                self.present(vc, animated: true)
            }
            
//            self.fingerprintPngs = fingerprintResponse.pngList
//            var fingerprintsList = [Fingerprints2]()
//            if let fpPNGs = self.fingerprintPngs {
//                for item in fpPNGs {
//                    guard let imageString = item.binaryBase64ObjectPNG else { return }
//                    guard let instance = Fingerprints2(index: "\(item.fingerPositionCode)", template: imageString) else { return }
//                    fingerprintsList.append(instance)
//                }
//            }
        }else {
            self.showAlertCustomPopup(title: "Faceoff Results", message: fingerprintResponse.response.message, iconName: .iconError) {_ in
                self.dismiss(animated: true)
            }
            
        }
    }
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
}
