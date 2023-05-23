//
//  ForgotPassword_OTPVerificationVC.swift
//  First Pay
//
//  Created by Irum Butt on 14/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import PinCodeTextField
import SwiftKeychainWrapper
import LocalAuthentication
import SafariServices
import Foundation
import OTPTextField
class ForgotPassword_OTPVerificationVC: BaseClassVC ,UITextFieldDelegate {
    var totalSecond = 60
    var ForTransactionConsent:Bool = false
    var timer = Timer()
    var counter = 0
    var count = 0
    var verifyOtpObj : VerifyOTP?
    var mothrnameobj: GetVerifyOTp?
    var Fetch_MobNo : String?
    var fetchCnic : String?
    var genResponseObj : GenericResponseModel?
    override func viewDidLoad() {
        FBEvents.logEvent(title: .OTP_forgotpass_landed)
        super.viewDidLoad()
        print("fetch successfully mob no", Fetch_MobNo)
        lblMobNo.text = Fetch_MobNo
        TF_otp.delegate = self
        btnVerify.isUserInteractionEnabled = false
        btnResendOtp.isUserInteractionEnabled = false
        btnResendotpCall.isHidden = true
        startTimer()
        back.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        IMG_NEXT_ARROW.isUserInteractionEnabled = true
        IMG_NEXT_ARROW.addGestureRecognizer(tapGestureRecognizerr)
        getIMEI()
        self.TF_otp.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        labelMessage.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblMobNo: UILabel!
    @IBOutlet weak var IMG_NEXT_ARROW: UIImageView!
    @IBOutlet weak var lbl_countResendotptime: UILabel!
    @IBOutlet weak var Main_view: UIView!
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var TF_otp: OTPTextField!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnResendotpCall: UIButton!
    //    -------------------------------
    @IBAction func Action_ResendOTP(_ sender: UIButton) {
//    showToast(title: "OTP send")
    btnResendOtp.isUserInteractionEnabled = false
    btnResendOtp.setTitleColor(.gray ,for: .normal)
        
    startTimer()
        ResendOTP()
    }
    @IBAction func Action_OTPcall(_ sender: UIButton) {
        btnResendotpCall.isUserInteractionEnabled = true
        btnResendotpCall.setTitleColor(.gray ,for: .normal)
        startTimer()
        ResendOTVCall()
    }
    @objc func timerAction() {
             counter += 1
             lbl_countResendotptime.text = "\(counter)"
         }
    func startTimer() {
        totalSecond = 30
       
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.lbl_countResendotptime.text = "\(self.timeFormatted(self.totalSecond))s"
        print(timeFormatted(totalSecond))
        
        if totalSecond < 1  {
            endTimer()
            
        } else {
            
            totalSecond -= 1
    
//            endTimer()
            
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "0:%02d", seconds)
    }
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBAction func Action_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)    }
    @IBOutlet weak var back: UIButton!
    func endTimer()
    {
        btnResendOtp.isUserInteractionEnabled = true
        btnResendotpCall.isUserInteractionEnabled = true
        count +=  1
        btnResendOtp.setTitleColor(.orange, for: .normal)
        timer.invalidate()
        if count < 3
        {
//            btnResendOtp.isHidden = true
//            resendopt
        }
        else{
           btnResendOtp.isHidden = true
           btnResendotpCall.isHidden = false
            
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == TF_otp
        {
            TF_otp.isUserInteractionEnabled = true
            return newLength <= 4
       
    }
        return newLength <= 4
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let image  = UIImage(named: "]greenarrow")
        IMG_NEXT_ARROW.image = image
        btnVerify.isUserInteractionEnabled = true
        
    }
    @objc func changeTextInTextField() {
        
        if TF_otp.text?.count == 4
        {
            let image  = UIImage(named: "]greenarrow")
            IMG_NEXT_ARROW.image = image
            btnVerify.isUserInteractionEnabled = true
        }
        else
        {
            let image = UIImage(named:"grayArrow")
            IMG_NEXT_ARROW.image = image
            btnVerify.isUserInteractionEnabled = false
        }
    }
    @IBAction func Action_Verify(_ sender: UIButton) {
         if TF_otp.text?.count == 0
        {
            showToast(title: "Please Enter OTP")
        }

        else{
            verifyOtpResetPass()
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        verifyOtpResetPass()
    }
    
    private func verifyOtpResetPass() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        var otpType : String?

        
        if (TF_otp.text?.isEmpty)! {
            TF_otp.text = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/verifyOtpResetPass"
        
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
//        {"osVersion": "15.5", "appVersion": "3.1.2", "deviceModel": "iPhone", "channelId": "1", "mobileNo": "03406401050", "imeiNo": "B0749FED5A5D48A38C9DBFF01F4A5663", "cnic": "3740526510394", "otpin": "4231"}
        
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"mobileNo":(Fetch_MobNo!),"imeiNo":DataManager.instance.imei!,"appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel, "otpin": TF_otp.text!] as [String : Any]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        
        print(params)
        print(compelteUrl)
        
        FBEvents.logEvent(title: .OTP_forgotpass_attempt)
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponseModel>) in
            
     //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
            self.hideActivityIndicator()
            
            self.genResponseObj = response.result.value
            
            if response.response?.statusCode == 200 {
                FBEvents.logEvent(title: .OTP_forgotpass_success)

                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
                    
                    if self.genResponseObj?.messages == "OTP not verified"
                    {
                        self.showToast(title: (self.genResponseObj?.messages)!)
                    }
                    
                    else{
                        let enterPinVC = self.storyboard!.instantiateViewController(withIdentifier: "ResetPassword_SuccessfullVC") as! ResetPassword_SuccessfullVC
                        if let cnic = DataManager.instance.userCnic {
                            let saveSuccessful : Bool = KeychainWrapper.standard.set(cnic, forKey: "userCnic")
                            print("Cnic SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
//                        }
                            enterPinVC.MobNo  = self.Fetch_MobNo!
                        
                        //custAllID
                        self.navigationController!.pushViewController(enterPinVC, animated: true)
                    }
                        
                    }
                }
                
                else {
                    if let message = self.genResponseObj?.messages {
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                    }
                }
            }
            else {
                if let message = self.genResponseObj?.messages {
                    FBEvents.logEvent(title: .OTP_forgotpass_landed,failureReason: message)
                    self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                   
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    func ResendOTVCall() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getOtpOrOtv"
        let removeDashes = fetchCnic?.replacingOccurrences(of: "-", with: "")
        print("cnic is",removeDashes as Any)
        
        let parameters = ["mobileNo":"","otpType": "FP" ?? "","channelId":"\(DataManager.instance.channelID ?? "")", "cnic" : removeDashes!, "otpSendType" : "OTV" ?? ""]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        //        print(result.apiAttribute1)
        //        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.AuthToken ?? "nil")"]
        //
                print(parameters)
                print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in

            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            self.hideActivityIndicator()
            self.genRespBaseObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genRespBaseObj?.responsecode == 2 || self.genRespBaseObj?.responsecode == 1 {
     
                    
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
    func ResendOTP() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getOtpOrOtv"
     let removeDashes = fetchCnic?.replacingOccurrences(of: "-", with: "")
        print("cnic is",removeDashes)
        
        let parameters = ["mobileNo":"","otpType":"FP" ?? "","channelId":"\(DataManager.instance.channelID ?? "")", "cnic" :removeDashes! ?? "", "otpSendType" : "OTP" ?? ""]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        //        print(result.apiAttribute1)
        //        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.AuthToken ?? "nil")"]
        //
                print(parameters)
                print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in

            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            self.hideActivityIndicator()
            self.genRespBaseObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genRespBaseObj?.responsecode == 2 || self.genRespBaseObj?.responsecode == 1 {
                    self.labelMessage.isHidden = false
                    self.labelMessage.text = "OTP will be Resend after 30 Seconds"
//                    self.showAlertCustomPopup(title: "", message: "OTP will be Resend after 30 Seconds")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                        self.labelMessage.isHidden = true
//                        self.blurView.isHidden = true
//                        self.popupView.isHidden = true
                    }
//
                    
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
}
