//
//  DebitCardActDeActVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 21/10/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class DebitCardActDeActVC: BaseClassVC, UITextFieldDelegate
{
    
    var getDebitDetailsObj : GetDebitCardModel?
    var userData : [DebitCardDetailsData] = []
    
    var genResponse : GenericResponse?
    
    @IBOutlet weak var mySwitch : UISwitch!
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblMonthYear : UILabel!
    @IBOutlet weak var lblCardNumber : UILabel!
    @IBOutlet weak var lblActiveDeactive : UILabel!
    
    @IBOutlet weak var imgdebitcard: UIImageView!
    @IBOutlet weak var Changepinoutlet: UIButton!
    
    @IBOutlet weak var lblMainTitle: UILabel!
    
    @IBOutlet weak var lblAciveCard: UILabel!
    
    @IBOutlet weak var createDebitCrd: UIButton!
    @IBOutlet weak var txtfilddebtcardno: UITextField!
        var accountDebitCardId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        imgdebitcard.isHidden = true
        mySwitch.isHidden = true
        txtfilddebtcardno.isHidden = true
        lblActiveDeactive.isHidden = true
        Convertlanguage()
        Changepinoutlet.isHidden = true
        txtfilddebtcardno.delegate = self
//        self.checkDCActivornot()
        
        self.getDebitCardsCall()
        
    }
    
    func Convertlanguage()
    {
    lblMainTitle.text = "Debit Card".addLocalizableString(languageCode: languageCode)
    txtfilddebtcardno.placeholder = "Enter 4 Digit Debit Card Number".addLocalizableString(languageCode: languageCode)
    lblAciveCard.text = "Activate your Card".addLocalizableString(languageCode: languageCode)
        Changepinoutlet.setTitle("Create/ChangePin".addLocalizableString(languageCode: languageCode), for: .normal)
        createDebitCrd.setTitle("Credit Debit Card".addLocalizableString(languageCode: languageCode), for: .normal)
    
    }
    
    @IBAction func createdebitcard(_ sender: UIButton) {

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == txtfilddebtcardno
        { txtfilddebtcardno.isUserInteractionEnabled = true
            return newLength <= 4
       
    }
        return true
    }
    
    
    // MARK: - Utility Methods
    
    func updateUI(){
        
        switchFlag = false
        self.mySwitch.isOn = false
        self.lblActiveDeactive.text = "Activate your Card".addLocalizableString(languageCode: languageCode)
        
        for anObject in self.userData {
            
            if let name = anObject.debitCardTitle {
                self.lblName.text = name
            }
            if let pan = anObject.pan {
                self.lblCardNumber.text = pan
            }
            if let month = anObject.cardExpiryMonth {
                if let year = anObject.cardExpiryYear{
                    self.lblMonthYear.text = "\(month)" + "/ \(year)"
                }
            }
            if let status = anObject.status{
                if status == "I" {
                    self.mySwitch.isOn = false
                    self.lblActiveDeactive.text = "Activate your Card".addLocalizableString(languageCode: languageCode)
                    Changepinoutlet.isHidden = true
                }
                else{
                    self.mySwitch.isOn = true
                    Changepinoutlet.isHidden = false
                    self.lblActiveDeactive.text = "De-Activate your card".addLocalizableString(languageCode: languageCode)
                }
            }
            if let accountID = anObject.accountDebitCardId{
                self.accountDebitCardId = "\(accountID)"
            }
        }
        
//        if mySwitch.isOn {
//            self.lblActiveDeactive.text = "De-Activate your card"
//        }
//        else{
//            self.lblActiveDeactive.text = "Activate your card"
//        }
        
    }
    
    
    func navigateToOtpScreen(){
        
        let title : String?
        let otpVC = self.storyboard!.instantiateViewController(withIdentifier: "DebitCardActDeactOTPVC") as! DebitCardActDeactOTPVC
        
        if switchFlag == true {
            title = "Activate Debit Card".addLocalizableString(languageCode: languageCode)
            otpVC.isActivate = true
        }
        else{
            title = "De-Activate Debit Card".addLocalizableString(languageCode: languageCode)
            otpVC.isActivate = false
        }
        otpVC.mainTitle = title
        otpVC.accountDebitCardId = self.accountDebitCardId
        self.navigationController!.pushViewController(otpVC, animated: true)
        
    }
    
    // MARK: - Switch Methods
    
    
    @IBAction func changepinaction(_ sender: UIButton) {
        
        if txtfilddebtcardno.text?.count == 0{
            self.showToast(title: "Please Enter Last 4 Didit Debit Card No")
            return
        }
       
        DataManager.instance.dcLastDigits = txtfilddebtcardno.text
        self.debitCardVerificationCall()
//        self.navigationController!.pushViewController(otpVC, animated: true)
        
    }
   
  
    @IBAction func switchChanged(_ sender: Any) {
        
            if self.mySwitch.isOn{
                switchFlag = true
                self.lblActiveDeactive.text = "De-Activate your card".addLocalizableString(languageCode: languageCode)
                self.debitCardVerificationCall()
//
            }else{
                switchFlag = false
                self.lblActiveDeactive.text = "Activate your card".addLocalizableString(languageCode: languageCode)
                self.debitCardDecCall()
            }
//
        }
    
    var switchFlag: Bool = false {
            didSet{               //This will fire everytime the value for switchFlag is set
                print(switchFlag) //do something with the switchFlag variable
            }
        }
    

    // MARK: - Api Call
    
    private func getDebitCardsCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
//        UtilManager.showProgress()
        self.showActivityIndicator()
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "getDebitCards"
        
        let parameters : Parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!]
        
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
       
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetDebitCardModel>) in
            
            self.hideActivityIndicator()
            
            self.getDebitDetailsObj = response.result.value
            print(self.getDebitDetailsObj ?? "")
           
            if response.response?.statusCode == 200 {
                
                if self.getDebitDetailsObj?.responsecode == 2 || self.getDebitDetailsObj?.responsecode == 1 {
                    self.imgdebitcard.isHidden = false
                    self.mySwitch.isHidden = false
                    self.txtfilddebtcardno.isHidden = false
                    self.lblActiveDeactive.isHidden = false
                    self.userData = (self.getDebitDetailsObj?.debitCardData)!
                    self.updateUI()
                }
                else {
                    if let message = self.getDebitDetailsObj?.messages{
                      
                        if message == "No Debit Card Information Found"
                        {
                            self.showToast(title: "No Debit Card Information Found")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6)  {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherHomeVC") as! OtherHomeVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }

                        }
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherHomeVC") as! OtherHomeVC
//                        self.showDefaultAlert(title: "", message: message)
//                        self.navigationController?.popViewController(animated: true)
//                        (vc, animated: true)

//                        self.present(self, animated: true, completion: nil)
                       
                       
                    }
                }
            }
            else {
                if let message = self.getDebitDetailsObj?.messages{
                    if message == "No Debit Card Information Found"
                    {
                        self.showToast(title: "No Debit Card Information Found")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)  {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherHomeVC") as! OtherHomeVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }

                    }

//                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    @objc func update() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherHomeVC") as! OtherHomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "debitCardVerification"
        
        let parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"accountDebitCardId":self.accountDebitCardId!,"dcLastDigits" : txtfilddebtcardno.text!]
        
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
                    self.imgdebitcard.isHidden = false
                    self.mySwitch.isHidden = false
                    self.txtfilddebtcardno.isHidden = false
                    self.lblActiveDeactive.isHidden = false
                
                    self.navigateToOtpScreen()
                }
                else {
                    if let message = self.genResponse?.messages{
                      
                        if message == "No Debit Card Information Found"
                        {
                            self.showToast(title: "No Debit Card Information Found")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6)  {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherHomeVC") as! OtherHomeVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }

                        }


                    }
                }
            }
            else {
//                if let message = self.genResponse?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//                    self.movetonext()
//                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    func movetonext()
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DebitCardMainVC") as! DebitCardMainVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func debitCardDecCall() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "sendOtpForDCStatusChange"
        
        let parameters : Parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!]
        
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
                    self.navigateToOtpScreen()
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
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }

}
