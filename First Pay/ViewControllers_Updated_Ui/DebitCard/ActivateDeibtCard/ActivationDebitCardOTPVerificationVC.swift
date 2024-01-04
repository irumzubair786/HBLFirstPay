//
//  ActivationDebitCardOTPVerificationVC.swift
//  First Pay
//
//  Created by Irum Butt on 13/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import OTPTextField
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import SwiftyRSA
class ActivationDebitCardOTPVerificationVC: BaseClassVC, UITextFieldDelegate {
    var genResponse : GenericResponse?
    var totalSecond = 0
    var timer = Timer()
    var counter = 0
    var count = 0
    var lastFourDigit : String?
    var channel : String?
    var cardId : String?
    var accountDebitcardId : Int?
    var status : String?
    var UpdateStatusObj : OTPserviceModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        checkStatus()
        textFieldOTP.delegate.self
        buttonBack.setTitle("", for: .normal)
        butttonResendOTp.isUserInteractionEnabled = false
        butttonResendOTpCall.isHidden = true
        butttonResendOTp.setTitle("", for: .normal)
        butttonResendOTpCall.setTitle("", for: .normal)
        butttonContinue.isUserInteractionEnabled = false
        imageNextArrow.isUserInteractionEnabled = false
        labelPhoneNumber.text = DataManager.instance.accountNo
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imageNextArrow.addGestureRecognizer(tapGestureRecognizer)
        self.textFieldOTP.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        
        butttonContinue.circle()
    }
    
    func checkStatus()
    {
        if isFromDeactivate == true{
            labelMainTitle.text = "DEACTIVATE MY CARD"
        }
        if isFromChangePin == true
        {
            labelMainTitle.text = "UPDATE MY PIN"
        }
    else if isfromReactivateCard == true
        {
        labelMainTitle.text = "ACTIVATE MY CARD"
    }
        else if isfromATMON == true || isfromPOSOFF == true
        {
            labelMainTitle.text = "ATM & POS ACCESSBILITY"
        }
        
    }
    @IBOutlet weak var butttonContinue: UIButton!
    @IBOutlet weak var butttonResendOTp: UIButton!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func changeTextInTextField() {
        
        if textFieldOTP.text?.count == 4
        {
            let image = UIImage(named:"]greenarrow")
            imageNextArrow.image = image
            butttonContinue.isUserInteractionEnabled = true
            imageNextArrow.isUserInteractionEnabled = true
        }
        else
        {
            let image = UIImage(named:"grayArrow")
            imageNextArrow.image = image
            butttonContinue.isUserInteractionEnabled = false
            imageNextArrow.isUserInteractionEnabled = false
        }
        
    }
    
    @IBAction func textFieldOTp(_ sender: OTPTextField) {
        if textFieldOTP.text?.count == 4
            {
                let image = UIImage(named:"]greenarrow")
                imageNextArrow.image = image
                butttonContinue.isUserInteractionEnabled = true
                imageNextArrow.isUserInteractionEnabled = true
            }
            else
            {

                    let image = UIImage(named:"grayArrow")
                    imageNextArrow.image = image
                    butttonContinue.isUserInteractionEnabled = false
                    imageNextArrow.isUserInteractionEnabled = false
            }
        
    }
    @IBOutlet weak var textFieldOTP: OTPTextField!
    
    @IBAction func butttonResendOTp(_ sender: UIButton) {

        butttonResendOTp.isUserInteractionEnabled = false
        butttonResendOTp.setTitleColor(.gray ,for: .normal)
            
          startTimer()
//            ResendOTVCall()

        
    }
    @IBOutlet weak var butttonResendOTpCall: UIButton!
    
    @IBAction func butttonResendOTpCall(_ sender: UIButton) {
        startTimer()
//        ResendOTVCall()
    }
    @objc func timerAction() {
             counter += 1
             labelCount.text = "\(counter)"
         }
    func startTimer() {
//        totalSecond = 60
        totalSecond =  otpScreenTimeOutWithoutRegistrartion ?? 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.labelCount.text = "\(self.timeFormatted(self.totalSecond))s"
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
        butttonResendOTp.isUserInteractionEnabled = true
        count +=  1
        butttonResendOTp.setTitleColor(.black, for: .normal)
        timer.invalidate()
        if count < 3
        {
//            btnResendOtp.isHidden = true
//            resendopt
        }
        else{
            butttonResendOTp.isHidden = true
            butttonResendOTpCall.isHidden = false
//
            
        }
        
       
//
    }
    
    @IBAction func butttonContinue(_ sender: UIButton) {
//        movetoNext()
//
        if isFromChangePin == true || isFromDeactivate == true || isfromReactivateCard == true {

//            api call
            debitCardVerificationCall()
        }
        else
        {
            if isfromServics == true{
                UpdateChannelStatus()
            }
            
        }
        
//
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
       
        if  isFromChangePin == true || isFromDeactivate == true || isfromReactivateCard == true   {
//            api call
            debitCardVerificationCall()
        }
        else
        {
            if isfromServics == true{
                UpdateChannelStatus()
            }
            
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == textFieldOTP
        { textFieldOTP.isUserInteractionEnabled = true
            return newLength <= 4
//
    }
        return newLength <= 4
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("working")
        if textFieldOTP.text?.count == 4
        {
            let image = UIImage(named:"Circle-1")
            imageNextArrow.image = image
            butttonContinue.isUserInteractionEnabled = true
            imageNextArrow.isUserInteractionEnabled = true
            
        }
        else
        {
            let image = UIImage(named:"Walletno")
            imageNextArrow.image = image
            butttonContinue.isUserInteractionEnabled = false
            imageNextArrow.isUserInteractionEnabled = false
        }
        
        
    }
    
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var imageNextArrow: UIImageView!
    
    
    private func debitCardVerificationCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        self.showActivityIndicator()
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/verifyDCOtp"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"accountDebitCardId":GlobalData.accountDebitCardId!,"dcLastDigits" : DebitCardLast4digit!,"OTP" : textFieldOTP.text!] as [String : Any]
        
        
        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        FBEvents.logEvent(title: .Debit_activateotp_attempt)
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<GenericResponse>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genResponse = Mapper<GenericResponse>().map(JSONObject: json)
                
                //            self.genResponse = response.result.value
                print(self.genResponse)
                
                if response.response?.statusCode == 200 {
                    FBEvents.logEvent(title: .Debit_activateotp_success)
                    
                    if self.genResponse?.responsecode == 2 || self.genResponse?.responsecode == 1 {
                        
                        if isFromDeactivate == true {
                            //                        apicalldeactivate
                            self.changeDCStatus()
                        }
                        
                        if isfromReactivateCard == true
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivationDebitCardSetPinVC") as!  ActivationDebitCardSetPinVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        
                        if isFromChangePin == true{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivationDebitCardSetPinVC") as!  ActivationDebitCardSetPinVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
//                        if (isfromATMON ==  true || (isfromPOSON != nil) == true)
//                        {
//                            UpdateChannelStatus()
//                        }
                        
                        else
                        {
                            self.UpdateChannelStatus()
                            //
                            //                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivationDebitCardSetPinVC") as!  ActivationDebitCardSetPinVC
                            //                        self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }
                    else {
                        if let message = self.genResponse?.messages{
                            
                            self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                            
                        }
                    }
                }
                else {
                    FBEvents.logEvent(title: .Debit_activateotp_failure)
                    
                    if let message = self.genResponse?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                    }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                }
            }
        }
    }
    
//  deactivateCard
    private func changeDCStatus() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        self.showActivityIndicator()
        
        var userCnic : String?
       
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/changeDCStatus"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"accountDebitCardId":GlobalData.accountDebitCardId!,"OTP" : ""] as [String : Any]
        
        
        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<GenericResponse>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.genResponse = Mapper<GenericResponse>().map(JSONObject: json)
                
                
                //            self.genResponse = response.result.value
                print(self.genResponse)
                
                if response.response?.statusCode == 200 {
                    
                    if self.genResponse?.responsecode == 2 || self.genResponse?.responsecode == 1 {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeactivationSuccessfullyVC") as!  DeactivationSuccessfullyVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        if let message = self.genResponse?.messages{
                            
                            self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                            
                        }
                    }
                }
                else {
                    if let message = self.genResponse?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)                }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                }
            }
        }
    }
    
    private func UpdateChannelStatus() {
        FBEvents.logEvent(title: .Debit_activate_click)
        FaceBookEvents.logEvent(title: .Debit_activate_click)
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
        
//        GlobalData.debitCardChannel
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/updateChannelStatus"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["imei":"\(DataManager.instance.imei ?? "")","cnic":userCnic! ?? "" ,"channelId":DataManager.instance.channelID ,"cardid": GlobalData.cardId!  ?? "","channel": channel! ,"status": GlobalData.debitCardStatus! ?? "","otp": textFieldOTP.text! , "accountDebitCardId": "\(GlobalData.accountDebitCardId! )", "dcLastDigits": lastFourDigit! ?? ""]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //            [self] (response: DataResponse<OTPserviceModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.UpdateStatusObj = Mapper<OTPserviceModel>().map(JSONObject: json)
                
                //            self.UpdateStatusObj = response.result.value
                if response.response?.statusCode == 200 {
                    FBEvents.logEvent(title: .Debit_activate_success)
                    FaceBookEvents.logEvent(title: .Debit_activate_success)
                    if self.UpdateStatusObj?.responsecode == 2 || self.UpdateStatusObj?.responsecode == 1 {
                        self.movetoNext()
                    }
                    
                    else {
                        if let message = self.UpdateStatusObj?.messages{
                            self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                        }
                    }
                }
                else {
                    FBEvents.logEvent(title: .Debit_activateotp_failure)
                    
                    if let message = self.UpdateStatusObj?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                    }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                }
            }
        }
    }
    func movetoNext()
        {
            if isfromATMON == true  || isfromPOSON == true {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyAtmServicesVC") as! ApplyAtmServicesVC
                vc.isfromFirstTimeEnter = false
                self.navigationController?.pushViewController(vc, animated: true)
//                UpdateChannelStatus()
            }
           else if isfromATMOFF == true || isfromPOSOFF == true
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyAtmServicesVC") as! ApplyAtmServicesVC
               vc.isfromFirstTimeEnter = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
//                            if isfromServiceOTpVerification == true
//                            {
//                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyAtmServicesVC") as! ApplyAtmServicesVC
//                                isfromServiceOTpVerification = true
//                                isfromDisableService = false
//                                isfromServics = false
//                               self.navigationController?.pushViewController(vc, animated: true)
//                            }
//                            else
//                            {
//                                debitCardVerificationCall()
//                            }
//
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplyAtmServicesVC") as! ApplyAtmServicesVC
//                            isfromServiceOTpVerification = true
//                            isfromServics = false
//                           self.navigationController?.pushViewController(vc, animated: true)

    
}
