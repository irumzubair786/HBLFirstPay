//
//  BillPaymentOTPVerificationVC.swift
//  First Pay
//
//  Created by Irum Butt on 22/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import OTPTextField
import KYDrawerController
import Toaster
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper

class BillPaymentOTPVerificationVC: BaseClassVC, UITextFieldDelegate {
    var totalSecond = 60
    var timer = Timer()
    var counter = 0
    var count = 0
    var consumerNumber : String?
    var amount: String?
    var refferenceNumber:String?
    var company : String?
    var billingMonth : String?
    var amountDue : String?
    var status:String?
    var totalAmount:String?
    var dueDate :String?
    var successmodelobj : FundsTransferApiResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        TF_otp.delegate = self
        buttonback.setTitle("", for: .normal)
        buttonVerify.isUserInteractionEnabled = false
        labelMobNo.text = DataManager.instance.mobNo
        buttonResendOTP.isUserInteractionEnabled = false
        buttonResendOTVCall.isHidden = true
        startTimer()
        
        labelmessage.isHidden = true
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgNextArrow.isUserInteractionEnabled = true
        imgNextArrow.addGestureRecognizer(tapGestureRecognizerr)
    }
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var buttonResendOTP: UIButton!
    
    @IBOutlet weak var labelmessage: UILabel!
    @IBOutlet weak var buttonResendOTVCall: UIButton!
    @IBAction func buttonResendOTVCall(_ sender: UIButton) {
        buttonResendOTVCall.isUserInteractionEnabled = true
        buttonResendOTVCall.setTitleColor(.gray ,for: .normal)
        startTimer()
        ResendOTVCall()
       
        
    }
    
    @IBAction func buttonResendOTP(_ sender: UIButton) {
        
        buttonResendOTP.isUserInteractionEnabled = false
        buttonResendOTP.setTitleColor(.gray ,for: .normal)
            
              startTimer()
            ResendOTP()
        
    }
    @IBOutlet weak var TF_otp: OTPTextField!
    @IBOutlet weak var labelMobNo: UILabel!
    @IBOutlet weak var buttonback: UIButton!
    @IBAction func buttonback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var imgNextArrow: UIImageView!
    @IBOutlet weak var buttonVerify: UIButton!
    @IBAction func buttonVerify(_ sender: UIButton) {
        if TF_otp.text?.count == 0
        {
            showToast(title: "Please Enter OTP")
        }

        else{
            billPyment()
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        billPyment()
    }
    
    func startTimer() {
        totalSecond = 10
       
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
        buttonResendOTP.isUserInteractionEnabled = true
        buttonResendOTVCall.isUserInteractionEnabled = true
        count +=  1
        buttonResendOTP.setTitleColor(.orange, for: .normal)
        timer.invalidate()
        if count < 3
        {
            //            btnResendOtp.isHidden = true
            //            resendopt
        }
        else{
            buttonResendOTP.isHidden = true
            buttonResendOTVCall.isHidden = false
            
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
    @objc func changeTextInTextField() {
        
        if TF_otp.text?.count == 4
        {
            let image  = UIImage(named: "]greenarrow")
            imgNextArrow.image = image
            buttonVerify.isUserInteractionEnabled = true
        }
        else
        {
            let image = UIImage(named:"grayArrow")
            imgNextArrow.image = image
            buttonVerify.isUserInteractionEnabled = false
        }

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let image  = UIImage(named: "]greenarrow")
        imgNextArrow.image = image
        buttonVerify.isUserInteractionEnabled = true
        
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
        
        let parameters = ["mobileNo":"","otpType":  GlobalOTPTypes.OTP_BILL_PAYMENT ?? "","channelId":"\(DataManager.instance.channelID ?? "")", "cnic" : userCnic!, "otpSendType" : "OTV" ?? ""]
        
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
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
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
        let parameters = ["mobileNo":"","otpType":GlobalOTPTypes.OTP_BILL_PAYMENT  ?? "","channelId":"\(DataManager.instance.channelID ?? "")", "cnic" : userCnic!, "otpSendType" : "OTP" ?? ""]
        
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
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.genRespBaseObj = Mapper<GenericResponse>().map(JSONObject: json)
            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<VerifyOTP>) in

//            self.genRespBaseObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genRespBaseObj?.responsecode == 2 || self.genRespBaseObj?.responsecode == 1 {
                    self.labelmessage.isHidden = false
                    self.labelmessage.text = "OTP will be Resend after 30 Seconds"
//                    self.showAlertCustomPopup(title: "", message: "OTP will be Resend after 30 Seconds")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                        self.labelmessage.isHidden = true
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
    
    
    private func billPyment() {
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
        let compelteUrl = GlobalConstants.BASE_URL + "\(transactionV1or2)/billPayment"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","utilityBillCompany":GlobalData.Selected_Company_code!,"beneficiaryAccountTitle":"","utilityConsumerNo":consumerNumber!,"accountType" : DataManager.instance.accountType!,"amountPaid":amount ?? "","beneficiaryName":"","beneficiaryMobile":"","beneficiaryEmail":"","otp":TF_otp.text!,"addBeneficiary":"","utilityBillCompanyId":GlobalData.Selected_Company_id!] as [String : Any]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(parameters)
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
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.successmodelobj = Mapper<FundsTransferApiResponse>().map(JSONObject: json)
//             self.successmodelobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.successmodelobj?.responsecode == 2 || self.successmodelobj?.responsecode == 1 {
                    self.move_to_next()
//                    self.tablleview?.reloadData()
                }
                else {
                    if let message = self.successmodelobj?.messages{
                        self.showAlertCustomPopup(title: "",message: message,iconName: .iconError)
//                        self.navigateToSuccessVC()
                    }
                }
            }
            else {
                if let message = self.successmodelobj?.messages{
                        self.showAlertCustomPopup(title: "",message: message,iconName: .iconError)
//                        self.navigateToSuccessVC()
                    }

                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    func move_to_next()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BillPayment_SuccessfullVC") as! BillPayment_SuccessfullVC
        vc.refferenceNumber = refferenceNumber
        vc.totalAmount = amount
        vc.company = company
        vc.billingMonth = billingMonth
        vc.amountDue = amountDue
        vc.dueDate = dueDate
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
}
