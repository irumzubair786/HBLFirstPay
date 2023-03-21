//
//  LimitVerifyVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 27/01/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

var flag = true
class LimitVerifyVC: BaseClassVC , UITextFieldDelegate{
    var verifyOtpObj : VerifyOTP?
    var genResponseObj : GenericResponse?
    var availableLimitObj: AvailableLimitsModel?
    var genResObj: GenericResponse?
    var ForTransactionConsent:Bool = false
    var userRegCnic : String?
    var homeObj : HomeModel?
    @IBOutlet weak var otpTextField: DisableEditingTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearAllFields()
        okoutlet.isEnabled = false
        otpTextField.delegate = self
        otpTextField.isUserInteractionEnabled = true
        Changelangugae()
    }
    func Changelangugae()
    {
      
        lblAccountLimmit.text = "Account Limits".addLocalizableString(languageCode: languageCode)
        otpTextField.placeholder = "Enter OTP".addLocalizableString(languageCode: languageCode)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnNext.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
        btnResendOtp.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
        
        
    }
    
    
    @IBOutlet weak var lblAccountLimmit: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var otptextfield: DisableEditingTextfield!
    
    
    @IBOutlet weak var okoutlet: UIButton!
    
    @IBAction func okaction(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AvailableLimitsVC") as! AvailableLimitsVC
         flag = true
          vc.availableLimitObj = self.availableLimitObj
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func next(_ sender: UIButton) {
        if otpTextField.text?.count == 0 {
            self.showToast(title: "Please Enter OTP")
        }
            else if(otpTextField.text?.count == 4) {
                self.changeLimitApiCall()
                
            }
        
//
        
            
//            self.verifyOTPCall()
        
    }
        @IBAction func otpcallpressed(_ sender: UIButton) {
           self.OTVCall()
        

    }
    @IBAction func resend(_ sender: UIButton) {
        
        self.OTVCall()
        
    }
    
    
    
    @IBAction func cancel(_ sender: UIButton) {
        print("done")
        self.navigationController!.popViewController(animated: true)
    }
    
    func movetonext()
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AvailableLimitsVC") as! AvailableLimitsVC
         flag = true
          vc.availableLimitObj = self.availableLimitObj
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    
//----------------------function
    
    private func clearAllFields(){
        self.otpTextField.text = ""
    }
    
   private  func sendOTPCall()
     {
        
    if !NetworkConnectivity.isConnectedToInternet(){
        self.showToast(title: "No Internet Available")
        return
    }
    showActivityIndicator()
    
    if (otpTextField.text?.isEmpty)! {
        otpTextField.text = ""
    }
    let compelteUrl = GlobalConstants.BASE_URL + "v2/changeAccLimitOtp"
    

    let params = ["":""]
    
//    let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//
//    print(result.apiAttribute1)
//    print(result.apiAttribute2)
//
//    let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
    
    let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
    
    
    print(params)
    print(compelteUrl)
    
        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
 //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
    
        self.hideActivityIndicator()
        
        self.verifyOtpObj = response.result.value
        
        if response.response?.statusCode == 200 {
            if self.verifyOtpObj?.responsecode == 2 || self.verifyOtpObj?.responsecode == 1 {
                self.changeLimitApiCall()
//                if let message = self.verifyOtpObj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//
//                }
            }
//            else {
//                if let message = self.verifyOtpObj?.messages {
//                    self.showAlert(title: "", message: message, completion: nil)
//
//                }
//            }
        }
        else {
            if let message = self.verifyOtpObj?.messages {
                self.showAlert(title: "", message: message, completion: nil)
            }
//            print(response.result.value)
//            print(response.response?.statusCode)

        }
    }
        
        
     }
//
//    ----api calling
    private func changeLimitApiCall() {

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
         

        let compelteUrl = GlobalConstants.BASE_URL + "v2/changeAcctLimits"
//        (self.availableLimitObj?.limitsData?.totalDailyLimit ??
//        let parameters : Parameters = ["cnic":userCnic!,"otp":"\(self.otpTextField.text!)","imei":DataManager.instance.imei!,"dailyAmountDr":   (self.availableLimitObj?.limitsData?.totalDailyLimit ?? -1),"dailyAmountCr": (self.availableLimitObj?.limitsData?.totalDailyLimitCr ?? -1), "monthlyAmountDr":  (self.availableLimitObj?.limitsData?.totalMonthlyLimit ?? -1),"yearlyAmountDr":  (self.availableLimitObj?.limitsData?.totalYearlyLimit ?? -1),"monthlyAmountCr": (self.availableLimitObj?.limitsData?.totalMonthlyLimitCr ?? -1),"yearlyAmountCr":  (self.availableLimitObj?.limitsData?.totalYearlyLimitCr ?? -1)]
//
        
        let parameters : Parameters = ["cnic":userCnic!,"otp":"\(self.otpTextField.text!)","imei":DataManager.instance.imei!,"dailyAmountDr":  ((dailyamountdrtext) ?? ""),"dailyAmountCr": (dailyAmountCrtext ?? ""), "monthlyAmountDr":  (monthlyAmountDrtext ?? ""),"yearlyAmountDr": ( yearlyAmountDrtext ?? ""),"monthlyAmountCr":(monthlyAmountCrtext ?? "") ,"yearlyAmountCr": (yearlyAmountCrtext ?? "")]
        
        
        
        
        
        
        
        
        print(userCnic)
        print(self.otpTextField.text!)


        print(parameters)
       
         
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

        print(result.apiAttribute1)
        print(result.apiAttribute2)

        print(params)
        print(compelteUrl)
        print(header)
       
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GenericResponse>) in

            self.hideActivityIndicator()

            self.genResObj = response.result.value
            if response.response?.statusCode == 200 {   

                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    
                
                    
                    if let message = self.genResObj?.messages{
                        self.showAlert(title: "Success", message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    
                    
//                      showAlert(title: "Success", message:  "Limit Proceed Successfully", completion: nil)
////                    self.showToast(title: "Limit Proceed Successfully")
//                    okoutlet.isEnabled = true
//
                    
//                    if let message = self.genResObj?.messages{
//                        self.showDefaultAlert(title: "", message: message)
//                        self.movetonext()

////                        self.showAlert(title:"Success", message: message, completion: {
//                              self.movetonext()
//
//
                }
                }
//                    self.movetonext()
//                }
                else {
                    if let message = self.genResObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.availableLimitObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
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
            
            self.genRespBaseObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genRespBaseObj?.responsecode == 2 || self.genRespBaseObj?.responsecode == 1 {
                    
                    self.showDefaultAlert(title: "", message: self.genRespBaseObj!.messages!)
                    
                }
                else {
                    if let message = self.genRespBaseObj?.messages {
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.genRespBaseObj?.messages {
                    self.showAlert(title: "", message: message, completion: nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    private func saveConsent() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "saveTransConsents"
        
         let parameters = ["transaction":"IBFT","channel":"MOBAPP","status":"Y","otp":self.otpTextField.text!,"cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)"]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            
            self.genResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "AvailableLimitsVC") as! AvailableLimitsVC
                   //        //   utilityInfoVC.isFromHome = true
                        self.navigationController!.pushViewController(vc, animated: true)
                }
                else {
                    if let message = self.genResponseObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
                if let message = self.genResponseObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    }
    
    
    
    


