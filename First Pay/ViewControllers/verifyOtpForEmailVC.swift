//
//  verifyOtpForEmailVC.swift
//  First Pay
//
//  Created by Irum Zubair on 13/08/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

import KYDrawerController
import Alamofire
import AlamofireObjectMapper
import MapKit
import PinCodeTextField
import SwiftKeychainWrapper
import LocalAuthentication
import SafariServices
import Foundation

class verifyOtpForEmailVC: BaseClassVC, UITextFieldDelegate {
    var email: String?
    var IsFromEmailOTp = "false"
    var responseobj : GenericResponse?
    var totalSecond = 60
     var timer = Timer()
    var counter = 0
    var mainTitle = ""
    
    @IBOutlet weak var btnresndsms: UIButton!
    //    var timer2 = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        resndotpemail.isUserInteractionEnabled = false
        btnResend.isUserInteractionEnabled = false
//        btnresndsms.isUserInteractionEnabled = false
        btnresndsms.isHidden = true
       startTimer()
        if  IsFromEmailOTp == "true"{
        
//            lblMain.text  = mainTitle
            
            otptextfield.placeholder = "Input email OTP".addLocalizableString(languageCode: languageCode)
            resndotpemail.isHidden = false
//            btnresend.isHidden = true
            otptextfield.isSecureTextEntry = true
        }
        else
        {
//            btnresndsms.isHidden = false
            otptextfield.placeholder = "Automatically Detecting OTP".addLocalizableString(languageCode: languageCode)
            resndotpemail.isHidden = true
//            btnresend.isHidden = false
        }
        if isfromVerifyEmail == "true"
        {
            lblMain.text = "Email Verification".addLocalizableString(languageCode: languageCode)
        }
        else
        {
            lblMain.text = "Update Email".addLocalizableString(languageCode: languageCode)
        }
        
        
        self.dismissKeyboard()
        otptextfield.delegate = self
        
        
        lblenterOtp.text = "Enter OTP".addLocalizableString(languageCode: languageCode)
        
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnSubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        btnResend.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
        resndotpemail.setTitle("Resend OTP".addLocalizableString(languageCode: languageCode), for: .normal)
                
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblenterOtp: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var otptextfield: UITextField!
   
    @IBOutlet weak var resndotpemail: UIButton!
    @IBOutlet weak var lblcount: UILabel!
    
    @IBOutlet weak var lblMain: UILabel!
    
    @IBAction func backpressed(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func timerAction() {
             counter += 1
             lblcount.text = "\(counter)"
         }
    func startTimer() {
        totalSecond = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.lblcount.text = "\(self.timeFormatted(self.totalSecond))s"
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
    
    func endTimer() {
//
//        btnresndsms.isUserInteractionEnabled = true
        resndotpemail.isUserInteractionEnabled = true
        btnResend.isUserInteractionEnabled = true
//        btnresendotp.isUserInteractionEnabled = true
//        btnresend.isUserInteractionEnabled = true

//        btnsubmit.isUserInteractionEnabled = false
//        btnresendotp.isUserInteractionEnabled = true
        timer.invalidate()
       
//
    }
    
    
    @IBAction func ResendOTPSMS(_ sender: UIButton) {
        generateOtpForEmail()
    }
    
    
    
    
    
    @IBAction func resendotpEmail(_ sender: UIButton) {
        startTimer()
        
//        lblcount.isHidden = true
       

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


            let compelteUrl = GlobalConstants.BASE_URL + "v2/generateOtpForEmail"
            let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

        let parameters = ["cnic":userCnic! ?? "","email": emails, "imei": DataManager.instance.imei!,"channelId": DataManager.instance.channelID]

    //        GlobalData.lat = DataManager.instance.Latitude
    //        GlobalData.long = DataManager.instance.Longitude
            print(parameters)

            let result = splitString(stringToSplit: base64EncodedString(params: parameters))
    //        print(parameters)
    //        print(result.apiAttribute1)
    //        print(result.apiAttribute2)

            let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]


            print(params)
            print(compelteUrl)

            NetworkManager.sharedInstance.enableCertificatePinning()
            print(
                DataManager.instance.accessToken)
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GenericResponse>) in
         //       Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CitiesList>) in

                self.hideActivityIndicator()

                self.responseobj = response.result.value
                if response.response?.statusCode == 200 {

                    if self.responseobj?.responsecode == 2 || self.responseobj?.responsecode == 1 {
                        
                        self.showDefaultAlert(title: "", message: "Email sent successfully....")
                        self.resndotpemail.isUserInteractionEnabled = false
                       

                    }
                    else{
                        if let message = self.responseobj?.messages{
                            self.showDefaultAlert(title: "", message: message)

                        }
                    }
                }
                else {
                    if let message = self.responseobj?.messages{
                        self.showDefaultAlert(title: "", message: message)

                    }
    //                print(response.result.value)
    //                print(response.response?.statusCode)
                } 
            }
        }
    
           
    
    

    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        if  IsFromEmailOTp == "true"
        {
            if textField == otptextfield
            {
//                btnresend.isHidden = true
//                otptextfield.keyboardType = .namePhonePad
                otptextfield.isUserInteractionEnabled = true
                return newLength <= 6
           
        }
        }
        
       else if  IsFromEmailOTp == "false"
       {
           
           otptextfield.isUserInteractionEnabled = true
//           otptextfield.keyboardType = .numberPad
           return newLength <= 4
           
       }
        
        return newLength <= 4
    }
    
    
    @IBAction func submitt(_ sender: UIButton) {
        if IsFromEmailOTp == "true"{
            
            if otptextfield.text != ""
            {
//                let getemail = UserDefaults.standard.string(forKey: "EmailVerification")
//                print("upadated email is",getemail)
                self.verifyOtpForEmail()
               
            }
            else{
                self.showDefaultAlert(title: "Error", message: "Enter OTP that's send on your Email")
            }
        }
            
    else{
            
            
        if self.otptextfield.text != ""
        {
            self.verifyMobileNumberOtpForEmail()
           
        }
        else{
            self.showDefaultAlert(title: "Error", message: "Enter OTP")
        }
            }
         
        
    }
    
    
    
    @IBOutlet weak var btnresend: UIButton!
    @IBAction func Resendotp(_ sender: UIButton) {
       
           startTimer()
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
        
        
        let parameters = ["mobileNo":"\(DataManager.instance.accountNo!)", "type": "EOV","channelId":"\(DataManager.instance.channelID)"]
        
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
                    self.btnResend.isUserInteractionEnabled = false
                    

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
    
    
    
    private func verifyOtpForEmail(){
        
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
        
        let getemail = UserDefaults.standard.string(forKey: "EmailVerification")
        let compelteUrl = GlobalConstants.BASE_URL + "v2/verifyOtpForEmail"
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
      
        let parameters = ["cnic":userCnic!, "imei": DataManager.instance.imei!, "channelId" : DataManager.instance.channelID, "ipAddress": DataManager.instance.ipAddress!,"longitude": DataManager.instance.Longitude!,"latitude": DataManager.instance.Latitude!,"email": emails, "uuid": DataManager.instance.userUUID ,"OTP": otptextfield.text!] as [String : Any]
        
        print(parameters)
        
        let result = splitString(stringToSplit: base64EncodedString(params: parameters))
     
        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
      
        
        print(params)
        print(compelteUrl)

        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
     //       Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CitiesList>) in
            
            self.hideActivityIndicator()
            
            self.responseobj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.responseobj?.responsecode == 2 || self.responseobj?.responsecode == 1 {
                    if let message = self.responseobj?.messages{
                        self.showAlert(title: "Success", message: message, completion: {
                            let addBeneVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                  self.navigationController!.pushViewController(addBeneVC, animated: true)
                        })
                    }
                    
                    
                }
                else{
                    if let message = self.responseobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                        
                    }
                }
            }
            else {
                if let message = self.responseobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                   
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    private func verifyMobileNumberOtpForEmail(){
        
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
        

        let compelteUrl = GlobalConstants.BASE_URL + "v2/verifyMobileNumberOtpForEmail"
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
      
        let parameters = ["cnic":userCnic!, "imei": DataManager.instance.imei!, "channelId" : DataManager.instance.channelID, "ipAddress": DataManager.instance.ipAddress!,"longitude": DataManager.instance.Longitude!,"latitude": DataManager.instance.Latitude!, "uuid": (DataManager.instance.userUUID ?? "") ,"OTP": otptextfield.text!] as [String : Any]
        
        print(parameters)
        
        let result = splitString(stringToSplit: base64EncodedString(params: parameters))
     
        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
      
        
        print(params)
        print(compelteUrl)

        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
     //       Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CitiesList>) in
            
            self.hideActivityIndicator()
            
            self.responseobj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.responseobj?.responsecode == 2 || self.responseobj?.responsecode == 1 {
//                    if let message = self.responseobj?.messages{
//                        self.showAlert(title: "Success", message: message, completion: {
                            let addBeneVC = self.storyboard!.instantiateViewController(withIdentifier: "GenerateOtpForEmailVC") as! GenerateOtpForEmailVC
                    IsFromUpdateEmail = "true"
                    addBeneVC.maintitle = "Update Email".addLocalizableString(languageCode: languageCode)
                                  self.navigationController!.pushViewController(addBeneVC, animated: true)
//                        })
                    }
                    
                
                else{
                    if let message = self.responseobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                       
                    }
                }
            }
            else {
                if let message = self.responseobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                   
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    
    private func generateOtpForEmail(){

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


        let compelteUrl = GlobalConstants.BASE_URL + "v2/generateOtpForEmail"
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

        let parameters = ["cnic":userCnic!,"email": DataManager.instance.Checkemail, "imei": DataManager.instance.imei!,"channelId": DataManager.instance.channelID]

//        GlobalData.lat = DataManager.instance.Latitude
//        GlobalData.long = DataManager.instance.Longitude
        print(parameters)

        let result = splitString(stringToSplit: base64EncodedString(params: parameters))
//        print(parameters)
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]


        print(params)
        print(compelteUrl)

        NetworkManager.sharedInstance.enableCertificatePinning()
        print(
            DataManager.instance.accessToken)
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
     //       Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CitiesList>) in

            self.hideActivityIndicator()

            self.responseobj = response.result.value
            if response.response?.statusCode == 200 {

                if self.responseobj?.responsecode == 2 || self.responseobj?.responsecode == 1 {
                    if let message = self.responseobj?.messages{
                        self.showDefaultAlert(title: "", message: message)

                    }
                    
                }
                else{
                    if let message = self.responseobj?.messages{
                        self.showDefaultAlert(title: "", message: message)

                    }
                }
            }
            else {
                if let message = self.responseobj?.messages{
                    self.showDefaultAlert(title: "", message: message)

                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
}
extension UITextField {
    func togglePasswordVisibility() {
        isSecureTextEntry = !isSecureTextEntry

        if let existingText = text, isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            deleteBackward()

            if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
                replace(textRange, withText: existingText)
            }
        }

        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
