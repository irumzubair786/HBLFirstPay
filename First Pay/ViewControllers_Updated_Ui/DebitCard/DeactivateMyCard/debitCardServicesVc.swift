//
//  debitCardServicesVc.swift
//  First Pay
//
//  Created by Irum Butt on 30/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
var serviceFlag = ""
class debitCardServicesVc: BaseClassVC, UITextFieldDelegate {
    var servicesOBj : ServiceModel?
    var selecedchannel = ""
     var selectstatus = ""
    var chanellist : [String]?
    var userData : [Cardchannels] = []
    var otpserviceobj : OTPserviceModel?
    var accountDebitCardId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchATM.isEnabled = false
        switchPOS.isEnabled  = false
        txtfield.delegate = self
        buttonBack.setTitle("", for: .normal)
        buttonContinue.isUserInteractionEnabled = false
        self.txtfield.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        
        getdebitcardservices()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
//        btn_next_arrow.isUserInteractionEnabled = true
        btn_next_arrow.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var btn_next_arrow: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var txtfield: UITextField!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func changeTextInTextField() {
        print("end editing")
        if self.txtfield.text!.count < 4
        {
            

            let image = UIImage(named:"grayArrow")
            self.btn_next_arrow.image = image
            self.buttonContinue.isUserInteractionEnabled = false
        }
        
    
    else{
        
        let image = UIImage(named:"]greenarrow")
        self.btn_next_arrow.image = image
        self.buttonContinue.isUserInteractionEnabled = true
        self.btn_next_arrow.isUserInteractionEnabled = true
    }
       
    }
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ApplyAtmServicesVC") as! ApplyAtmServicesVC
        if serviceFlag == "ATM"
        {
            Title = "ATM"
        }
        else
        {
            Title = "POS"
        }
        vc.cardId = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
        vc.channel = serviceFlag
        vc.accountDebitcardId = self.accountDebitCardId
        vc.lastFourDigit = txtfield.text!
        vc.status = selectstatus
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ApplyAtmServicesVC") as! ApplyAtmServicesVC
        if serviceFlag == "ATM"
        {
            Title = "ATM"
        }
        else
        {
            Title = "POS"
        }
        vc.cardId = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
        vc.channel = serviceFlag
        vc.accountDebitcardId = self.accountDebitCardId
        vc.lastFourDigit = txtfield.text!
        vc.status = selectstatus
        self.navigationController?.pushViewController(vc, animated: true)
        
       
    }
    
    @IBOutlet weak var switchATM: UISwitch!
    
    @IBAction func switchATM(_ sender: UISwitch) {
        let switchState = !sender.isOn
        if switchATM.isOn {
            selectstatus = "A"
            switchFlag = true
//            move to new
            serviceFlag = "ATM"
            let vc = storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as! ActivationFourDigitNumberVc
            isfromServics = true
            vc.cardId = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
            vc.channel = serviceFlag
            vc.accountDebitcardId = self.accountDebitCardId
            vc.lastFourDigit = txtfield.text!
            vc.status = selectstatus
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
            selectstatus = "I"
            switchFlag = false
            let vc = storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as! ActivationFourDigitNumberVc
            isfromServics = true
            vc.cardId = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
            vc.channel = serviceFlag
            vc.accountDebitcardId = self.accountDebitCardId
            vc.lastFourDigit = txtfield.text!
            vc.status = selectstatus
            self.navigationController?.pushViewController(vc, animated: true)
//            self.updateChannelStatus()
        }
        
    }
    
    
    @IBOutlet weak var switchPOS: UISwitch!
    
    @IBAction func switchPOS(_ sender: UISwitch) {
        let switchState = !sender.isOn
        if switchPOS.isOn == true {
            selectstatus = "A"
            serviceFlag = "POS"
            switchFlag = true
            let vc = storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as! ActivationFourDigitNumberVc
            isfromServics = true
            vc.cardId = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
            vc.channel = serviceFlag
            vc.accountDebitcardId = self.accountDebitCardId
            vc.lastFourDigit = txtfield.text!
            vc.status = selectstatus
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            switchFlag = false
            selectstatus = "I"
            let vc = storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as! ActivationFourDigitNumberVc
            isfromServics = true
            vc.cardId = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
            vc.channel = serviceFlag
            vc.accountDebitcardId = self.accountDebitCardId
            vc.lastFourDigit = txtfield.text!
            vc.status = selectstatus
            self.navigationController?.pushViewController(vc, animated: true)
//            self.SendotpinterfaceenableForDisable()
        }
        
        
        
        
        
    }
    
    var switchFlag: Bool = false {
            didSet{               //This will fire everytime the value for switchFlag is set
                print(switchFlag) //do something with the switchFlag variable
            }
        }
    var POSswitchFlag: Bool = false{
        didSet{
            print(POSswitchFlag)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == txtfield
        { txtfield.isUserInteractionEnabled = true
            return newLength <= 4
       
    }
        return newLength <= 4
    }
    
    private func getdebitcardservices() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        if (txtfield.text?.isEmpty)!
        {
            txtfield.text  = ""
        }
    
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
    
        showActivityIndicator()
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
    
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/getInterfaceStatus"
        
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)"]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<ServiceModel>) in
            
            
            self.hideActivityIndicator()
            
            self.servicesOBj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.servicesOBj?.responsecode == 2 || self.servicesOBj?.responsecode == 1 {
                    self.switchATM.isEnabled = true
                    self.switchPOS.isEnabled  = true
                   
                    print(self.userData = (self.servicesOBj?.data?.cardchannels)!)
                    self.chanellist = self.servicesOBj?.data?.stringlist
                
                    print("channel is" ,self.chanellist)
                    self.UpdateUI()

                }
                else {
                    if let message = self.servicesOBj?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)  {
                                self.navigationController?.popViewController(animated: true)
//
                            }

                        }

                    }
                }
            }
           
        }
    func UpdateUI()
    {
//        switchFlag = false
//        POSswitchFlag = false
//        self.myswitch1.isOn = false
//        self.myswitch2.isOn = false
        if let a = self.servicesOBj?.data?.cardchannels{
            for xy in a{
               
                print("data", xy)
                print("data1", xy.channel!)
                print("data2", xy.status!)
                if xy.status == "A"  && xy.channel == "ATM"{
                    self.switchATM.isOn = true
                  
                }
                else if xy.status == "I"  && xy.channel == "ATM"{
                    self.switchATM.isOn = false
                    
                }
                if xy.status == "A"  && xy.channel == "POS"{
                    self.switchPOS.isOn = true
                    
                }
                else if xy.status == "I"  && xy.channel == "POS"{
                    self.switchPOS.isOn = false
                
                }
                if let accountID = servicesOBj?.data?.accountDebitCard?.accountDebitCardId {
                    self.accountDebitCardId = (accountID)
                }
                
            }
        }
       
    }
    
//    //    sendotpfor disable
//        private func updateChannelStatus() {
//
//            if !NetworkConnectivity.isConnectedToInternet(){
//                self.showToast(title: "No Internet Available")
//                return
//            }
//
//            var userCnic : String?
//
//            if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//                userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//            }
//            else{
//                userCnic = ""
//            }
//
////            "imei":"031B64E3CAC84DBA90E32A78A3B5A84D",
////                "cnic":"1730116660375",
////                "dcLastDigits":"0026",
////                "accountDebitCardId":"1",
////                "cardid":"830205",
////                "channel":"ATM",   // ATM / POS
////                "otp":"1758",
////            "status":"I",   //possible status are 'A' for 'Active' and 'I' for 'Inactive'
//////                "channelId":"3"
//            showActivityIndicator()
//
//            let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/updateChannelStatus"
//
//            let parameters = ["imei":"\(String(describing: DataManager.instance.imei ?? ""))","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","accountDebitCardId": "\(accountDebitCardId!)","status" : "\("I")",   "dcLastDigits": "", "otp":"","channel": ]
//            print(parameters)
//            let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//
//
//            print(result.apiAttribute1)
//            print(result.apiAttribute2)
//
//            let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//
//            let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//
//            print(params)
//            print(compelteUrl)
//
//            NetworkManager.sharedInstance.enableCertificatePinning()
//            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<OTPserviceModel>) in
//
//
//                self.hideActivityIndicator()
//
//                self.otpserviceobj = response.result.value
//                if response.response?.statusCode == 200 {
//
//                    if self.otpserviceobj?.responsecode == 2 || self.otpserviceobj?.responsecode == 1 {
//
////                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceOTPVerificationVC") as! ServiceOTPVerificationVC
////                        vc.cardid = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
////                        vc.channel = selecedchannel
////                        vc.status = selectstatus
////                        print("selected status is:" ,selectstatus)
////                        vc.DisableStatus = "I"
////                        vc.accountDebitcardId = "\(String(describing: servicesOBj?.data?.accountDebitCard?.accountDebitCardId))"
////                        self.navigationController?.pushViewController(vc, animated: true)
//                        }
//
//                    else {
//
//                        if let message = self.otpserviceobj?.messages{
//                            if message == "Invalid Information provided"
//                            {
//                                self.showToast(title: "Invalid Information provided")
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)  {
////                                    self.movetoback()
//                                }
//
//    //                            myswitch1.isOn = switchFlag
//    //                            myswitch2.isOn = switchFlag
//                            }
//                            self.showToast(title: "Invalid Information provided")
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)  {
//                                self.movetoback()
//                            }
//
//                        }
//                    }
//                }
//                else {
//    //                if let message = self.servicesOBj?.messages{
//    //                    self.showDefaultAlert(title: "", message: message)
//    //                }
//    //                print(response.result.value)
//    //                print(response.response?.statusCode)
//                }
//            }
//        }
    
    }

