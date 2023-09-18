//
//  OTP_Mobile_VerificationVC.swift
//  First Pay
//
//  Created by Irum Butt on 09/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import PinCodeTextField
import SwiftKeychainWrapper
import LocalAuthentication
import SafariServices
import Foundation
import OTPTextField
import CoreLocation
//import OneSignal

var genericResponseObj : GenericResponse?
class OTP_Mobile_VerificationVC: BaseClassVC ,UITextFieldDelegate{
    var genericResponseObj : GenericResponse?
    var mobileRegistrationObj : mobileRegistrationModel?
    var mobileVerificationObj : mobileVerificationModel?
    var totalSecond = 60
    var timer = Timer()
    var counter = 0
    var count = 0
    var mobileNo : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_mobileno.text = DataManager.instance.mobNo
        TF_otp.becomeFirstResponder()
        labelMobileNo.text = DataManager.instance.mobNo
        TF_otp.delegate = self
        btnResendOtp.isUserInteractionEnabled = false
        btnResendotpCall.isHidden = true
        startTimer()
        labelMessage.isHidden = true
        dismissKeyboard()
        //        var a = DataManager.instance.mobNo
        //        a = a.substring(from: 1)
        //        let x = "+92\(a)"
        
        //        getOneSignalUUIDD()
        getIMEI()
        getIPAddressmac()
        getWiFiAddress()
        //        btnResendotpCall.isUserInteractionEnabled = false
        btn_next_arrow.isUserInteractionEnabled = false
        self.TF_otp.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        self.labelMessage.isHidden = true
        //        self.mobileRegistration()
        
    }
    @IBOutlet weak var popupView: UIView!
    func getOneSignalUUIDD(){
        //One Signal Start
        //                 let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        //                 let hasPrompted = status.permissionStatus.hasPrompted
        //                 print("hasPrompted = \(hasPrompted)")
        //                 let userStatus = status.permissionStatus.status
        //                 print("userStatus = \(userStatus)")
        //                 let isSubscribed = status.subscriptionStatus.subscribed
        //                 print("isSubscribed = \(isSubscribed)")
        //                 let userSubscriptionSetting = status.subscriptionStatus.userSubscriptionSetting
        //                 print("userSubscri ptionSetting = \(userSubscriptionSetting)")
        //                 let userID = status.subscriptionStatus.userId
        //                 print("userID = \(userID)")
        //                DataManager.instance.userUUID = userID
        //                 let pushToken = status.subscriptionStatus.pushToken
        //                 print("pushToken = \(pushToken)")
        //             let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
        //              print("Received Notification - \(notification?.payload.notificationID) - \(notification?.payload.title)")
        //                    }
        //One Signal End
        
    }
    override func getWiFiAddress() -> [String] {
        
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }
    
    // MARK: - Get IMEI
    func getIMEIAddress(){
        
        let str = String(describing: UIDevice.current.identifierForVendor!)
        let replacedImei = str.replacingOccurrences(of: "-", with: "")
        DataManager.instance.imei = replacedImei
        //        print(replacedImei)
        
        _ = KeyChainUtils.getUUID()!
        //         print(udid)
        
    }
    func getIPAddressmac(){
        let addr = getWiFiAddress()
        if !addr.isEmpty{
            DataManager.instance.ipAddress = addr[0]
            print(DataManager.instance.ipAddress!)
        }
        else{
            DataManager.instance.ipAddress = ""
            print("No Address")
        }
    }
    
    @IBOutlet weak var labelMobileNo: UILabel!
    @IBOutlet weak var blurView: UIImageView!
    //    -------------------------------
    //    OutLets
    //    --------------------------------
    
    @IBOutlet weak var lbl_mobileno: UILabel!
    @IBOutlet weak var lbl_countResendotptime: UILabel!
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var TF_otp: OTPTextField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnResendotpCall: UIButton!
    
    @IBOutlet weak var btn_next_arrow: UIButton!
    @IBOutlet weak var labelMessage: UILabel!
    //    -------------------------------
    //    Actions
    //    --------------------------------
    
    @IBAction func ACTION_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func Action_ResendOTP(_ sender: UIButton) {
        //    showToast(title: "OTP send Via Call")
        btnResendOtp.isUserInteractionEnabled = false
        btnResendOtp.setTitleColor(.gray ,for: .normal)
        startTimer()
        ResendOTP()
    }
    
    @IBAction func Action_OTPcall(_ sender: UIButton) {
        btnResendotpCall.isUserInteractionEnabled = true
        btnResendotpCall.setTitleColor(.gray ,for: .normal)
        //        showToast(title: "OTP send Via Call")
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
            //
            
        }
        
        
        //
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        TF_otp.resignFirstResponder()
        return true;
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
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //
    //        if TF_otp.text?.count == 4
    //        {
    //            let image = UIImage(named:"]greenarrow")
    //            btn_next_arrow.setImage(image, for: .normal)
    //            btn_next_arrow.isUserInteractionEnabled = true
    //        }
    //        else
    //        {
    //            let image = UIImage(named:"grayArrow")
    //            btn_next_arrow.setImage(image, for: .normal)
    //            btn_next_arrow.isUserInteractionEnabled = false
    //        }
    //
    //
    //
    //    }
    
    @objc func changeTextInTextField() {
        
        if TF_otp.text?.count == 4
        {
            let image = UIImage(named:"]greenarrow")
            btn_next_arrow.setImage(image, for: .normal)
            btn_next_arrow.isUserInteractionEnabled = true
        }
        else
        {
            let image = UIImage(named:"grayArrow")
            btn_next_arrow.setImage(image, for: .normal)
            btn_next_arrow.isUserInteractionEnabled = false
        }
        
    }
    
    
    
    @IBAction func BtnNextArrow(_ sender: UIButton) {
        if TF_otp.text?.count == 0
        {
            showToast(title: "Please Enter OTP")
        }
        else
        {
            mobileVerification()
            
        }
    }
    func ResendOTP() {
        //        blurView.isHidden = false
        //        popupView.isHidden = false
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getOtpOrOtv"
        
        
        let parameters = ["mobileNo":"\(DataManager.instance.mobNo)","otpType":"MNA","channelId":"\(DataManager.instance.channelID)", "cnic" :"", "otpSendType" : "OTP"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        //        print(result.apiAttribute1)
        //        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.AuthToken ?? "nil")"]
        //
        print(parameters)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //            (response: DataResponse<GenericResponse>) in
            
            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<VerifyOTP>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genRespBaseObj = Mapper<GenericResponse>().map(JSONObject: json)
                
                
                //            self.genRespBaseObj = response.result.value
                if response.response?.statusCode == 200 {
                    if self.genRespBaseObj?.responsecode == 2 || self.genRespBaseObj?.responsecode == 1 {
                        //                    self.labelMessage.isHidden = false
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
    func ResendOTVCall() {
        //        blurView.isHidden = false
        //        popupView.isHidden = false
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getOtpOrOtv"
        
        
        let parameters = ["mobileNo":"\(DataManager.instance.mobNo)","otpType": "MNA","channelId":"\(DataManager.instance.channelID)", "cnic" :"", "otpSendType" : "OTV"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        //        print(result.apiAttribute1)
        //        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.AuthToken ?? "nil")"]
        //
        print(parameters)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //            (response: DataResponse<GenericResponse>) in
            
            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<VerifyOTP>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genRespBaseObj = Mapper<GenericResponse>().map(JSONObject: json)
                
                
                //            self.genRespBaseObj = response.result.value
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
    }
    
    private func  mobileVerification() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        
        if (TF_otp.text?.isEmpty)!{
            TF_otp.text = ""
        }
        //        if (cnicTextField.text?.isEmpty)!{
        //            cnicTextField.text = ""
        //        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/mobileVerification"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel,"mobileNo": DataManager.instance.mobNo ,"imeiNo":"\(DataManager.instance.imei!)","ipAddressA":"\(DataManager.instance.ipAddress!)","ipAddressP":"\(DataManager.instance.ipAddress!)", "otpin" : TF_otp.text!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(parameters)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":DataManager.instance.AuthToken]
        print(params)
        print(compelteUrl)
        print("header ",DataManager.instance.AuthToken )
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers: header ).response { [self]
            //            (response: DataResponse<mobileVerificationModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            self.mobileVerificationObj = Mapper<mobileVerificationModel>().map(JSONObject: json)
            
            //            self.mobileVerificationObj = response.result.value
                            if response.response?.statusCode == 200 {
                                
                                if self.mobileVerificationObj?.responsecode == 2 || self.mobileVerificationObj?.responsecode == 1 {
                                    if self.mobileVerificationObj?.data?.newRegistration == "N"
                                    {
                                        //                        DataManager.instance.registerNewDevice = false
                                        UserDefaults.standard.set("true", forKey: "AlreadyRegistered")
                                        UserDefaults.standard.set("true", forKey: "FirstTimeLogin")
                                        
                                        DataManager.FirstTimeLogin = "true"
                                        let New_User_ProfileVC = self.storyboard!.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
                                        //                        DataManager.instance.AlreadtLogin = true
                                        UserDefaults.standard.set(self.mobileVerificationObj?.data?.cnic, forKey: "userCnic")
                                        KeychainWrapper.standard.hasValue(forKey: "userCnic")
                                        print("Save user cnic  is ",DataManager.instance.userCnic)
                                        DataManager.instance.userCnic = self.mobileVerificationObj?.data?.cnic
                                        print("get cnic",DataManager.instance.userCnic)
                                        
                                        self.navigationController!.pushViewController(New_User_ProfileVC, animated: true)
                                        
                                    }
                                    
                                    else{
                                        
                                        DataManager.instance.registerNewDevice = true
                                        let New_User_ProfileVC = self.storyboard!.instantiateViewController(withIdentifier: "New_User_ProfileVC") as! New_User_ProfileVC
                                        DataManager.instance.forgotPassword = false
                                        //                    DataManager.instance.mobile_number = self.TF_Mobileno
                                        
                                        self.navigationController!.pushViewController(New_User_ProfileVC, animated: true)
                                    }
                                    
                                }
                                else {
                                    if let message = self.mobileVerificationObj?.messages{
                                        self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                                    }
                                    // Html Parse
                                    
                                    if let title = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue){
                                        if title.contains("Request Rejected") {
                                            self.showDefaultAlert(title: "", message: "Network Connection Error. Contact 0800 42563")
                                        }
                                    }
                                }
                            }
            }
        }
    }
    func  mobileRegistration() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/mobileRegistration"
        let a = mobileNo!
        var mobileNumber = a.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "_", with: "")
        DataManager.instance.mobNo = mobileNumber
        let parameters = ["channelId":"\(DataManager.instance.channelID)","appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel,"mobileNo":(DataManager.instance.mobNo),"imeiNo":"\(DataManager.instance.imei!)","ipAddressA":"\(DataManager.instance.ipAddress!)","ipAddressP":"\(DataManager.instance.ipAddress!)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(parameters)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        print(params)
        print(compelteUrl)
        
        FBEvents.logEvent(title: .Signup_login_attempt)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //                (response: DataResponse<mobileRegistrationModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.mobileRegistrationObj = Mapper<mobileRegistrationModel>().map(JSONObject: json)
                
                //                self.mobileRegistrationObj = response.result.value
                if response.response?.statusCode == 200 {
                    FBEvents.logEvent(title: .Signup_login_success)
                    FaceBookEvents.logEvent(title: .Signup_login_success)
                    
                    if self.mobileRegistrationObj?.responsecode == 2 || self.mobileRegistrationObj?.responsecode == 1 {
                        if let accessToken = self.mobileRegistrationObj?.data?.token{
                            DataManager.instance.AuthToken = accessToken
                        }
                        //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        //                            self.blurView.isHidden = true
                        //                            self.popupView.isHidden = true
                        //                        }
                        
                    }
                    else {
                        if let message = self.mobileRegistrationObj?.messages{
                            self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                        }
                        
                        // Html Parse
                        
                        if let title = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue){
                            if title.contains("Request Rejected") {
                                self.showDefaultAlert(title: "", message: "Network Connection Error. Contact 0800 42563")
                            }
                        }
                    }
                }
                else {
                    if let message = self.mobileRegistrationObj?.messages {
                        FBEvents.logEvent(title: .Signup_login_success, failureReason: message)
                        FBEvents.logEvent(title: .Signup_login_failure, failureReason: message)
                        self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                    }
                    else {
                        self.showDefaultAlert(title: "Requested Rejected", message: "Network Connection Error! Please Check your internet Connection & try again.")
                    }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


