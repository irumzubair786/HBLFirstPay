//
//  CreateWalletRegVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 13/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//
 
import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class CreateWalletRegVC: BaseClassVC , UITextFieldDelegate {
   
    @IBOutlet  var mobileNumberTextField: UITextField!
    @IBOutlet  var cnicTextField: UITextField!
    @IBOutlet  var cnicIssueTextField: UITextField!
    @IBOutlet var dropDownMobileNetworks: UIDropDown!
    var genericResponseObj : GenericResponse?
    var networkListObj : NewtorkList?
    var arrNetworkList : [String]?
    var networkID: Int?
    var networkCode: String?
    var networkDescr: String?
    @IBOutlet weak var lblMainTitle: UILabel!
    //var cnicIssueDate = NSDate()
    
    
    @IBOutlet weak var btnnext: UIButton!
    let systemVersion = UIDevice.current.systemVersion
    let devicemodel = UIDevice.current.localizedModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConvertLanguage()
        cnicTextField.delegate = self
        mobileNumberTextField.delegate = self
        cnicIssueTextField.delegate = self
        
        //   self.getNetwork()
    
        
        if DataManager.instance.forgotPassword == true{
            self.lblMainTitle.text = "Forgot Password".addLocalizableString(languageCode: languageCode)
            self.cnicIssueTextField.isHidden = true
        }
        else if DataManager.instance.registerNewDevice == true{
            self.lblMainTitle.text = "Register Device".addLocalizableString(languageCode: languageCode)
            self.cnicIssueTextField.isHidden = true
        }
        else{
            self.lblMainTitle.text = "Create Wallet".addLocalizableString(languageCode: languageCode)
        }
        
        // Do any additional setup after loading the view.
    }
func ConvertLanguage()
    {
       
        if DataManager.instance.registerNewDevice == true{
            self.lblMainTitle.text = "Register Device".addLocalizableString(languageCode: languageCode)
            self.cnicIssueTextField.isHidden = true
        }
        
        mobileNumberTextField.placeholder = "Enter Your Mobile Number".addLocalizableString(languageCode: languageCode)
        cnicTextField.placeholder = "Enter Your CNIC Number".addLocalizableString(languageCode: languageCode)
        btnnext.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
        
        cnicIssueTextField.placeholder = "CNIC Issue Date".addLocalizableString(languageCode: languageCode)
        
        
    }
    
    
    //MARK: - DropDown
    
    //    private func methodDropDownMobileNetworks(Telcos:[String]) {
    //
    //        self.dropDownMobileNetworks.placeholder = "Select Mobile Network"
    //        self.dropDownMobileNetworks.tableHeight = 135.0
    //        self.dropDownMobileNetworks.rowBackgroundColor = #colorLiteral(red: 0.4700977206, green: 0.5852692723, blue: 0.7767686844, alpha: 1)
    //        self.dropDownMobileNetworks.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    //        self.dropDownMobileNetworks.optionsTextColor =  #colorLiteral(red: 0.9066727757, green: 0.9018580317, blue: 0.9103838205, alpha: 1)
    //        self.dropDownMobileNetworks.options = Telcos
    //        self.dropDownMobileNetworks.didSelect(completion: {
    //            (option , index) in
    //            print("You Just select: \(option) at index: \(index)")
    //            //            self.sourceAccount = option
    //
    //            let network = option
    //            for aNetwork in (self.networkListObj?.networkList)! {
    //                if aNetwork.networkDescr == network {
    //                    self.networkCode = aNetwork.networkCode
    //                    self.networkID = aNetwork.networkId
    //                    self.networkDescr = aNetwork.networkDescr
    //                }
    //            }
    //        })
    //    }
    
    // MARK: - UITextfield Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == mobileNumberTextField
        { mobileNumberTextField.isUserInteractionEnabled = true
            return newLength <= 11
        }
        if textField == cnicTextField{
            cnicTextField.isUserInteractionEnabled = true
            return newLength <= 13
        }
        else {
            cnicIssueTextField.isUserInteractionEnabled = true
            return newLength <= 16
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == mobileNumberTextField {
            cnicTextField .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
        } else if textField == cnicTextField {
            textField.resignFirstResponder()
        }
    }
    
    //MARK: - DatePicker Methods
    
    
    @IBAction func textFieldCnicIssueEditing(sender: UITextField) {
        
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        datePickerObj.maximumDate = datePickerObj.date
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: datePickerObj.date)
        self.cnicIssueTextField.text = newDate
        
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        cnicIssueTextField.text = dateFormatter.string(from: sender.date)
        //   DataManager.instance.cnicIssueDate =  sender.date as NSDate
        DataManager.instance.cnicIssueDate =  cnicIssueTextField.text
        
    }
    
    
    //MARK: - Action Methods
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if mobileNumberTextField.text?.count == 0{
            self.showToast(title: "Please Enter Mobile Number")
            return
        }
        if cnicTextField.text?.count == 0{
            self.showToast(title: "Please Enter CNIC")
            return
        }
        if cnicTextField.text?.count ?? 0 < 13
        {
            self.showToast(title: "Please Enter 13 Digit CNIC Number")
            return
        }
        
 
        DataManager.instance.userCnic = cnicTextField.text
       
        
        //        if DataManager.instance.registerNewDevice == false {
        //            if self.networkID == nil || self.networkCode == nil || self.networkDescr == nil{
        //                self.showToast(title: "Please Select Your Network")
        //                return
        //            }
        //        }
        
        if DataManager.instance.forgotPassword == true || DataManager.instance.registerNewDevice == true{
//
            self.createWalletRegForButtonPressed()
        }
        else{
            
            if cnicIssueTextField.text?.count == 0{
                self.showToast(title: "Please Enter Cnic Issue Date")
                return
            }
            
            self.createWalletButtonPressed()
            print(systemVersion)
        }
        
        
    }
    
    //MARK: - API CALL
    
    //    private func getNetwork(){
    //
    //
    //        if !NetworkConnectivity.isConnectedToInternet(){
    //            self.showToast(title: "No Internet Available")
    //            return
    //        }
    //        showActivityIndicator()
    //
    //        let compelteUrl = GlobalConstants.BASE_URL + "rest/getAllNetworks"
    //        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecret]
    //
    //        print(header)
    //        print(compelteUrl)
    //
    //        NetworkManager.sharedInstance.enableCertificatePinning()
    //
    //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<NewtorkList>) in
    //
    //     //  Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<NewtorkList>) in
    //
    //            self.hideActivityIndicator()
    //
    //            self.networkListObj = response.result.value
    //            if response.response?.statusCode == 200 {
    //
    //                if self.networkListObj?.responsecode == 2 || self.networkListObj?.responsecode == 1 {
    //
    //                    self.arrNetworkList = self.networkListObj?.stringNetworks
    //                    self.methodDropDownMobileNetworks(Telcos: self.arrNetworkList!)
    //                }
    //                else{
    //                    if let message = self.networkListObj?.messages{
    //                        self.showDefaultAlert(title: "", message: message)
    //                    }
    //                }
    //            }
    //            else {
    //                if let message = self.networkListObj?.messages{
    //                    self.showDefaultAlert(title: "", message: message)
    //                }
    //                print(response.result.value)
    //                print(response.response?.statusCode)
    //            }
    //        }
    //    }
    
    
    //    if DataManager.instance.forgotPassword == true {
    //    let params =
    //    var params:[String:Any]?
    //    }
    
    private func createWalletRegForButtonPressed() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        if (mobileNumberTextField.text?.isEmpty)!{
            mobileNumberTextField.text = ""
        }
        if (cnicTextField.text?.isEmpty)!{
            cnicTextField.text = ""
        }
        
        var otpType : String?
        
        let compelteUrl = GlobalConstants.BASE_URL + "regNewDevice"
        
        if DataManager.instance.forgotPassword == true {
            otpType = "F"
        }
        if DataManager.instance.registerNewDevice == true{
            otpType = "R"
        }
//        orginal
//        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":self.cnicTextField.text!,"mobile":self.mobileNumberTextField.text!,"otptype":otpType!,"imei":DataManager.instance.imei!]
        
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":self.cnicTextField.text!,"mobile":self.mobileNumberTextField.text!,"otptype":otpType!,"imei":DataManager.instance.imei!,"appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel] as [String : Any]
//        
        
        print(parameters)
       
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
                
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        print(params)
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            
            self.genericResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                    let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                    NotificationCenter.default.post(name: Notification.Name("batteryLevelChanged"), object: nil)
                    UserDefaults.standard.setValue(nil, forKey: "proImage")
                    DataManager.instance.mobile_number = self.mobileNumberTextField.text
                    self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
                }
                else {
                    if let message = self.genericResponseObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    
                    // Html Parse
                    
                    if let title = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue){
                        if title.contains("Request Rejected") {
                            self.showDefaultAlert(title: "", message: "Network Connection Error. Contact 0800 42563")
                        }
                    }
                }
            }
            else {
                if let message = self.genericResponseObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    private func  createWalletButtonPressed() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        
        if (mobileNumberTextField.text?.isEmpty)!{
            mobileNumberTextField.text = ""
        }
        if (cnicTextField.text?.isEmpty)!{
            cnicTextField.text = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "mobileVerification"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel,"mobileNo":self.mobileNumberTextField.text!,"imeiNo":"\(DataManager.instance.imei!)","ipAddressA":"\(DataManager.instance.ipAddress!)","ipAddressP":"\(DataManager.instance.ipAddress!)","cnic":self.cnicTextField.text!,"lkpChannel": ["channelId":"\(DataManager.instance.channelID)","channelCode":"IOS","channelDescr":"Apple IOS"],"lkpNetwork": ["networkId":"1","networkCode":"JAZZ","networkDescr":"JAZZ"]] as [String : Any]
        
      
        
        
        
            let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(parameters)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
    
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
  
            self.hideActivityIndicator()
            
            self.genericResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                    let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                    DataManager.instance.mobile_number = self.mobileNumberTextField.text
                    if let accessToken = self.genericResponseObj?.token{
                        DataManager.instance.accessToken = accessToken
                    }
                    self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
                }
                else {
                    if let message = self.genericResponseObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    
                    // Html Parse
                    
                    if let title = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue){
                        if title.contains("Request Rejected") {
                            self.showDefaultAlert(title: "", message: "Network Connection Error. Contact 0800 42563")
                        }
                    }
                }
            }
            else {
                if let message = self.genericResponseObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                else {
                    self.showDefaultAlert(title: "", message: "\(response.response?.statusCode ?? 500)")
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
}

