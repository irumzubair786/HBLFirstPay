//
//  AddCashMainVc.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import FingerprintSDK

class AddCashMainVc: BaseClassVC {
    var cbsAccountsObj : GetCBSAccounts?
    var LinkedAccountsObj : getLinkedAccountModel?
    var fingerPrintVerification: FingerPrintVerification!
    var fingerprintPngs : [Png]?

    var modelFingerPrintResponse: ModelFingerPrintResponse? {
        didSet {
            print(modelFingerPrintResponse)
            if modelFingerPrintResponse?.responsecode == 1 {
                self.showAlertCustomPopup(title: "Sucess", message: modelFingerPrintResponse?.messages ?? "No Message from API") {_ in
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
                    self.present(vc, animated: true)
                }
            }
            else {
                self.showAlertCustomPopup(title: "Error", message: modelFingerPrintResponse?.messages ?? "No Message from API") {_ in
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        buttonLinkHBLMFBAccount.setTitle("", for: .normal)
        buttonFromLinkAccount.setTitle("", for: .normal)
        buttonViabankTransfer.setTitle("", for: .normal)
        buttonRequestMoney.setTitle("", for: .normal)
        buttonGetLoan.setTitle("", for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var buttonFromLinkAccount: UIButton!
    @IBAction func buttonFromLinkAccount(_ sender: UIButton) {
        LinkAccounts()
    }
    @IBOutlet weak var buttonLinkHBLMFBAccount: UIButton!
    
    @IBAction func buttonLinkHBLMFBAccount(_ sender: UIButton) {
        getLinkAccounts()
    }
    
    @IBOutlet weak var buttonViabankTransfer: UIButton!
    
    @IBAction func buttonViabankTransfer(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "viaBankTransferStepsVc") as!   viaBankTransferStepsVc
        self.navigationController?.pushViewController(vc,animated: true)
        
    }
    @IBOutlet weak var buttonRequestMoney: UIButton!
    @IBAction func buttonRequestMoney(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestMoneyDetailVc") as!   RequestMoneyDetailVc
        self.navigationController?.pushViewController(vc,animated: true)
    }
    @IBOutlet weak var buttonGetLoan: UIButton!
    
    @IBAction func buttonGetLoan(_ sender: UIButton) {
        if DataManager.instance.accountLevel == "LEVEL 0" {
        //   call sdk
            fingerPrintVerification = FingerPrintVerification()
            DispatchQueue.main.async {
                self.fingerPrintVerification.fingerPrintVerification(viewController: self)
            }
        }
        else {
            getActiveLoan()
        }
    }
    
    var modelGetActiveLoan: NanoLoanApplyViewController.ModelGetActiveLoan? {
        didSet {
            if modelGetActiveLoan?.data?.currentLoan.count ?? 0 > 0 {
                self.openNanoLoan()
            }
            else {
                nanoLoanEligibilityCheck()
            }
        }
    }
    func getActiveLoan() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        APIs.postAPI(apiName: .getActiveLoan, parameters: parameters, viewController: self) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelGetActiveLoan? = APIs.decodeDataToObject(data: responseData)
            self.modelGetActiveLoan = model
        }
    }
    
    var modelNanoLoanEligibilityCheck: NanoLoanApplyViewController.ModelNanoLoanEligibilityCheck? {
        didSet {
            if modelNanoLoanEligibilityCheck?.responsecode ?? 0 == 0 {
                showAlertCustomPopup(title: "Alert", message: modelNanoLoanEligibilityCheck?.messages ?? "", iconName: .iconError)
            }
            else {
                openNanoLoan()
            }
        }
    }
    
    func nanoLoanEligibilityCheck() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)"
        ]
        APIs.postAPI(apiName: .nanoLoanEligibilityCheck, parameters: parameters) { responseData, success, errorMsg in
            let model: NanoLoanApplyViewController.ModelNanoLoanEligibilityCheck? = APIs.decodeDataToObject(data: responseData)
            self.modelNanoLoanEligibilityCheck = model
        }
    }
    
    func openNanoLoan() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanContainer") as! NanoLoanContainer
        vc.isPushViewController = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func getLinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getCbsAccounts"
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!]
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //            (response: DataResponse<GetCBSAccounts>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.cbsAccountsObj = Mapper<GetCBSAccounts>().map(JSONObject: json)
            
            //            self.cbsAccountsObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.cbsAccountsObj?.responsecode == 2 || self.cbsAccountsObj?.responsecode == 1 {
                    if self.cbsAccountsObj?.accdata?.count ?? 0 > 0{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LinkBankAccountListVC") as! LinkBankAccountListVC
                        //                        vc.accountTitle = cbsAccountsObj?.accdata[0].cbsAccountTitle
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else{
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoBankAccountFoundVc") as! NoBankAccountFoundVc
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                }
                else {
                    self.showAlert(title: "", message: (self.cbsAccountsObj?.messages)!, completion: nil)
                }
            }
            else {
                
                //                print(response.result.value)
                //                print(response.response?.statusCode)
                
            }
        }
    }
    
    
    private func LinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getLinkAccount"
        
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!]
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //            [self] (response: DataResponse<getLinkedAccountModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.LinkedAccountsObj = Mapper<getLinkedAccountModel>().map(JSONObject: json)
            
            
            //            self.LinkedAccountsObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.LinkedAccountsObj?.responsecode == 2 || self.LinkedAccountsObj?.responsecode == 1 {
                    if self.LinkedAccountsObj?.data?.count ?? 0 > 0{
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "FromLinkAccountListVc") as! FromLinkAccountListVc
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                        
                    }
                    
                }
                else{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NobankExistsVc") as! NobankExistsVc
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            else {
                self.showAlert(title: "", message: (self.cbsAccountsObj?.messages)!, completion: nil)
            }
        }
    }
}

extension AddCashMainVc: FingerprintResponseDelegate {
    func onScanComplete(fingerprintResponse: FingerprintResponse) {
        //Shakeel ! added
        if fingerprintResponse.response == Response.SUCCESS_WSQ_EXPORT {
            fingerprintPngs = fingerprintResponse.pngList
            var fingerprintsList = [FingerPrintVerification.Fingerprints]()
            
            var tempFingerPrintDictionary = [[String:Any]]()
            if let fpPNGs = fingerprintPngs {
                for item in fpPNGs {
                    guard let imageString = item.binaryBase64ObjectPNG else { return }
                    guard let instance = FingerPrintVerification.Fingerprints(fingerIndex: "\(item.fingerPositionCode)", fingerTemplate: imageString) else { return }
                   
                    tempFingerPrintDictionary.append(
                        ["fingerIndex":item.fingerPositionCode,
                         "fingerTemplate":imageString,
                         "templateType":"WSQ"]
                    )
                }
            }
            self.acccountLevelUpgrade(fingerprints: tempFingerPrintDictionary)
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

            let model: ModelFingerPrintResponse? = APIs.decodeDataToObject(data: responseData)
            self.modelFingerPrintResponse = model
        }
    }
    
    struct ModelFingerPrintResponse: Codable {
        let responsecode: Int
        let data: JSONNull?
        let messages: String
        let responseblock: JSONNull?
    }
}
