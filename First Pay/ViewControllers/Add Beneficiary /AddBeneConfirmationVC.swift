//
//  AddBeneConfirmationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 25/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class AddBeneConfirmationVC: BaseClassVC, UITextFieldDelegate {
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    
    @IBOutlet weak var lblBeneBankName: UILabel!
    @IBOutlet weak var lblBeneBankAccount: UILabel!
    @IBOutlet weak var lblAccountTitle: UILabel!
    @IBOutlet weak var lblEnterOtp: UILabel!
    @IBOutlet weak var receiveOtpOutlet: UIButton!
    
    @IBOutlet weak var btnResend: UIButton!
    
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var llMaintitle: UILabel!
    
    var genResObj : GenericResponse?
    var singleBank : SingleBank?
    
    var accountTitle : String?
    var accountNumber : String?
    var accountIMD : String?
    var bankName : String?
    var iban : String?
    var otpReq: String?
    var accountImdId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        llMaintitle.text = "Beneficiary Confirmation".addLocalizableString(languageCode: languageCode)
        btnResend.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal
        )
        btnsubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        self.updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Utility Method
    
    func updateUI(){
        
        self.lblBeneBankName.text = self.bankName
        self.lblBeneBankAccount.text = self.accountNumber
        self.lblAccountTitle.text = self.accountTitle
        self.nickNameTextField.text = self.accountTitle
        
        if self.otpReq == "N"{
            self.otpTextField.isHidden = true
            self.lblEnterOtp.isHidden = true
            self.receiveOtpOutlet.isHidden = true
        }
        else{
            self.otpTextField.isHidden = false
            self.lblEnterOtp.isHidden = false
            self.receiveOtpOutlet.isHidden = false
        }
        
    }
    
    // MARK: - UITextfield Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == mobileTextField{
            return newLength <= 11
        }
        else {
            return newLength <= 16
        }
    }
    
    // MARK: - Actions Method
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    @IBAction func submitPressed(_ sender: Any) {
        
        if self.otpReq == "Y"{
            if otpTextField.text?.count == 0 {
                self.showToast(title: "Please Enter OTP")
                return
            }
        }
        
        if emailTextField.text!.count > 0{
            if isValidEmail(testStr: emailTextField.text!)
            {
                print("Valid Email ID")
                // self.showToast(title: "Validate EmailID")
            }
            else
            {
                print("Invalid Email ID")
                self.showDefaultAlert(title: "Error", message: "Invalid Email ID")
                return
            }
            
        }
        
        
        self.saveBeneDetails()
        
    }
    @IBAction func receiveOtvCall(_ sender: Any) {
        
        self.OTVCall()
        
    }
    
    
    
    // MARK: - Api Call
    
    private func OTVCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
        
        let parameters = ["mobileNo":"\(DataManager.instance.accountNo!)","type":GlobalOTPTypes.OTP_BENEFICARY,"channelId":"\(DataManager.instance.channelID)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        print(params)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
            self.hideActivityIndicator()
            
            self.genResObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    
                    self.showDefaultAlert(title: "", message: self.genResObj!.messages!)
                    
                }
                else {
                    if let message = self.genResObj?.messages {
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.genResObj?.messages {
                    self.showAlert(title: "", message: message, completion: nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    
    private func saveBeneDetails() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "saveBeneficiary"
        
        let parameters = ["lng":"\(DataManager.instance.Longitude!)","accountTitle":self.accountTitle!,"accountNo":self.accountNumber!,"iban":self.iban!,"imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"lat":"\(DataManager.instance.Latitude!)","accountIMD":accountIMD!,"email":self.emailTextField.text!,"mobno":self.mobileTextField.text!,"otp":self.otpTextField.text!,"beneficiaryType":"IBFT","nickName":self.nickNameTextField.text!,"channelId":"\(DataManager.instance.channelID)","accountImdId":self.accountImdId!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.genResObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    
                    if let message = self.genResObj?.messages{
                        self.showAlert(title: "Success", message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
                else {
                    if let message = self.genResObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genResObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
}
