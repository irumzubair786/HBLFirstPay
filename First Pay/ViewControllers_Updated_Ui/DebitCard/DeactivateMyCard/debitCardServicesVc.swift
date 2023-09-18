//
//  debitCardServicesVc.swift
//  First Pay
//
//  Created by Irum Butt on 30/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
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
    var lastFourDigit : String?
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
    override func viewWillAppear(_ animated: Bool) {
        
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
       
        
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {
       
    }
    
    @IBOutlet weak var switchATM: UISwitch!
    
    @IBAction func switchATM(_ sender: UISwitch) {
        serviceFlag = "ATM"
        let switchState = !sender.isOn
        if switchATM.isOn {
            selectstatus = "A"
            switchFlag = true
//            move to new
         
            let vc = storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as! ActivationFourDigitNumberVc
            isfromATMON = true
            vc.cardId = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
            vc.channel = serviceFlag
            vc.accountDebitcardId = self.accountDebitCardId
            vc.lastFourDigit = txtfield.text!
            self.selectstatus = "A"
            vc.status = selectstatus
            self.switchATM.isOn = switchState
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else {
            
            selectstatus = "I"
            switchFlag = false
            let vc = storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as! ActivationFourDigitNumberVc
            isfromATMOFF = true
            
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
        serviceFlag = "POS"
        let switchState = !sender.isOn
        if switchPOS.isOn == true {
            selectstatus = "A"
           
            switchFlag = true
            let vc = storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as! ActivationFourDigitNumberVc
            isfromPOSON = true
            vc.cardId = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
            vc.channel = serviceFlag
            vc.accountDebitcardId = self.accountDebitCardId
            vc.lastFourDigit = txtfield.text!
            self.switchATM.isOn = true
            self.selectstatus = "A"
            vc.status = selectstatus
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            switchFlag = false
            selectstatus = "I"
            let vc = storyboard?.instantiateViewController(withIdentifier: "ActivationFourDigitNumberVc") as! ActivationFourDigitNumberVc
            isfromPOSOFF = true
           
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
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //            (response: DataResponse<ServiceModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.servicesOBj = Mapper<ServiceModel>().map(JSONObject: json)
                
                //            self.servicesOBj = response.result.value
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

    }

