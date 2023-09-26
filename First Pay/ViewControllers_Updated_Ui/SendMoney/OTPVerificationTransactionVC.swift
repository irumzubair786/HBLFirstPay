//
//  OTPVerificationTransactionVC.swift
//  First Pay
//
//  Created by Irum Butt on 18/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
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
class OTPVerificationTransactionVC: BaseClassVC, UITextFieldDelegate {
    var fundsTransSuccessObj: FundsTransferApiResponse?
    var totalSecond = 60
    var ForTransactionConsent:Bool = false
    var timer = Timer()
    var counter = 0
    var count = 0
    var amount: String?
    var number: String?
    var ToaccountTitle : String?
    var bankname : String?
    var OTPREQ : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelPhoneNo.text = DataManager.instance.accountNo
        TF_otp.delegate = self
        btnVerify.isUserInteractionEnabled = false
        btnResendOtp.isUserInteractionEnabled = false
        btnResendotpCall.isHidden = true
        startTimer()
        labelMessage.isHidden = true
        back.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        IMG_NEXT_ARROW.isUserInteractionEnabled = true
        IMG_NEXT_ARROW.addGestureRecognizer(tapGestureRecognizerr)
        self.TF_otp.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var labelPhoneNo: UILabel!
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var TF_otp: OTPTextField!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnResendotpCall: UIButton!
    @IBOutlet weak var IMG_NEXT_ARROW: UIImageView!
    @IBOutlet weak var lbl_countResendotptime: UILabel!
    
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
//
            
        }
        
       
//
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
           FundTransferIBFT()
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        FundTransferIBFT()
    }
    func ResendOTVCall() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getOtpOrOtv"
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters = ["mobileNo":"","otpType": GlobalOTPTypes.OTP_IBFT ?? "","channelId":"\(DataManager.instance.channelID ?? "")", "cnic" : userCnic!, "otpSendType" : "OTV" ?? ""]
        
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
                            self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                        }
                    }
                }
                else {
                    if let message = self.genRespBaseObj?.messages {
                        self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                    }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                    
                }
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
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["mobileNo":"","otpType":GlobalOTPTypes.OTP_IBFT ?? "","channelId":"\(DataManager.instance.channelID ?? "")", "cnic" : userCnic!, "otpSendType" : "OTP" ?? ""]
        
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
//                        self.labelMessage.isHidden = false
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
                            self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                        }
                    }
                }
                else {
                    if let message = self.genRespBaseObj?.messages {
                        self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                    }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                    
                }
            }
        }
    }
    
    // MARK: - API CALL
    
    private func FundTransferIBFT() {

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


//        let compelteUrl = GlobalConstants.BASE_URL + "fundsTransferIbft"
        let compelteUrl = GlobalConstants.BASE_URL + "\(transactionV1or2)/fundsTransferIbft"
//v2
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"accountNo":number!,"accountIMD":GlobalData.Selected_bank_code,"amount":amount!,"transPurpose":GlobalData.moneyTransferReasocCode,"accountTitle":ToaccountTitle!,"benificiaryIBAN":DataManager.instance.accountNo!,"otp": TF_otp.text ?? "","accountType":DataManager.instance.accountType!]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))

        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

        print(params)
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<FundsTransferApiResponse>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.fundsTransSuccessObj = Mapper<FundsTransferApiResponse>().map(JSONObject: json)
                
                //            self.fundsTransSuccessObj = response.result.value
                if response.response?.statusCode == 200 {
                    
                    if self.fundsTransSuccessObj?.responsecode == 2 || self.fundsTransSuccessObj?.responsecode == 1 {
                        self.movetonext()
                    }
                    else {
                        if let message = self.fundsTransSuccessObj?.messages{
                            self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                            //                        self.showToast(title: message)
                            
                        }
                    }
                }
                else {
                    if let message = self.fundsTransSuccessObj?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)                }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                }
            }
        }
    }
//
//
    
    func movetonext()
    {
//        if otpTextField?.text?.count != 0
//        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "otherWalletTransationSuccessfullVC") as! otherWalletTransationSuccessfullVC
            vc.amount = Double(amount!)
            vc.TransactionId = fundsTransSuccessObj?.data?.authIdResponse
            vc.TransactionDate = fundsTransSuccessObj?.data?.transDate
           
        var merge = "\(ToaccountTitle!)\(number!)"
        print("other wallet bank name", merge)
         vc.number = ToaccountTitle
        vc.Toaccounttitle = ToaccountTitle
        vc.AccountTitle = number
            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        
    }
 
    
    
    
    
}
