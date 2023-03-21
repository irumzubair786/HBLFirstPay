//
//  DebitCardRequestConfirmationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class DebitCardRequestConfirmationVC: BaseClassVC {
    
    @IBOutlet weak var  lblName: UILabel!
    var nameOnCard:String?
    @IBOutlet weak var lblDeliveryType: UILabel!
    var deliveryType:String?
    @IBOutlet weak var lblAddress: UILabel!
    var deliveryAddress:String?
    @IBOutlet weak var lblEnterOtp: UILabel!
    @IBOutlet  var otpTextField: UITextField!
    var branchCode:String?
    var otpReq: String?
    var genericObj:GenericResponse?
    
    @IBOutlet weak var lblCardConfirmation: UILabel!
   
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var otpviacalloutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Convertlanguage()
        if self.otpReq == "N"{
            self.otpTextField.isHidden = true
            self.otpviacalloutlet.isHidden = true
            self.lblEnterOtp.isHidden = true
        }
        else{
            self.otpTextField.isHidden = false
            self.lblEnterOtp.isHidden = false
            self.otpviacalloutlet.isHidden = false
        }
        
        print(nameOnCard)
        print(deliveryType)
        print(deliveryAddress)
        print(branchCode)
        print(otpReq)
        
        self.updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Utility Methods
    
    func updateUI(){
        
        self.lblName.text = self.nameOnCard
        if let deliveryType = self.deliveryType{
            if deliveryType == "S"{
               self.lblDeliveryType.text = "Branch"
            }
            else{
                self.lblDeliveryType.text = "Home"
            }
        }
        self.lblAddress.text = self.deliveryAddress
        
    }
    
    // MARK: - Action Methods
       
    func Convertlanguage()
    {
        lblCardConfirmation.text = "Card Confirmation".addLocalizableString(languageCode: languageCode)
        btnResend.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
        btnSubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
           
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if self.otpReq == "Y"{
            if otpTextField.text?.count == 0 {
                self.showToast(title: "Please Enter OTP")
                return
            }
        }
        self.debitCardRequestCall()
    }
    
     // MARK: - Api Call
    
    private func debitCardRequestCall() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "getResponseOfDebitCardCreation"
        
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"otp":self.otpTextField.text!,"channelId":"\(DataManager.instance.channelID)","NameonCard":self.nameOnCard!,"deliveryType":self.deliveryType!,"deliveryAddress":self.deliveryAddress!,"branchCode":self.branchCode!]

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
            
            self.genericObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                    
                    if let message = self.genericObj?.messages{
                        self.showAlert(title: "Success", message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
                else {
                    if let message = self.genericObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genericObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//               
            }
        }
    }
    
}
