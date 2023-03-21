//
//  DebitCardActDeactOTPVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 22/10/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class DebitCardActDeactOTPVC: BaseClassVC {
    
    @IBOutlet weak var lblMainTitle : UILabel!
    var mainTitle : String?
    var accountDebitCardId : String?
    @IBOutlet  var otpTextField: UITextField!
    var isActivate : Bool = true
    var verifyOtpObj : VerifyOTP?
    var genResponseObj : GenericResponse?
    var genResponse : GenericResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpTextField.placeholder = "Enter OTP".addLocalizableString(languageCode: languageCode)
        self.updateUI()
        
       print(isActivate)
    }
    
    
    @IBOutlet weak var btnnext: UIButton!

    @IBOutlet weak var btnResendotp: UIButton!
    
    func Conertlanguage()
    {
        btnnext.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
        btnResendotp.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
    }
    // MARK: - Utility Methods
    
    func updateUI(){
       
        self.lblMainTitle.text = self.mainTitle?.addLocalizableString(languageCode: languageCode)
    }
   
    func navigateToPinScreen(){
        
        let pinVC = self.storyboard!.instantiateViewController(withIdentifier: "DebitCardPinVC") as! DebitCardPinVC
       
        pinVC.accountDebitCardId = self.accountDebitCardId
        self.navigationController!.pushViewController(pinVC, animated: true)
        
    }
    
    
    // MARK: - Action Methods
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if otpTextField.text?.count == 0 {
            self.showToast(title: "Please Enter OTP")
            return
        }
        if isActivate == true{
            self.activateCard()
        }
        else{
            self.deactivateCard()
        }
 
    }
    
    
    @IBAction func resendotp(_ sender: UIButton) {
        self.otvCall()
        
        
    }
    // MARK: - Api Call
    
    private func activateCard() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "verifyDCOtp"
        
        let parameters : Parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"accountDebitCardId":self.accountDebitCardId!,"OTP":self.otpTextField.text!]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            
            self.genResponse = response.result.value
            print(self.genResponse)
        
            if response.response?.statusCode == 200 {
                
                if self.genResponse?.responsecode == 2 || self.genResponse?.responsecode == 1 {
                    self.navigateToPinScreen()
                }
                else {
                    if let message = self.genResponse?.messages{
                        self.navigationController?.popViewController(animated: true)
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genResponse?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
//    ----------oresendotp
    private func otvCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
    
        
        showActivityIndicator()

//
        
        let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
        
        let parameters = ["mobileNo":DataManager.instance.mobile_number!,"type":DataManager.instance.otpType,"channelId":DataManager.instance.channelID]
        
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
    
//    end
    
    private func deactivateCard() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "changeDCStatus"
        
        let parameters : Parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"accountDebitCardId":self.accountDebitCardId,"OTP":self.otpTextField.text!]
        
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
        
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            
            self.genResponse = response.result.value
            print(self.genResponse)
        
            if response.response?.statusCode == 200 {
                
                if self.genResponse?.responsecode == 2 || self.genResponse?.responsecode == 1 {
                    if let message = self.genResponse?.messages{
                        self.showAlert(title: "", message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
        
                        })
                    }
                }
                else {
                    if let message = self.genResponse?.messages{
                       

                        self.showDefaultAlert(title: "", message: message)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else {
                if let message = self.genResponse?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
}
