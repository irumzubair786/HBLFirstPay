//


import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class DebitServiesVc: BaseClassVC, UITextFieldDelegate {
   var selecedchannel = ""
    var selectstatus = ""

    
    @IBOutlet weak var lblmain: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Services".addLocalizableString(languageCode: languageCode)
//        self.livechat()
        myswitch1.isEnabled = false
        myswitch2.isEnabled  = false
        btn_next.isHidden = true
        digittextfield.isHidden = true
        txtfield.delegate = self
        self.getdebitcardservices()
            }
    var chanellist : [String]?
    var servicesOBj : ServiceModel?
    var otpserviceobj : OTPserviceModel?
    var accountDebitCardId: String?
    var userData : [Cardchannels] = []
    var chatobj : livechatModel?
//    var chatdata : [ChatLive]?
//    var chatbuttons :[Buttons]?
    
    @IBOutlet weak var digittextfield: UITextField!
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var myswitch2: UISwitch!
    @IBOutlet weak var txtfield: UITextField!
    @IBOutlet weak var myswitch1: UISwitch!
    @IBOutlet weak var lblstatusPOS: UILabel!
    @IBOutlet weak var lblstatusAtm: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblpan: UILabel!
    
    @IBAction func backpressed(_ sender: UIButton) {
       
    self.navigationController?.popViewController(animated: true)
    }
    @IBAction func logout(_ sender: UIButton) {
        self.logoutUser()
    }
    @IBAction func switch_1(_ sender: UISwitch) {
        let switchState = !sender.isOn
        selecedchannel = self.lblstatusAtm.text ?? ""
        if myswitch1.isOn {
            selectstatus = "A"
            switchFlag = true
            let consentAlert = UIAlertController(title: "Alert", message: "Are you sure you want to Enable ATM services on Firstpay Debit Card".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
            
            consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                self.btn_next.isHidden = false
                self.digittextfield.isHidden = false
    //            print("Handle Ok logic here")
            }))
            
            consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
                
                self.selectstatus = "A"
                self.myswitch1.isOn = switchState
                self.btn_next.isHidden = true
                self.digittextfield.isHidden = true
                
    //            print("Handle Cancel Logic here")
            }))
            present(consentAlert, animated: true, completion: nil)
        }
        else {

            selectstatus = "I"
            switchFlag = false
            let consentAlert = UIAlertController(title: "Alert", message: "Are you sure you want to Disable ATM services on Firstpay Debit Card".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
            
            consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                self.btn_next.isHidden = true
                self.digittextfield.isHidden = true
                self.SendotpinterfaceenableForDisable()
    //            print("Handle Ok logic here") karo try ab
            }))
            consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
              
                self.myswitch1.isOn = switchState
                
                self.btn_next.isHidden = true     
                self.digittextfield.isHidden = true
              
//           consentAlert.dismiss(animated: true, completion: nil)
//
            }))
            present(consentAlert, animated: true, completion: nil)
        }

    }
    
    @IBAction func switch_2(_ sender: UISwitch) {
        let switchState = !sender.isOn

        selecedchannel = self.lblstatusPOS.text ?? ""

        if myswitch2.isOn == true {
            selectstatus = "A"
            switchFlag = true
            let consentAlert = UIAlertController(title: "Alert", message: "Are you sure you want to Enable POS services on Firstpay Debit Card".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
            
            consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                self.btn_next.isHidden = false
                self.myswitch1.isOn = true
                self.selectstatus = "A"
                self.digittextfield.isHidden = false
    //            print("Handle Ok logic here")
            }))
            
            consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
                self.btn_next.isHidden = true
                self.digittextfield.isHidden = true
    //
                self.myswitch2.isOn = switchState
            }))
            
            present(consentAlert, animated: true, completion: nil)
        }
        else {
            switchFlag = false
            selectstatus = "I"
            let consentAlert = UIAlertController(title: "Alert", message: "Are you sure you want to Disable POS services on Firstpay Debit Card".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
            
            consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                self.btn_next.isHidden = true
                self.digittextfield.isHidden = true
                self.SendotpinterfaceenableForDisable()
                
            }))
            consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
                print("nothng")
                self.myswitch2.isOn = switchState
//                self.selectstatus = "I"
                self.btn_next.isHidden = true
                self.digittextfield.isHidden = true
    //            print("Handle Cancel Logic here")
            }))
            
            present(consentAlert, animated: true, completion: nil)
        }
       
    }

    @IBAction func btn_next(_ sender: UIButton) {
        self.Sendotpinterfaceenable()
    }
    @IBAction func txtfiled_Action(_ sender: UITextField) {
    }
    
    private func getdebitcardservices() {
        
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
        if (txtfield.text?.isEmpty)!
        {
            txtfield.text  = ""
        }
    
        let compelteUrl = GlobalConstants.BASE_URL + "getInterfaceStatus"
        
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)"]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<ServiceModel>) in
            
            
            self.hideActivityIndicator()
            
            self.servicesOBj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.servicesOBj?.responsecode == 2 || self.servicesOBj?.responsecode == 1 {
                    self.myswitch1.isEnabled = true
                    self.myswitch2.isEnabled  = true
                    self.lblstatusAtm.text = "ATM".addLocalizableString(languageCode: languageCode)
                    self.lblstatusPOS.text = "POS".addLocalizableString(languageCode: languageCode)
              
                    print(self.userData = (self.servicesOBj?.data?.cardchannels)!)
                    self.chanellist = self.servicesOBj?.data?.stringlist
                
                    print("channel is" ,self.chanellist)
                    self.UpdateUI()
                    
                    
//                    if let message = self.servicesOBj?.messages{
//                        self.showAlert(title: "Success", message: message, completion: {
//
//                        })
//                    }
                }
                else {
                    if let message = self.servicesOBj?.messages{
                        if message == "No Debit Card Information Found"
                        {
                            self.showToast(title: "No Debit Card Information Found")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)  {
                                self.movetoback()
                            }

                        }

//                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
//                if let message = self.servicesOBj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    func movetoback()
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OtherHomeVC") as! OtherHomeVC
        self.navigationController?.pushViewController(vc, animated: true)
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
    func UpdateUI()
    {
//        switchFlag = false
//        POSswitchFlag = false
//        self.myswitch1.isOn = false
//        self.myswitch2.isOn = false
        if let a = self.servicesOBj?.data?.cardchannels{
            for xy in a{
                
                print("data", xy)
                print("data1", xy.channel)
                print("data2", xy.status)
                if xy.status == "A"  && xy.channel == "ATM"{
                    self.myswitch1.isOn = true
                    self.lblstatusAtm.text = xy.channel
                    btn_next.isHidden = true
                    digittextfield.isHidden = true
                }
                else if xy.status == "I"  && xy.channel == "ATM"{
                    self.myswitch1.isOn = false
                    self.lblstatusAtm.text = xy.channel
                    btn_next.isHidden = true
                    digittextfield.isHidden = true
                }
                if xy.status == "A"  && xy.channel == "POS"{
                    self.myswitch2.isOn = true
                    self.lblstatusPOS.text = xy.channel
                    btn_next.isHidden = true
                    digittextfield.isHidden = true
                }
                else if xy.status == "I"  && xy.channel == "POS"{
                    self.myswitch2.isOn = false
                    self.lblstatusPOS.text = xy.channel
                    btn_next.isHidden = true
                    digittextfield.isHidden = true
                }
                
            }
        }
    
        if let name = servicesOBj?.data?.accountDebitCard?.debitCardTitle {
            self.lblname.text = name
        }
        
        if let pan = servicesOBj?.data?.accountDebitCard?.pan
        {
            self.lblpan.text = pan
        }
        if let month = servicesOBj?.data?.accountDebitCard?.cardExpiryMonth{
            if let year = servicesOBj?.data?.accountDebitCard?.cardExpiryYear{
                lbldate.text = "\(month)" + "/ \(year)"
            }
        }
        
            if let accountID = servicesOBj?.data?.accountDebitCard?.accountDebitCardId {
                self.accountDebitCardId = "\(accountID)"
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
    
    private func Sendotpinterfaceenable() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "sendOtpForInterfaceEnable"
        
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","dcLastDigits": txtfield.text!,"accountDebitCardId":accountDebitCardId!,"status": "A"]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<OTPserviceModel>) in

            self.hideActivityIndicator()
            
            self.otpserviceobj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.otpserviceobj?.responsecode == 2 || self.otpserviceobj?.responsecode == 1 {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceOTPVerificationVC") as! ServiceOTPVerificationVC
                    vc.cardid = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
                    vc.channel = selecedchannel
                    vc.status = servicesOBj?.data?.accountDebitCard?.status ?? ""
                    vc.accountDebitcardId =  String(servicesOBj?.data?.accountDebitCard?.accountDebitCardId ?? 0)
                    print("account is:","\(String(describing: servicesOBj?.data?.accountDebitCard?.accountDebitCardId!))")
                    vc.dclastDigits = txtfield.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    }
                
                else {
                    if let message = self.otpserviceobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.servicesOBj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
//    sendotpfor disable
    private func SendotpinterfaceenableForDisable() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "sendOtpForInterfaceEnable"
        
        let parameters = ["imei":"\(String(describing: DataManager.instance.imei ?? ""))","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","accountDebitCardId": "\(accountDebitCardId!)","status" : "\("I")",   "dcLastDigits": ""]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<OTPserviceModel>) in

            
            self.hideActivityIndicator()
            
            self.otpserviceobj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.otpserviceobj?.responsecode == 2 || self.otpserviceobj?.responsecode == 1 {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceOTPVerificationVC") as! ServiceOTPVerificationVC
                    vc.cardid = servicesOBj?.data?.accountDebitCard?.cardId ?? ""
                    vc.channel = selecedchannel
                    vc.status = selectstatus
                    print("selected status is:" ,selectstatus)
                    vc.DisableStatus = "I"
                    vc.accountDebitcardId = "\(String(describing: servicesOBj?.data?.accountDebitCard?.accountDebitCardId))"
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                
                else {
                    
                    if let message = self.otpserviceobj?.messages{
                        if message == "Invalid Information provided"
                        {
                            self.showToast(title: "Invalid Information provided")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)  {
                                self.movetoback()
                            }
                           
//                            myswitch1.isOn = switchFlag
//                            myswitch2.isOn = switchFlag
                        }
                        self.showToast(title: "Invalid Information provided")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)  {
                            self.movetoback()
                        }
                        
                    }
                }
            }
            else {
//                if let message = self.servicesOBj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    private func livechat() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "liveChat"
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)", "message": "Hello"]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<livechatModel>) in

            self.hideActivityIndicator()
            self.chatobj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.chatobj?.responsecode == 2 || self.chatobj?.responsecode == 1 {
                
                    }     
                else {
                    if let message = self.chatobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.chatobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
}
