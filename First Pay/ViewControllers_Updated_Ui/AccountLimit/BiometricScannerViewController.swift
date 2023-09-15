//
//  BiometricScannerViewController.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 15/09/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import FingerprintSDK


class BiometricScannerViewController: UIViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonVerifyNow: UIButton!
    
    var accountUpGradeSuccessfull: (() -> ())!
    var fingerprintPngs : [Png]?

    var fingerPrintVerification: FingerPrintVerification!

    func dismissViewControllers() {

        guard let vc = self.presentingViewController else { return }

        while (vc.presentingViewController != nil) {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    var modelAcccountLevelUpgradeResponse: FingerPrintVerification.ModelAcccountLevelUpgradeResponse? {
        didSet {
            print(modelAcccountLevelUpgradeResponse)
            if modelAcccountLevelUpgradeResponse?.responsecode == 1 {
                NotificationCenter.default.post(name: Notification.Name("updateAccountLevel"), object: nil)

                let viewController = UIStoryboard.init(name: "AccountLevel", bundle: nil).instantiateViewController(withIdentifier: "AccountUpgradeSuccessullVC") as! AccountUpgradeSuccessullVC
                viewController.accountUpGradeSuccessfull = {
                    self.dismiss(animated: false)
                    self.accountUpGradeSuccessfull!()
//                    self.dismissViewControllers()
                }
                DispatchQueue.main.async {
                    self.present(viewController, animated: true)
                }
            }
            else if modelAcccountLevelUpgradeResponse?.responsecode == 0 {
                self.showAlertCustomPopup(message: modelAcccountLevelUpgradeResponse?.messages ?? "No Message from API") {_ in

                }
//                let viewController = UIStoryboard.init(name: "AccountLevel", bundle: nil).instantiateViewController(withIdentifier: "AccountUpgradeSuccessullVC") as! AccountUpgradeSuccessullVC
//                viewController.accountUpGradeSuccessfull = {
//                    self.dismiss(animated: true)
//                    self.accountUpGradeSuccessfull!()
//                }
//                DispatchQueue.main.async {
//                    self.present(viewController, animated: false)
//                }
            }
            else {
                self.showAlertCustomPopup(message: "ERROR IN RESPONSE API") {_ in
                    
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonVerifyNow(_ sender: Any) {
        FBEvents.logEvent(title: .BioMetric_Sccanining)
        // call sdk fingerPrint

        fingerPrintVerification = FingerPrintVerification()
        DispatchQueue.main.async {
            self.fingerPrintVerification(viewController: self)
        }
        
        //                dummy finger print api calling
//         self.acccountLevelUpgrade(fingerprints: fingerPrintDataHardCoded)
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

extension BiometricScannerViewController: FingerprintResponseDelegate {
    func onScanComplete(fingerprintResponse: FingerprintResponse) {
        //Shakeel ! added
        if fingerprintResponse.response == Response.SUCCESS_WSQ_EXPORT {
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
