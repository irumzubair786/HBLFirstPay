//
//  ServiceOTPVerificationVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 02/07/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//



import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

import SafariServices

class ServiceOTPVerificationVC: BaseClassVC {

    var cardid = ""
    var channel = ""
    var status = ""
    var DisableStatus = ""
    var accountDebitcardId = ""
    var dclastDigits = ""
    var UpdateStatusObj : OTPserviceModel?
    var genRespobj : GenericResponse?
        override func viewDidLoad() {
            super.viewDidLoad()
            print("account id is:", accountDebitcardId ?? "")
            print("status" , status)
            
    
        }
      
    @IBOutlet weak var nextbtnoutlet2: UIButton!
   
    @IBOutlet weak var otptextfield: UITextField!
    @IBAction func back_pressed(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
        }
        
        @IBAction func logout(_ sender: UIButton) {
            self.logoutUser()
        }
        
        @IBAction func textfield_otp(_ sender: UITextField) {
        }
        
        
    @IBAction func btnnextdisable(_ sender: UIButton) {
    if status == "A"
    {
        self.UpdateChannelStatus()
    }
   else
    {
    self.UpdateChannelStatusforDisable()
    }
        
        
    }
  
        
        @IBAction func btn_resendotp(_ sender: UIButton) {
            self.otvCallPressed(self)
        }
        
        
        private func OTVCall() {
    
            if !NetworkConnectivity.isConnectedToInternet(){
                self.showToast(title: "No Internet Available")
                return
            }
            showActivityIndicator()
    
            let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
    
    
            let parameters = ["mobileNo":"\(DataManager.instance.accountNo!)","type": "IE","channelId":"\(DataManager.instance.channelID)"]
    
            let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
    
    //        print(result.apiAttribute1)
    //        print(result.apiAttribute2)
    
            let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
    
            let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
    //
    //        print(params)
    //        print(compelteUrl)
    
    
            NetworkManager.sharedInstance.enableCertificatePinning()
    
            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
    
                //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
    
                self.hideActivityIndicator()
    
                self.genRespobj = response.result.value
    
                if response.response?.statusCode == 200 {
                    if self.genRespobj?.responsecode == 2 || self.genRespobj?.responsecode == 1 {
    
                        self.showDefaultAlert(title: "", message: self.genRespobj!.messages!)
    
                    }
                    else {
                        if let message = self.genRespobj?.messages {
                            self.showAlert(title: "", message: message, completion: nil)
                        }
                    }
                }
                else {
                    if let message = self.genRespobj?.messages {
                        self.showAlert(title: "", message: message, completion: nil)
                    }
    //                print(response.result.value)
    //                print(response.response?.statusCode)
    
                }
            }
        }
    private func UpdateChannelStatus() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        
        showActivityIndicator()
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "updateChannelStatus"
        
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","cardid": cardid, "channel": channel ,"status": status,"otp": otptextfield.text!, "accountDebitCardId": "\(accountDebitcardId ?? "")", "dcLastDigits": dclastDigits]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<OTPserviceModel>) in

            self.hideActivityIndicator()
            
            self.UpdateStatusObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.UpdateStatusObj?.responsecode == 2 || self.UpdateStatusObj?.responsecode == 1 {
                    

                    if let message = self.UpdateStatusObj?.messages{
                        self.showAlert(title: "Success", message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    
                   self.navigationController?.popToRootViewController(animated: true)
                    }
                
                else {
                    if let message = self.UpdateStatusObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
             if let message = self.UpdateStatusObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode) 
            }
        }
        }
    }
    
//    updatestatuschannel for disable
    private func UpdateChannelStatusforDisable() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        
        showActivityIndicator()
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "updateChannelStatus"
        
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","cardid": cardid, "channel": channel ,"status": DisableStatus,"otp": otptextfield.text!, "accountDebitCardId": accountDebitcardId, "dcLastDigits": ""] as [String : Any]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<OTPserviceModel>) in

            
            
            self.hideActivityIndicator()
            
            self.UpdateStatusObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.UpdateStatusObj?.responsecode == 2 || self.UpdateStatusObj?.responsecode == 1 {
                   
                    if let message = self.UpdateStatusObj?.messages{
                        self.showAlert(title: "Success", message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })

                    }
                    
                   self.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    if let message = self.UpdateStatusObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.UpdateStatusObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    }




