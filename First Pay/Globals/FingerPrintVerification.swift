//
//  GlobalAPIs.swift
//  First Pay
//
//  Created by Apple on 15/07/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import Foundation
import Alamofire
import FingerprintSDK


protocol FingerPrintVerificationDelegate: AnyObject {
    func onScanComplete(fingerprintsList : [FingerPrintVerification.Fingerprints]?)
    
    func onEightFingerComplition(success: Bool, fingerPrintApiHitCount: Int, apiResponseMessage: String)
}

class FingerPrintVerification {
    var fingerprintPngs : [Png]?
    var viewController: UIViewController!
    var delegate: FingerPrintVerificationDelegate!
    var fingerPrintApiHitCount: Int!
    var modelFingerPrintResponse: ModelFingerPrintResponse? {
        didSet {
            print(modelFingerPrintResponse)
//            if modelFingerPrintResponse?.responsecode == 1 {
//                fingerPrintApiHitCount += 1
//                delegate.onEightFingerComplition(success: true, fingerPrintApiHitCount: fingerPrintApiHitCount, apiResponseMessage: modelFingerPrintResponse?.messages ?? "No Message from API")
//            }
        }
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
//    FingerPrintVerification.Fingerprints
    func acccountLevelUpgrade(fingerprints: [Fingerprints]) {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            //"fingerindex" : fingerprints.index
        ]

    //    let apiAttribute3 = [
    //        "apiAttribute3" : fingerprints.template
    //    ]
    //    print(parameters)
        
//        APIs.postAPIForFingerPrint(apiName: .acccountLevelUpgrade, parameters: parameters, apiAttribute3: fingerprints, viewController: viewController) {
//            responseData, success, errorMsg in
//            
//            print(responseData)
//            print(success)
//            print(errorMsg)
//            do {
//                let json: Any? = try JSONSerialization.jsonObject(with: (responseData ?? Data()), options: [.fragmentsAllowed])
//                print(json)
//            }
//            catch let error {
//                print(error)
//            }
//
//            let model: ModelFingerPrintResponse? = APIs.decodeDataToObject(data: responseData)
//            self.modelFingerPrintResponse = model
//        }
    }
}

extension  FingerPrintVerification: FingerprintResponseDelegate {
    func onScanComplete(fingerprintResponse: FingerprintResponse) {
        //Shakeel ! added
        if fingerprintResponse.response == Response.SUCCESS_WSQ_EXPORT {
            
            print(fingerprintResponse.response)
            print(fingerprintResponse.response)
            
            fingerprintPngs = fingerprintResponse.pngList
            var fingerprintsList = [Fingerprints]()
            if let fpPNGs = fingerprintPngs {
                for item in fpPNGs {
                    guard let imageString = item.binaryBase64ObjectPNG else { return }
                    guard let instance = Fingerprints(fingerIndex: "\(item.fingerPositionCode)", fingerTemplate: imageString) else { return }
                    fingerprintsList.append(instance)
                }
            }
            print(fingerprintsList)
            print(fingerprintsList)
            print(fingerprintsList)
            
//            self.delegate.onScanComplete(fingerprintsList: fingerprintsList)
//            if fingerprintsList.count > 0 {
//                for fingerprint in fingerprintsList {
//                    acccountLevelUpgrade(fingerprints: fingerprint)
//                }
//            }
        }else {
            viewController.showAlertCustomPopup(title: "Faceoff Results", message: fingerprintResponse.response.message, iconName: .iconError) {_ in
                self.viewController.dismiss(animated: true)
            }
        }
    }
    
    func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        viewController.dismiss(animated: true)
    }
}
extension FingerPrintVerification {
    // MARK: - ModelFingerPrintResponse
    struct ModelFingerPrintResponse: Codable {
        let responsecode: Int
        let data: DataClass
        let messages: String
        let responseblock: JSONNull?
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let response: Int
        let message: String
        let data: [String: Int?]
    }

    struct Fingerprints: Codable {
        var fingerIndex: String
        var fingerTemplate: String
        var templateType: String

        init?(fingerIndex: String, fingerTemplate: String) {
            self.fingerIndex = fingerIndex
            self.fingerTemplate = fingerTemplate
            self.templateType = ""
        }
    }
}
