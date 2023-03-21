//
//  LoadFromAccountConfirmationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 23/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper


class LoadFromAccountConfirmationVC: BaseClassVC {
    
    var fundSuccessObj : FundManagementSucessModel?
    
    @IBOutlet weak var lblMainTitle: UILabel!
    var mainTitle: String?
    @IBOutlet weak var lblSourceAccount: UILabel!
    var sourceAccountNo: String?
    @IBOutlet weak var lblBeneAccount: UILabel!
    var beneAccountNo : String?
    @IBOutlet weak var lblAccountTitle: UILabel!
    var accountTitle: String?
    @IBOutlet weak var lblTransferAmount: UILabel!
    var amount: String?
    @IBOutlet  var otpTextField: UITextField!
    var accountNumber: String?
    
    @IBOutlet weak var lblBA: UILabel!
    @IBOutlet weak var lblAT: UILabel!
    @IBOutlet weak var lblSA: UILabel!
    @IBOutlet weak var btnResendOTP: UIButton!
    @IBOutlet weak var lblEOTP: UILabel!
    @IBOutlet weak var lblTA: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        // Do any additional setup after loading the view.
        
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblMainTitle.text = self.mainTitle
    }
    
    
    
    func ChangeLanguage()
    {
//        self.lblMainTitle.text = self.mainTitle?.localizeString()
//        lblSA.text = "Source Account".localizeString()
//        lblBA.text = "Beneficiary Account".localizeString()
//        lblAT.text = "Account Title".localizeString()
//        lblTA.text = "Transfer Amount".localizeString()
//        lblEOTP.text = "Enter OTP".localizeString()
//        btnResendOTP.setTitle("Resend OTP via Call".localizeString(), for:.normal)
//        btnCancel.setTitle("CANCEl".localizeString(), for: .normal)
//        btnSubmit.setTitle("SUBMIT".localizeString(), for: .normal)
    
    }
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        
        if let account = self.sourceAccountNo{
            self.lblSourceAccount.text = account
        }
        if let beneAccount = beneAccountNo{
            self.lblBeneAccount.text = beneAccount
        }
        if let accountTitle = accountTitle{
            self.lblAccountTitle.text = accountTitle
        }
        if let Tamount = amount{
            self.lblTransferAmount.text = "PKR \(convertToCurrrencyFormat(amount:String(Tamount)))"
        }
    }
    
    
    
    @IBAction func otpcall(_ sender: UIButton) {
  
            
            if !NetworkConnectivity.isConnectedToInternet(){
                self.showToast(title: "No Internet Available")
                return
            }
            showActivityIndicator()
            
            let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
            
            
            let parameters = ["mobileNo":"\(DataManager.instance.accountNo!)","type":GlobalOTPTypes.OTP_BILL_PAYMENT,"channelId":"\(DataManager.instance.channelID)"]
        print(parameters)
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
        

    // MARK: - Utility Method
    
    private func navigateToSuccess(){
        let loadAccountSuccessVC = self.storyboard!.instantiateViewController(withIdentifier: "LoadFromAccountSuccessfulVC") as! LoadFromAccountSuccessfulVC
        
        loadAccountSuccessVC.mainTitle = "\(DataManager.instance.PushPullTitle ?? " ") Success"
        loadAccountSuccessVC.sourceAccountNo = self.sourceAccountNo
        loadAccountSuccessVC.beneAccountNo = self.beneAccountNo
        loadAccountSuccessVC.beneAccountTitle = self.accountTitle!
        loadAccountSuccessVC.amount = self.amount
        loadAccountSuccessVC.transferRefNumber = self.fundSuccessObj?.authIdResponse
        loadAccountSuccessVC.transferTime = self.fundSuccessObj?.transDate
        
        self.navigationController!.pushViewController(loadAccountSuccessVC, animated: true)
    }
    
    
    // MARK: - Action Methods
    @IBAction func payNowPressed(_ sender: Any) {
        
        if otpTextField.text?.count == 0 {
            self.showToast(title: "Please Enter OTP")
            return
        }
        
        self.pushPullAccountCall()
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    
    
    // MARK: - API CALL
    
    private func pushPullAccountCall() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "fundsTransferPP"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","lng":"\(DataManager.instance.Longitude!)","imeiNo":DataManager.instance.imei!,"cnicNo":userCnic!,"lat":"\(DataManager.instance.Latitude!)","amount":self.amount!,"accountNo":self.accountNumber!,"transactionType":DataManager.instance.PushPull!,"otpReq":"Y","accountTitle":self.accountTitle!,"narration":"","otp":self.otpTextField.text!,"transPurpose":"",]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        // print(header)
        print(compelteUrl)
        // print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FundManagementSucessModel>) in
            
            
            self.hideActivityIndicator()
            
            self.fundSuccessObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.fundSuccessObj?.responsecode == 2 || self.fundSuccessObj?.responsecode == 1 {
                    self.navigateToSuccess()
                }
                else {
                    
                    if let messsage = self.fundSuccessObj?.messages{
                        self.showDefaultAlert(title: "Error", message: messsage)
                    }
                    
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    
    
}
