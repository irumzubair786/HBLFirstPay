//
//  MSStatementVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 12/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class MSStatementVC: BaseClassVC ,UITextFieldDelegate {
    var mylonobj  : getDetailsForManualSettlement?
    var nldisbursementid = ""
    var totalSecond = 60
    var timer = Timer()
    var counter = 0
    var objotp : sendOtpForManualSettlementModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        otptextfield.delegate = self
        otptextfield.resignFirstResponder()
        btnResend.isUserInteractionEnabled = false
        btnResendOTPCode.isUserInteractionEnabled = false
        startTimer()
        lblMain.text = "My Loan".addLocalizableString(languageCode: languageCode)
        otptextfield.placeholder = "Enter OTP".addLocalizableString(languageCode: languageCode)
        lblDetail.text = "By Entering this OTP you acknowledge that you have agreed and understood all details related to loans and have accepted all terms & condition governing this loan.".addLocalizableString(languageCode: languageCode)
        btnnext.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnResend.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
        dismissKeyboard()
        
    }
    
    
    @IBOutlet weak var btncancel: UIButton!
    
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnnext: UIButton!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnResendOTPCode: UIButton!
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == otptextfield
        {
            otptextfield.isUserInteractionEnabled = true
            return newLength <= 4
       
    }
        return true
    }
    @objc func timerAction() {
             counter += 1
        lblCount.text = "\(counter)"
         }
    func startTimer() {
        totalSecond = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.lblCount.text = "\(self.timeFormatted(self.totalSecond))s"
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

        btnResend.isUserInteractionEnabled = true
        btnResendOTPCode.isUserInteractionEnabled = true

        timer.invalidate()
       
//
    }
    
    @IBAction func resendotp(_ sender: UIButton) {
        self.OTVCall()
        
    }
    
    @IBAction func ResendOPTCode(_ sender: UIButton) {
        sendOtpForManualSettlement()
    }
    @IBAction func cancel(_ sender: UIButton) {
      
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func next(_ sender: UIButton) {
        if otptextfield.text?.count == nil{
        showToast(title: "Please Enter OTP")
            
        }
        self.manualSettleLoan()
        
    }
    @IBOutlet weak var otptextfield: UITextField!
    //    http://bbuat.fmfb.pk/irisrest/manualSettleLoan
    private func manualSettleLoan() {

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
        let userSelfie: String?
        showActivityIndicator()
//       
        let compelteUrl = GlobalConstants.BASE_URL + "manualSettleLoan"

        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!, "channelId": DataManager.instance.channelID,"nlDisbursementId": nldisbursementid, "otp": otptextfield.text!] as [String : Any]

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

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<getDetailsForManualSettlement>) in
            self.hideActivityIndicator()

            self.mylonobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.mylonobj?.responsecode == 2 || self.mylonobj?.responsecode == 1 {

                    print("api run successfully")
                    if let message = self.mylonobj?.messages{
                        self.showAlert(title: "" , message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                   

                    }

                else {
                    if let message = self.mylonobj?.messages{
                        self.showAlert(title: (self.mylonobj?.messages)! , message: message, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
//                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            
        }
            else {
                if let message = self.mylonobj?.messages{
//                    tableview.isHidden = true
                    self.showDefaultAlert(title: "", message: message)
                }

            }
}
    }

    private func OTVCall() {
        startTimer()
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
      
    //    sendotp
     
        private func sendOtpForManualSettlement() {
                startTimer()
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
    //http://bbuat.fmfb.pk/irisrest/sendOtpForManualSettlement
            let compelteUrl = GlobalConstants.BASE_URL + "sendOtpForManualSettlement"

            let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!, "channelId": DataManager.instance.channelID,"nlDisbursementId" : DataManager.instance.nano_loanDisbursementId! ] as [String : Any]

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

            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<sendOtpForManualSettlementModel>) in
                self.hideActivityIndicator()

                self.objotp = response.result.value
                if response.response?.statusCode == 200 {
                    if self.objotp?.responsecode == 2 || self.objotp?.responsecode == 1 {
                       
                        if let message = self.objotp?.messages{
                            self.showDefaultAlert(title: "", message: message)
                        
                        }
                    }
                
                    else {
                        if let message = self.objotp?.messages{
                            
                            
                            if let message = self.objotp?.messages{
                                self.showAlert(title: (self.objotp?.messages)! , message: message, completion: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                        }
                    }

            }
                }
                else {
                    if let message = self.objotp?.messages{
                        self.showDefaultAlert(title: "", message: message)
                        self.navigationController?.popViewController(animated: true)
                           

                }
    }
        }
        }
    
    
    
    
    

}
