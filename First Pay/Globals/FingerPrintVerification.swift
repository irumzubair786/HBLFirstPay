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
            if modelFingerPrintResponse?.responsecode == 1 {
                fingerPrintApiHitCount += 1
                delegate.onEightFingerComplition(success: true, fingerPrintApiHitCount: fingerPrintApiHitCount, apiResponseMessage: modelFingerPrintResponse?.messages ?? "No Message from API")
            }
        }
    }
    
    func fingerPrintVerification(viewController: UIViewController) {
        //#if targetEnvironment(simulator)
        //        #else
        fingerPrintApiHitCount = 0
        self.viewController = viewController
        self.delegate = viewController as? FingerPrintVerificationDelegate
        let fingerprintConfig = FingerprintConfig(mode: .EXPORT_WSQ,
                                                  hand: .BOTH_HANDS,
                                                  fingers: .EIGHT_FINGERS,
                                                  isPackPng: true)
        let vc = FaceoffViewController.init(nibName: "FaceoffViewController", bundle: Bundle(for: FaceoffViewController.self))
        vc.fingerprintConfig = fingerprintConfig
        vc.fingerprintResponseDelegate = viewController as? FingerprintResponseDelegate
        viewController.present(vc, animated: true, completion: nil)
        //        #endif
    }

    func acccountLevelUpgrade(fingerprints: Fingerprints) {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "fingerindex" : fingerprints.index
        ]

    //    let apiAttribute3 = [
    //        "apiAttribute3" : fingerprints.template
    //    ]
    //    print(parameters)
        
        APIs.postAPIForFingerPrint(apiName: .acccountLevelUpgrade, parameters: parameters, apiAttribute3: fingerprints.template, viewController: viewController) {
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

            let model: ModelFingerPrintResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelFingerPrintResponse = model
        }
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
                    guard let instance = Fingerprints(index: "\(item.fingerPositionCode)", template: imageString) else { return }
                    fingerprintsList.append(instance)
                }
            }
            print(fingerprintsList)
            print(fingerprintsList)
            print(fingerprintsList)
            
            self.delegate.onScanComplete(fingerprintsList: fingerprintsList)
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
        let data: JSONNull?
        let messages: String
        let responseblock: JSONNull?
    }

    struct Fingerprints: Codable {
        var index: String
        var template: String
        
        init?(index: String, template: String) {
            self.index = index
            self.template = template
        }
    }
}
