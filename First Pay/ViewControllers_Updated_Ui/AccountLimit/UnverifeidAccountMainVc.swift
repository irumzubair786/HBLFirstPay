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
    var fingerprintPngs : [Png]?

    
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

    var modelAcccountLevelUpgradeResponse: FingerPrintVerification.ModelAcccountLevelUpgradeResponse? {
        didSet {
            print(modelAcccountLevelUpgradeResponse)
            if modelAcccountLevelUpgradeResponse?.responsecode == 1 {
                self.showAlertCustomPopup(title: "Success", message: modelAcccountLevelUpgradeResponse?.messages ?? "SUCCESS FROM API") {_ in
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
                    self.present(vc, animated: true)
                }
            }
            else if modelAcccountLevelUpgradeResponse?.responsecode == 0 {
                self.showAlertCustomPopup(title: "Error", message: modelAcccountLevelUpgradeResponse?.messages ?? "No Message from API") {_ in
                    
                }
            }
            else {
                self.showAlertCustomPopup(title: "Error", message: "ERROR IN RESPONSE API") {_ in
                    
                }
            }
        }
    }
    
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
        FBEvents.logEvent(title: .BioMetric_Sccanining)
        // call sdk fingerPrint
        
        fingerPrintVerification = FingerPrintVerification()
        DispatchQueue.main.async {
            self.fingerPrintVerification(viewController: self)
        }
        
//        self.showAlertCustomPopup(title: "", message: "Please visit your nearest HBLMfB branch", iconName: .iconSucess, buttonNames: [
//
//            ["buttonName": "OK",
//            "buttonBackGroundColor": UIColor.clrOrange,
//            "buttonTextColor": UIColor.white]
//        ] as? [[String: AnyObject]])
    }
    
    func fingerPrintVerification(viewController: UIViewController) {
        //#if targetEnvironment(simulator)
        //        #else

        let customUI = CustomUI(
            topBarBackgroundImage: nil,
            topBarColor: .clrNavigationBarBVS,
            topBarTextColor: .white,
            containerBackgroundColor: UIColor.white,
            scannerOverlayColor: UIColor.clrGreenBVS,
            scannerOverlayTextColor: UIColor.white,
            instructionTextColor: UIColor.white,
            buttonsBackgroundColor: .clrNextButtonBackGroundBVS,
            buttonsTextColor: UIColor.white,
            imagesColor: .clrGreenBVS,
            isFullWidthButtons: true,
            guidanceScreenButtonText: "NEXT",
            guidanceScreenText: "User Demo",
            guidanceScreenAnimationFilePath: nil,
            showGuidanceScreen: true)

        let customDialog = CustomDialog(
            dialogImageBackgroundColor: UIColor.white,
            dialogImageForegroundColor: .green,
            dialogBackgroundColor: UIColor.white,
            dialogTitleColor: .clrGreenBVS,
            dialogMessageColor: .clrBlack,
            dialogButtonTextColor: UIColor.white,
            dialogButtonBackgroundColor: .orange)
        
        let uiConfig = UIConfig(
            splashScreenLoaderIndicatorColor: .clrBlack,
            splashScreenText: "Please wait",
            splashScreenTextColor: UIColor.white,
            customUI: customUI,
            customDialog: customDialog,
            customFontFamily: nil)
        
        let fingerprintConfig = FingerprintConfig(mode: .EXPORT_WSQ,
                                                  hand: .BOTH_HANDS,
                                                  fingers: .EIGHT_FINGERS,
                                                  isPackPng: true, uiConfig: uiConfig)
        let vc = FaceoffViewController.init(nibName: "FaceoffViewController", bundle: Bundle(for: FaceoffViewController.self))
        
        vc.fingerprintConfig = fingerprintConfig
        vc.fingerprintResponseDelegate = viewController as? FingerprintResponseDelegate
        viewController.present(vc, animated: true, completion: nil)
        //        #endif
    }
}

//extension UnverifeidAccountMainVc: FingerPrintVerificationDelegate {
//    func onEightFingerComplition(success: Bool, fingerPrintApiHitCount: Int, apiResponseMessage: String) {
//        if fingerPrintApiHitCount == 8 {
//            self.showAlertCustomPopup(title: "Success", message: apiResponseMessage)
//        }
//    }
//    
//    func onScanComplete(fingerprintsList: [FingerPrintVerification.Fingerprints]?) {
//        if fingerprintsList?.count ?? 0 > 0 {
////            for fingerprint in fingerprintsList! {
////                fingerPrintVerification.acccountLevelUpgrade(fingerprints: fingerprint)
////            }
//            fingerPrintVerification.acccountLevelUpgrade(fingerprints: fingerprintsList!)
//        }
//    }
//
//}

extension UnverifeidAccountMainVc: FingerprintResponseDelegate {
    func onScanComplete(fingerprintResponse: FingerprintResponse) {
        //Shakeel ! added
        if fingerprintResponse.response == Response.SUCCESS_WSQ_EXPORT {
//            print(fingerprintResponse.response)
//            print(fingerprintResponse.response)
            fingerprintPngs = fingerprintResponse.pngList
            var fingerprintsList = [FingerPrintVerification.Fingerprints]()
            
            var tempFingerPrintDictionary = [[String:Any]]()
            //for testing
//            var tempFingerPrintDictionary2 = [[String:Any]]()

            if let fpPNGs = fingerprintPngs {
                for item in fpPNGs {
                    guard let imageString = item.binaryBase64ObjectPNG else { return }
                    guard let instance = FingerPrintVerification.Fingerprints(fingerIndex: "\(item.fingerPositionCode)", fingerTemplate: imageString) else { return }
                   
                    tempFingerPrintDictionary.append(
                        ["fingerIndex":"\(item.fingerPositionCode)",
                         "fingerTemplate":imageString,
                         "templateType":"WSQ"]
                    )
                    //for testing
//                    tempFingerPrintDictionary2.append(
//                        ["fingerIndex":item.fingerPositionCode,
//                         "fingerTemplate":item.fingerPositionCode,
//                         "templateType":"WSQ"]
//                    )
//                    fingerprintsList.append(instance)
                }
            }
//            print(fingerprintsList)
//            print(fingerprintsList)
//            print(fingerprintsList)
            //for testing
//            let jsonDataaa = try! JSONSerialization.data(withJSONObject: tempFingerPrintDictionary2 as Any, options: .prettyPrinted)
//            let decoded = try! JSONSerialization.jsonObject(with: jsonDataaa, options: [])
//
//            print(decoded)
//            print(decoded)
//           let params = [
//                "apiAttribute1":"result.apiAttribute1",
//                "apiAttribute2":"result.apiAttribute2",
//                "channelId":"\(DataManager.instance.channelID)",
//                "apiAttribute3":decoded
//            ]
//            print(params)

            self.acccountLevelUpgrade(fingerprints: tempFingerPrintDictionary)
           // self.delegate.onScanComplete(fingerprintsList: fingerprintsList)
//            if fingerprintsList.count > 0 {
//                for fingerprint in fingerprintsList {
//                    acccountLevelUpgrade(fingerprints: fingerprint)
//                }
//            }
        }else {
            self.showAlertCustomPopup(title: "Faceoff Results", message: fingerprintResponse.response.message, iconName: .iconError) {_ in
//                self.dismiss(animated: true)
            }
        }
    }
    
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
    func acccountLevelUpgrade(fingerprints: [[String:Any]]) {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
        ]

    //    let apiAttribute3 = [
    //        "apiAttribute3" : fingerprints.template
    //    ]
    //    print(parameters)
        
        APIs.postAPIForFingerPrint(apiName: .acccountLevelUpgrade, parameters: parameters, apiAttribute3: fingerprints, viewController: self) {
            responseData, success, errorMsg in
            
            print(responseData)
            print(success)
            print(errorMsg)
            do {
                let json: Any? = try JSONSerialization.jsonObject(with: (responseData ?? Data()), options: [.fragmentsAllowed])
                print(json)
            }
            catch let error {
                print(error)
            }

            let model: FingerPrintVerification.ModelAcccountLevelUpgradeResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelAcccountLevelUpgradeResponse = model
        }
    }
}
