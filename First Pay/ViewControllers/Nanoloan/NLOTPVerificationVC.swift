//
//  NLOTPVerificationVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 21/06/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class NLOTPVerificationVC: BaseClassVC {
    var verifyOtpObj : VerifyOTP?
 
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btn_Resendotp: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblNanoloan: UILabel!
    
    var genResponseObj : GenericResponse?
    var genResponse : GenericResponse?
    var amount = ""
    var otp = ""
    var loanPurpose = ""
    var totalSecond = 60
     var timer = Timer()
    var counter = 0
//    var LoanProfileimage : Data = UIImagePNGRepresentation(image) ?? Any
    var LoanProfileimage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnResend.isUserInteractionEnabled = false
        btn_Resendotp.isUserInteractionEnabled = false
        startTimer()
        Convertlanguage()
        print( "nanoloanproduct is" ,  DataManager.instance.NanoLoanProductType)
        print( "nanoloan type is ", DataManager.instance.NanoLoanType)
        print("amount is" ,    DataManager.instance.Nanoloanamount)
        print("image link is", LoanProfileimage)
        self.hideKeyboardWhenTappedAround()
        
    }
    @IBAction func enterotp(_ sender: UITextField) {
     
    }
      func Convertlanguage()
    {
        lblNanoloan.text = "Apply  Loan".addLocalizableString(languageCode: languageCode)
        optoutlet.placeholder = "Enter OTP".addLocalizableString(languageCode: languageCode)
        btnNext.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
        btnResend.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
        
    }
    @objc func timerAction() {
             counter += 1
        lblTimer.text = "\(counter)"
         }
    func startTimer() {
        totalSecond = 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.lblTimer.text = "\(self.timeFormatted(self.totalSecond))s"
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
        btn_Resendotp.isUserInteractionEnabled = true

        timer.invalidate()
       
//
    }
    
    @IBAction func next_button(_ sender: UIButton) {
        if optoutlet.text?.count == 0 {
            self.showToast(title: "Please Enter OTP")
            return
        }
        else{
            
            self.applyloanforApiCalling()
        }
    }
    
    @IBOutlet weak var optoutlet: UITextField!
    @IBAction func resend_otp(_ sender: UIButton) {
        self.otvCall()
        
    }
    @IBAction func back_pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ResendOPt_code(_ sender: UIButton) {
        ReseneOTPCode()
    }
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    
    private func otvCall() {
       startTimer()
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
       
        showActivityIndicator()

        let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
        
        let parameters = ["mobileNo":DataManager.instance.mobile_number,"type":"NL","channelId":DataManager.instance.channelID]
        
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

    
//
    private func applyloanforApiCalling() {

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
//        let compelteUrl = "http://bbuat.fmfb.pk/nanoloan/applyLoan"
        let compelteUrl = GlobalConstants.BASE_URL + "applyLoan"
//
//        changessss
        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!,"amount" : amount ,"productId":  DataManager.instance.NanoloanProductid! ,"loanPurpose" : loanPurpose, "otp": optoutlet.text!,"image": LoanProfileimage, "channelId": DataManager.instance.channelID] as [String : Any]
       

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

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GenericResponse>) in
            self.hideActivityIndicator()

            self.genResponse = response.result.value
            if
               
                    response.response?.statusCode == 200 {
                if self.genResponse?.responsecode == 2 || self.genResponse?.responsecode == 1 {
                    UserAppliedLoan = "true"
                    print("api run successfully")

                    let loanamount = "Loan amount: \(DataManager.instance.Nanoloanamount ?? "")"
                    
                    let loanpurpose = "Loan Purpose: \(DataManager.instance.NanoLoanProductType ?? "")"
                    let loantenure = "Loan Tenure:\(DataManager.instance.NanoLoanType ?? "")"
                    let message = "Your loan with following details have been approved and credited to your acoount: \n\(loanamount) \n\(loanpurpose) \n\(loantenure) \n\("Processing fee has been deducted and loan amount has been created to your Firstpay account please repay your loan on time to continue lending relationship & get higher limits in future.")"
                    let consentAlert = UIAlertController(title: "Congratulations!", message: message ,preferredStyle: UIAlertControllerStyle.alert)
                    
                    consentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController!.pushViewController(vc, animated: true)
                    }))
                    DispatchQueue.main.async {
                        self.present(consentAlert, animated: true, completion: nil)
                        
                    }

                }
                  
                else {
                    if let message = self.genResponse?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }

            else {
                if let message = self.genResponse?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
            }

            }
        }
    
    
    private func ReseneOTPCode() {
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
        let compelteUrl  = GlobalConstants.BASE_URL + "sendOtpForLoan"
        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!] as [String : Any]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GenericResponse>) in
            self.hideActivityIndicator()
            
            self.genResponse = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genResponse?.responsecode == 2 || self.genResponse?.responsecode == 1 {
                    if let message = self.genResponse?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
                else {
                    if let message = self.genResponse?.messages{
                        self.showAlert(title: (self.genResponse?.messages)! , message: message, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                        //
                    }
                }
            }
            else {
                if let message = self.genResponse?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
               print(response.result.value)
               print(response.response?.statusCode)
            }
        }
     
        
    }
    
    
    
    
    
    
    
    
   
    }
      

    



        
        
    

