//
//  OTPLimitMangmntVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 23/12/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class OTPLimitMangmntVC: BaseClassVC,UITextFieldDelegate {
   
    @IBOutlet weak var lblMain: UILabel!
    var selectAmount: String?
    var genericob : GenericResponse?
    var GetChangeLimitObj : getChangeLimitModel?
    var LimitApplySuccessfulObj : LimitApplySuccess?
    var ATMId  = ""
    var MBid = ""
    @IBOutlet weak var lblPleaseEnterOTP: UILabel!
    
    @IBOutlet weak var lblhome: UILabel!
     @IBOutlet weak var lblContactus: UILabel!
     @IBOutlet weak var lblBookme: UILabel!
     @IBOutlet weak var lblInviteFriend: UILabel!
    @IBOutlet weak var btnResendotp: UIButton!
    @IBOutlet weak var otpTextfield: UITextField!
    
    @IBOutlet weak var btnncancel: UIButton!
    @IBOutlet weak var btnsubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeLanguage()
        otpTextfield.delegate = self
        // Do any additional setup after loading the view.
    }
    func ChangeLanguage()
    {
        lblMain.text = "Limit Management".addLocalizableString(languageCode: languageCode)
        lblPleaseEnterOTP.text = "".addLocalizableString(languageCode: languageCode)
        btnResendotp.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
        otpTextfield.placeholder = "Enter OTP".addLocalizableString(languageCode: languageCode)
        lblPleaseEnterOTP.text = "Please Enter OTP send to your mobile to change the limit".addLocalizableString(languageCode: languageCode)
        btnncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnsubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        
        
    }
    
    
    @IBAction func resendotp(_ sender: UIButton) {
        self.OTVCall()
    }
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func submit(_ sender: UIButton) {
        if ((otpTextfield.text?.isEmpty) == nil)
        {
            showToast(title: "Please Enter OTP")
            
        }
        else{
            
            if limitflag == "true"
            {
                updateChannelLimit()
            }
            if limitflag == "false"
            {
            updateChannelLimitForATmabanking()
            }
            
            
            
        }
    }
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backButtonPressed(_ sender: Any) {
            let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController!.pushViewController(homeVC, animated: true)
        }
        
        @IBAction func invitefriend(_ sender: UIButton) {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
            self.navigationController!.pushViewController(vc, animated: true)
            
        }
        
        @IBAction func golootlo(_ sender: UIButton) {
//            UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
            let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
            navigationController?.pushViewController(vc, animated: true)
        }
        
        @IBAction func contactus(_ sender: UIButton) {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.navigationController!.pushViewController(vc, animated: true)
        }
        
        @IBAction func tickets(_ sender: UIButton) {
           let  vc = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
           self.navigationController!.pushViewController(vc, animated: true)
        }
    
    private func updateChannelLimit() {
        
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
        
        //        let compelteUrl = "http://bbuat.fmfb.pk/nanoloan/getLoanPurpose"
        let compelteUrl  = GlobalConstants.BASE_URL + "updateChannelLimit"
        let parameters = ["cnic": (userCnic)!, "imei": (DataManager.instance.imei)! ?? "", "channelId": (DataManager.instance.channelID ?? ""),"amount":(selectAmount)! ?? "","frequency": (DataManager.instance.frequencyMB)! ?? "", "key": (DataManager.instance.keyMB)! ?? "","otp":(otpTextfield.text)! ?? "","limitId":(MBid),"identifier":(DataManager.instance.identifierMB ?? "")!, "transactionName":  (DataManager.instance.transactionNameMB)! ?? ""]
        
        
        //
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(compelteUrl)
        print(header)
        
                NetworkManager.sharedInstance.enableCertificatePinning()
       
             NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LimitApplySuccess>) in
//        Alamofire.request(compelteUrl, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LimitApplySuccess>) in
            self.hideActivityIndicator()
            
            self.LimitApplySuccessfulObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.LimitApplySuccessfulObj?.responsecode == 2 || self.LimitApplySuccessfulObj?.responsecode == 1 {
                    if let message = self.LimitApplySuccessfulObj?.messages{
                        self.showAlert(title: "Success", message: message, completion: {
                            self.getChannelLimits()
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                    
                }
                else {
                    if let message = self.LimitApplySuccessfulObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.LimitApplySuccessfulObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }

    
//    api for Atmbanking
    private func updateChannelLimitForATmabanking() {
        
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
        
        //        let compelteUrl = "http://bbuat.fmfb.pk/nanoloan/getLoanPurpose"
        let compelteUrl  = GlobalConstants.BASE_URL + "updateChannelLimit"
        let parameters = ["cnic": (userCnic)! ?? "", "imei": (DataManager.instance.imei)! ?? "", "channelId": (DataManager.instance.channelID) ?? "","amount":(selectAmount)! ?? "","frequency": (DataManager.instance.frequencyATM)! ?? "", "key": (DataManager.instance.keyATm)! ?? "","otp":(otpTextfield.text)! ?? "","limitId": (ATMId) ?? "","identifier":(DataManager.instance.identifierATm)! ?? "", "transactionName":  (DataManager.instance.transactionNameATm)! ?? ""]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(compelteUrl)
        print(header)
        
                NetworkManager.sharedInstance.enableCertificatePinning()
        //
             NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LimitApplySuccess>) in
//        Alamofire.request(compelteUrl, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LimitApplySuccess>) in
            self.hideActivityIndicator()
            
            self.LimitApplySuccessfulObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.LimitApplySuccessfulObj?.responsecode == 2 || self.LimitApplySuccessfulObj?.responsecode == 1 {
                    if let message = self.LimitApplySuccessfulObj?.messages{
                        self.showAlert(title: "Success", message: message, completion: {
                            self.getChannelLimits()
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                    
                }
                else {
                    if let message = self.LimitApplySuccessfulObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.LimitApplySuccessfulObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }

    private func getChannelLimits() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        showActivityIndicator()

        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }


        let compelteUrl = GlobalConstants.BASE_URL + "getChannelLimits"

        let parameters = ["cnic": userCnic!,"imei": DataManager.instance.imei!,"channelId": DataManager.instance.channelID]

        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))

        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

        print(params)
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()

       
        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<getChangeLimitModel>) in
//            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<getChangeLimitModel>) in

            self.hideActivityIndicator()

            self.GetChangeLimitObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.GetChangeLimitObj?.responsecode == 2 || self.GetChangeLimitObj?.responsecode == 1 {
                 
                }
                else {
                    if let message = self.GetChangeLimitObj?.messages{
//                        self.showDefaultAlert(title: "", message: message)
                    }
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
                if let message = self.GetChangeLimitObj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    private func OTVCall() {
           
           if !NetworkConnectivity.isConnectedToInternet(){
               self.showToast(title: "No Internet Available")
               return
           }
           showActivityIndicator()
           
           let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
           
           
           let parameters = ["mobileNo":"\(DataManager.instance.accountNo!)","type":GlobalOTPTypes.OTP_BILL_PAYMENT,"channelId":"\(DataManager.instance.channelID)"]
           
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
               
               self.genericob = response.result.value
               
               if response.response?.statusCode == 200 {
                   if self.genericob?.responsecode == 2 || self.genericob?.responsecode == 1 {
                       
                       self.showDefaultAlert(title: "", message: self.genericob!.messages!)
                       
                   }
                   else {
                       if let message = self.genericob?.messages {
                           self.showAlert(title: "", message: message, completion: nil)
                       }
                   }
               }
               else {
                   if let message = self.genericob?.messages {
                       self.showAlert(title: "", message: message, completion: nil)
                   }
   //                print(response.result.value)
   //                print(response.response?.statusCode)
                   
               }
           }
       }
}
