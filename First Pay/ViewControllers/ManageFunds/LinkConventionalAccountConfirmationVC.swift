//
//  LinkConventionalAccountConfirmationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 23/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper


class LinkConventionalAccountConfirmationVC: BaseClassVC {
    
    
    var genResObj : GenericResponse?

    @IBOutlet weak var lblaccountTitle: UILabel!
    @IBOutlet weak var lblaccountNumber: UILabel!
    @IBOutlet weak var lblbranchCode: UILabel!
    @IBOutlet weak var lblbranchName: UILabel!
    @IBOutlet weak var lblaccountType: UILabel!
    @IBOutlet weak var lblEnterOtp: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet  var otpTextField: UITextField!
    
    @IBOutlet weak var btnLinkNOw: UIButton!
    @IBOutlet weak var btnResentOTP: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    var accountTitle : String?
    var accountNumber : String?
    var branchCode : String?
    var branchName : String?
    var accountType: String?
    var accountTypeId: String?
    var userCnic : String?
    var userMobNo : String?
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
        
//        if self.otpReq == "N"{
//                   self.otpTextField.isHidden = true
//                   self.lblEnterOtp.isHidden = true
//               }
//               else{
//                   self.otpTextField.isHidden = false
//                   self.lblEnterOtp.isHidden = false
//               }

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Utility Methods
    
    private func clearAll(){
        
        self.lblaccountTitle.text = ""
        self.lblaccountNumber.text = ""
        self.lblbranchCode.text = ""
        self.lblbranchName.text = ""
        self.lblaccountType.text = ""
    }
    
    private func updateUI(){
        
        
        if let account = self.accountTitle{
            self.lblaccountTitle.text = account
        }
        if let acctNumber = self.accountNumber{
            self.lblaccountNumber.text = acctNumber
        }
        if let branCode = branchCode{
            self.lblbranchCode.text = branCode
        }
        if let branName = branchName{
            self.lblbranchName.text = branName
        }
        if let accType = accountType{
            self.lblaccountType.text = accType
        }
    }
    
    private func navigateToSucessScreen(message:String?){
        
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)

        alertController.addAction(UIAlertAction(title: "Success", style: .default, handler: { action in
            
            let manageFundVC = self.storyboard!.instantiateViewController(withIdentifier: "ManageFundsVC") as! ManageFundsVC
            self.navigationController!.pushViewController(manageFundVC, animated: true)
            
        }))

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Action Methods
    @IBAction func payNowPressed(_ sender: Any) {
        
        if otpTextField.text?.count == 0 {
            self.showToast(title: "Please Enter OTP")
            return
        }
        
        self.addLinkAccountCall()
    }
       @IBAction func cancelPressed(_ sender: Any) {
           self.navigationController!.popViewController(animated: true)
       }
    

    
    // MARK: - API CALL
    
    private func addLinkAccountCall() {
        
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "addLinkAccount"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","lng":"\(DataManager.instance.Longitude!)","imeiNo":DataManager.instance.imei!,"cnicNo":self.userCnic!,"lat":"\(DataManager.instance.Latitude!)","mobileNo":self.userMobNo!,"accountNo":self.accountNumber!,"otpRequired":"Y","otp":self.otpTextField.text!,"accountType":self.accountTypeId!,"accountTitle":self.accountTitle!,"branchCode":self.branchCode!,"branchName":self.branchName!]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.genResObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    
                    if let message = self.genResObj?.messages{
                        self.navigateToSucessScreen(message: message)
                    }
                }
                else {
                    if let messsage = self.genResObj?.messages{
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
