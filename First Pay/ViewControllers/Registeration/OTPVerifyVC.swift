//
//  OTPVerifyVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 13/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class OTPVerifyVC: BaseClassVC, UITextFieldDelegate {
    
    var my_arry  = [my_list]()
    @IBOutlet weak var otpTextField: UITextField!
    var verifyOtpObj : VerifyOTP?
    var mothrnameobj: GetVerifyOTp?
    var mothernameHandling : [UpdateMotherName]?
    var arrmothernamelist : [String]?
    var genResponseObj : GenericResponse?
    var ForTransactionConsent:Bool = false
    var userRegCnic : String?

    @IBOutlet weak var btnResendOTp: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblMainTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextField.delegate = self
        otpTextField.isUserInteractionEnabled = true
        ConvertLanguage()
        otpTextField.resignFirstResponder()
        self.clearAllFields()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Utility Methods

    private func clearAllFields(){
        self.otpTextField.text = ""
    }
    
    func ConvertLanguage()
    {
        lblMainTitle.text = "OTP".addLocalizableString(languageCode: languageCode)
        otpTextField.placeholder = "Enter OTP"
            .addLocalizableString(languageCode: languageCode)
        btnNext.setTitle("NEXT" .addLocalizableString(languageCode: languageCode), for: .normal)
        btnResendOTp.setTitle("Resend OTP via Call" .addLocalizableString(languageCode: languageCode), for: .normal)
    }
    
    // MARK: - Action Methods
  
    @IBAction func nextToEnterPass(_ sender: Any) {
    
        if otpTextField.text?.count == 0 {
            self.showToast(title: "Please Enter OTP")
            return
        }
       
        if DataManager.instance.forgotPassword == true || DataManager.instance.registerNewDevice == true {
            self.verifyOTPCallForRegForgot()
        }
        else if ForTransactionConsent == true {
            self.saveConsent()
        }
        else{
           
            self.verifyOTPCall()
        }
        
    }
    
    @IBAction func otpCallPressed(_ sender: Any) {
       self.otvCall()
    }
    
    // MARK: - API CALL
    
    
    private func otvCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
    
        
        showActivityIndicator()

//        let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall/"+String(DataManager.instance.mobile_number!)
        
        var otpType : String?
        
        if DataManager.instance.forgotPassword == true {
            otpType = "F"
        }
        if DataManager.instance.registerNewDevice == true{
            otpType = "R"
        }
        else{
            otpType = "N"
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
        
        let parameters = ["mobileNo":DataManager.instance.mobile_number!,"type":otpType!,"channelId":DataManager.instance.channelID]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json"]
        
        print(header)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
               
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
        
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.genResponseObj = response.result.value
                if let message = self.genResponseObj?.messages{
                    self.showDefaultAlert(title: "Call", message: message )
                }
            }
            else {
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    private func verifyOTPCallForRegForgot() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        var otpType : String?

        
        if (otpTextField.text?.isEmpty)! {
            otpTextField.text = ""
        }
        
        if DataManager.instance.forgotPassword == true {
            otpType = "F"
        }
        if DataManager.instance.registerNewDevice == true{
            otpType = "R"
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "verifyRegForgtOTP"
        
//        var userCnic : String?
//        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//        }
//        else{
//            userCnic = ""
//        }
        
        let parameters = ["cnic":DataManager.instance.userCnic!,"OTP":otpTextField.text!,"otptype":otpType!,"imei":DataManager.instance.imei ,"channelId":"\(DataManager.instance.channelID)"]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        
        print(params)
        print(compelteUrl)
        
       
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
     //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
            self.hideActivityIndicator()
            
            self.verifyOtpObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.verifyOtpObj?.responsecode == 2 || self.verifyOtpObj?.responsecode == 1 {
                    
                    self.showToast(title: (self.verifyOtpObj?.messages)!)
                    if DataManager.instance.registerNewDevice == true{
//                        let loginPinVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginPinVC") as! LoginPinVC
                        if let cnic = DataManager.instance.userCnic {
                            let saveSuccessful : Bool = KeychainWrapper.standard.set(cnic, forKey: "userCnic")
                            print("Cnic SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
                        }
//                        self.navigationController!.pushViewController(loginPinVC, animated: true)
                    }
                    else{
                        let enterPinVC = self.storyboard!.instantiateViewController(withIdentifier: "EnterPinVC") as! EnterPinVC
                        if let cnic = DataManager.instance.userCnic {
                            let saveSuccessful : Bool = KeychainWrapper.standard.set(cnic, forKey: "userCnic")
                            print("Cnic SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
                        }
                        enterPinVC.mainTitle = "CHANGE PASSWORD"
                        if let custID = self.verifyOtpObj?.customerAllId{
                            enterPinVC.customerID = custID
                        }
                        DataManager.instance.accessToken = self.verifyOtpObj?.token
                        //custAllID
                        self.navigationController!.pushViewController(enterPinVC, animated: true)
                    }
                }
                else {
                    if let message = self.verifyOtpObj?.messages {
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.verifyOtpObj?.messages {
                    self.showAlert(title: "", message: message, completion: nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    private func verifyOTPCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        if (otpTextField.text?.isEmpty)! {
            otpTextField.text = ""
        }
        
//
        
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "otpBioVerification"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","mobileNo":DataManager.instance.mobile_number!,"otpin":otpTextField.text!,"cnic":DataManager.instance.userCnic!,"issueDate": DataManager.instance.cnicIssueDate!,"imeiNo": DataManager.instance.imei!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(parameters)
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
         print(params)
        print(compelteUrl)
        
            NetworkManager.sharedInstance.enableCertificatePinning()

         NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GetVerifyOTp>) in                       

                
     //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
        
             self.hideActivityIndicator()
            
            self.mothrnameobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.mothrnameobj?.responsecode == 2 || self.mothrnameobj?.responsecode == 1 {
                    
                    self.showToast(title: (self.mothrnameobj?.messages)!)
                    
                    if let cnic = DataManager.instance.userCnic {
                        let saveSuccessful : Bool = KeychainWrapper.standard.set(cnic, forKey: "userCnic")
                        print("Cnic SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
                    }
                    if  mothrnameobj?.datalist != nil {
                        let temp = my_list()
                          temp.firstname = mothrnameobj?.datalist.firstName ?? ""
                        temp.mddlname = mothrnameobj?.datalist.middleName ?? ""
                      temp.lstname = mothrnameobj?.datalist.lastName ?? ""
                        if mothrnameobj?.datalist.motherNamesList?.count ?? 0 > 0 {
                            let motherNameList = mothrnameobj?.datalist.motherNamesList!
                            for tempName in motherNameList! {
                                temp.mothrname.append(tempName)
                            }
                        }
                        my_arry.append(temp)
                    }
                    
                    let personalDataVC = self.storyboard!.instantiateViewController(withIdentifier: "PersonalDataVC") as! PersonalDataVC
                    personalDataVC.my_arry2 = self.my_arry
                    self.navigationController?.pushViewController(personalDataVC, animated: true)
                }
                else {
                    if let message = self.mothrnameobj?.messages {
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.mothrnameobj?.messages {
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
                    self.navigationController?.popViewController(animated: true)
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
class my_list{
    var firstname = ""
    var mddlname = ""
    var lstname = ""
    var mothrname = [String]()
}
