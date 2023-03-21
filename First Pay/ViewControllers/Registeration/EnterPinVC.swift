////
////  EnterPinVC.swift
////  First Wallet
////
////  Created by Syed Uzair Ahmed on 14/11/2018.
////  Copyright © 2018 FMFB Pakistan. All rights reserved.
////
//



//
//  EnterPinVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 14/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import PasswordTextField
import RNCryptor
class EnterPinVC: BaseClassVC , UITextFieldDelegate {
    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
    var customerID : Int?
    @IBOutlet weak var enterPinTextField: UITextField!
    @IBOutlet weak var enterConfirmPinTextField: UITextField!
    
    var genericResponseObj : GenericResponse?
    
    @IBOutlet var btn_6characters: UIButton!
    @IBOutlet var btn_4digits: UIButton!
    @IBOutlet var btn_atLeast2Letters: UIButton!
    @IBOutlet var btn_Register: UIButton!
    var mainTitle: String?
    @IBOutlet weak var lblMainTitle: UILabel!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var okaction: UIButton!
    
    @IBOutlet weak var lblPasswordshouldbe: UILabel!
    var callSubmit:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
//        ConvertLanguage(str:  UserDefaults.standard.string(forKey: "language-Code"))
        enterPinTextField.delegate = self
        enterConfirmPinTextField.delegate = self
        enterPinTextField.isUserInteractionEnabled = true
        enterConfirmPinTextField.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
//        self.btn_Register.isEnabled = false
        self.lblMainTitle.text = "Set Password"
    }
    func ConvertLanguage()
    {
    
        lblMainTitle.text = "Set Password".addLocalizableString(languageCode: languageCode)
        enterPinTextField.placeholder = "Enter New Passord".addLocalizableString(languageCode: languageCode)
        enterConfirmPinTextField.placeholder = "Confirm password".addLocalizableString(languageCode: languageCode)
        btn_Register.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        lblPasswordshouldbe.text = "Password Should be 6 characters(alpha numeric)".addLocalizableString(languageCode: languageCode)
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.enterPinTextField {
            if range.length + range.location > (textField.text?.count)! {
                return false
        
                            
            }
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberRegEx  = ".*[0-9]+.*"
            let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            let numberresult = texttest1.evaluate(with: newString)
            print("\(numberresult)")
            
//            let rangeCharacterRegEx  = "^.{6,}$"
//            let texttest3 = NSPredicate(format:"SELF MATCHES %@", rangeCharacterRegEx)
//            let rangeResult = texttest3.evaluate(with: newString)
//            if rangeResult == true{
            if isValidPassword() == true{
                
                self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
            }
          
            else{
                lbl1.textColor = UIColor.red
                lbl2.textColor = UIColor.red
                lbl3.textColor = UIColor.red
                self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
                
                
            }
           
            if  numberresult == true /*&& newString.count == 6*/{
                callSubmit = true
               
//                btn_Register.isEnabled = true
            }
            else {
                callSubmit = false
//                btn_Register.isEnabled = false
            }
            
        }
        
        let newLength:Int = (textField.text?.count)! + string.count - range.length
        
        if textField == enterPinTextField{
            return newLength <= 6
        }
        if textField == enterConfirmPinTextField{
            return newLength <= 6
        }
        return newLength <= 6
        lbl1.textColor = UIColor.green
        
    }
  
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == enterPinTextField {
            enterConfirmPinTextField .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
        } else if textField == enterConfirmPinTextField {
            textField.resignFirstResponder()
            if isValidPassword() == true{
          
                lbl1.textColor = UIColor.green
                lbl2.textColor = UIColor.green
                lbl3.textColor = UIColor.green
                lbl4.textColor = UIColor.green
                self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
                
            }
        }
    }
  
    func isValidPassword() -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 6 characters total
        let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: enterPinTextField.text!)
    }
       // MARK: - Action Methods
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        if enterPinTextField.text?.count == 0 {
            UtilManager.showAlertMessage(message: "password should be Alpha Numeric", viewController: self)
        }
        
        if enterConfirmPinTextField.text?.count == 0{
            UtilManager.showAlertMessage(message: "password should be Alpha Numeric", viewController: self)
        }
        if enterPinTextField.text != enterConfirmPinTextField.text! {
            lbl4.textColor = UIColor.red
            UtilManager.showAlertMessage(message:"Password and Confirm Password not match" , viewController: self)
            return
        }
        
        if isValidPassword() == true
        {
        self.enterPin()
        }
    }
    
    // MARK: - API CALL
    
    private func enterPin() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        var userCnic : String?
        
        showActivityIndicator()
        
        if (enterPinTextField.text?.isEmpty)! {
            enterPinTextField.text = ""
        }
        if (enterConfirmPinTextField.text?.isEmpty)! {
            enterConfirmPinTextField.text = ""
        }
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "setLoginPin"
        
        let parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","loginpin":enterPinTextField.text!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
    
//            Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
        
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.genericResponseObj = response.result.value
                if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                    if let message = self.genericResponseObj?.messages{
                        let removePessi : Bool = KeychainWrapper.standard.removeObject(forKey: "userKey")
                        print("Remover \(removePessi)")
                        
                        self.showAlert(title: "", message: "Password Set Successfully!", completion: {
            
                                    var userCnic : String?
                                    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
                                        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
                                        self.login()
                                    }
                                    else{
                                        userCnic = ""
                                    }
                            
//                            callhome
                            self.login()
//                            let loginPinVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginPinVC") as! LoginPinVC
//                            self.navigationController!.pushViewController(loginPinVC, animated: true)
                            
                        })
                    }
                }
                else {
                    if let message = self.genericResponseObj?.messages{
                        self.showAlert(title: "", message: message, completion:nil)
                    }
                }
            }
            else {
                if let message = self.genericResponseObj?.messages{
                    self.showAlert(title: "", message: message, completion:nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    var viaBio : Bool = false
    var loginObj : LoginActionModel?
    
    
    func login()
    {
    self.showActivityIndicator()
    if !NetworkConnectivity.isConnectedToInternet(){
        self.showToast(title: "No Internet Available")
        return
    }
        
    
    
    var pessi : String?
    var userCnic : String?
    
//        let compelteUrl = GlobalConstants.BASE_URL + "login"
    let compelteUrl = GlobalConstants.BASE_URL + "v2/login"
    
            
    if KeychainWrapper.standard.hasValue(forKey: "userKey") && viaBio == true {
        pessi = KeychainWrapper.standard.string(forKey: "userKey")
    }
    else if let password = self.enterPinTextField.text{
        pessi = password
    }
    else{
        self.showDefaultAlert(title: "", message: "Please Use Password for first time Login after Registration")
        self.hideActivityIndicator()
        return
    }
    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
    }
    else{
        userCnic = ""
    }

    let parameters = ["cnic":userCnic!,"loginPin":pessi!,"imeiNo":DataManager.instance.imei!,"ipAddress":DataManager.instance.ipAddress!,"channelId":"\(DataManager.instance.channelID)","longitude":"\(DataManager.instance.Longitude!)","latitude":"\(DataManager.instance.Latitude!)","uuid":"\(DataManager.instance.userUUID ?? "")"]
   
    print(parameters)
    
    let result = splitString(stringToSplit: base64EncodedString(params: parameters))

    let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
       let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
    
    
    print(params)
    print(compelteUrl)
    NetworkManager.sharedInstance.enableCertificatePinning()
    
    NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LoginActionModel>) in
//            Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LoginActionModel>) in
           
        self.loginObj = response.result.value

        if response.response?.statusCode == 200 {
            self.hideActivityIndicator()
            self.loginObj = response.result.value
            if self.loginObj?.responsecode == 2 || self.loginObj?.responsecode == 1 {
                if self.loginObj?.userData?.customerHomeScreens?[0].riskProfile == "Y"{
                   let createWalletVC = self.storyboard!.instantiateViewController(withIdentifier: "RiskProfileVC") as! RiskProfileVC
                    
                     if let accessToken = self.loginObj?.userData?.token{
                        DataManager.instance.accessToken = accessToken
                        DataManager.instance.accountType = self.loginObj?.userData?.customerHomeScreens?[0].accountType
                        DataManager.instance.customerId = self.loginObj?.userData?.customerHomeScreens?[0].customerId
                        print("\(accessToken)")
                     }
                    self.navigationController!.pushViewController(createWalletVC, animated: true)
                }

//
            else{
                
             
                
                 if let accessToken = self.loginObj?.userData?.token{
                    DataManager.instance.accessToken = accessToken
                    DataManager.instance.accountType = self.loginObj?.userData?.customerHomeScreens?[0].accountType
                    DataManager.instance.customerId = self.loginObj?.userData?.customerHomeScreens?[0].customerId
                    print("\(accessToken)")
                     if let passKey = self.enterPinTextField.text{
                        let saveSuccessful : Bool = KeychainWrapper.standard.set(passKey, forKey: "userKey")
                        print("SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
                    }
                    self.saveInDataManager()
                }
                    else {
             
                if let message = self.loginObj?.messages{
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
    }
        else {
        
                self.showAlert(title: "", message: "Something Went Wrong", completion:nil)
//                print(response.result.value)
//                print(response.response?.statusCode)
        }
  
}
}
}
    func AccessTokenEncrypt(plaintext : String , password : String) -> String
       {
           let data: Data = plaintext.data(using: .utf8)!
           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
           let encryptedstring : String = encryptedData.base64EncodedString()
           print("encryptedstring",encryptedstring)
        DataManager.AccessToken = encryptedstring
           print(DataManager.AccessToken)
           return encryptedstring
        
       }

    //    ---------------------end--------------
        private func saveInDataManager(){
          
                   
                   
                    AccessTokenEncrypt(plaintext: (self.loginObj?.userData?.token)!, password: encryptionkey)
                    print(self.loginObj?.userData?.token)
            
            
            
            
            if let url = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async { /// execute on main thread

                    }
                }
                task.resume()
            }
            var accountName : String?
            if KeychainWrapper.standard.hasValue(forKey: "accountTitle") {
                accountName = KeychainWrapper.standard.string(forKey: "accountTitle")
                DataManager.instance.accountTitle = accountName
            }
            DataManager.instance.nanoloan = self.loginObj?.userData?.customerHomeScreens?[0].nanoloan! ?? ""
            print("nanoloan is :" , self.loginObj?.userData?.customerHomeScreens?[0].nanoloan)
            DataManager.instance.riskprofile = self.loginObj?.userData?.customerHomeScreens?[0].riskProfile ?? ""
            self.navigateToHome()
            
        }
    private func navigateToHome(){
        let HomeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        print("success auto login")
       self.navigationController!.pushViewController(HomeVC, animated: true)
        
    }
    
    
       
}




























//end
//import UIKit
//import Alamofire
//import AlamofireObjectMapper
//import SwiftKeychainWrapper
//import PasswordTextField
//import RNCryptor
//class EnterPinVC: BaseClassVC , UITextFieldDelegate {
//    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
//    var customerID : Int?
//    @IBOutlet weak var enterPinTextField: UITextField!
//    @IBOutlet weak var enterConfirmPinTextField: UITextField!
//
//    var genericResponseObj : GenericResponse?
//
//    @IBOutlet var btn_6characters: UIButton!
//    @IBOutlet var btn_4digits: UIButton!
//    @IBOutlet var btn_atLeast2Letters: UIButton!
//    @IBOutlet var btn_Register: UIButton!
//    var mainTitle: String?
//    @IBOutlet weak var lblMainTitle: UILabel!
//
//    @IBOutlet weak var lbl1: UILabel!
//    @IBOutlet weak var lbl3: UILabel!
//    @IBOutlet weak var lbl2: UILabel!
//    @IBOutlet weak var lbl4: UILabel!
//    @IBOutlet weak var okaction: UIButton!
//
//    @IBOutlet weak var lblPasswordshouldbe: UILabel!
//    var callSubmit:Bool = false
//    override func viewDidLoad() {
//        super.viewDidLoad()
//       ConvertLanguage()
//        enterPinTextField.delegate = self
//        enterConfirmPinTextField.delegate = self
//        enterPinTextField.isUserInteractionEnabled = true
//        enterConfirmPinTextField.isUserInteractionEnabled = true
//        // Do any additional setup after loading the view.
////        self.btn_Register.isEnabled = false
//        self.lblMainTitle.text = "Set Password".addLocalizableString(languageCode: languageCode)
//    }
//    func ConvertLanguage()
//    {
//
//        lblMainTitle.text = "Set Password".addLocalizableString(languageCode: languageCode)
//        enterPinTextField.placeholder = "Enter New password".addLocalizableString(languageCode: languageCode)
//        enterConfirmPinTextField.placeholder = "Confirm password".addLocalizableString(languageCode: languageCode)
//        btn_Register.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
//        lblPasswordshouldbe.text = "Password Should be 6 characters(alpha numeric)".addLocalizableString(languageCode: languageCode)
//
//
//
//
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField == self.enterPinTextField {
//            if range.length + range.location > (textField.text?.count)! {
//                return false
//
//
//            }
//        }
////            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
////            let numberRegEx  = ".*[0-9]+.*"
////            let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
////            let numberresult = texttest1.evaluate(with: newString)
////            print("\(numberresult)")
////
////            if isValidPassword() == true{
////
////                self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
////            }
////
////            else{
////                lbl1.textColor = UIColor.red
////                lbl2.textColor = UIColor.red
////                lbl3.textColor = UIColor.red
////                self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
////
////
////            }
////
////            if  numberresult == true /*&& newString.count == 6*/{
////                callSubmit = true
////
//////                btn_Register.isEnabled = true
////            }
////            else {
////                callSubmit = false
//////                btn_Register.isEnabled = false
////            }
////
////        }
////
////        let newLength:Int = (textField.text?.count)! + string.count - range.length
////
////        if textField == enterPinTextField{
////            return newLength <= 6
////        }
////        if textField == enterConfirmPinTextField{
////            return newLength <= 6
////        }
////        return newLength <= 6
////        lbl1.textColor = UIColor.green
////
////           updated
//            if (isValidPassword(textfield: enterPinTextField, lastString: "") && isValidPassword(textfield: enterConfirmPinTextField, lastString: "")) == true  {
//               callSubmit = true
//
//               btn_6characters.setImage(UIImage(named: "checkbox_state2"), for: .normal)
//            }
//                else{
//                    self.callSubmit = false
//
//                    self.btn_6characters.setImage(UIImage(named: "checkbox_state1"), for: .normal)
//                    self.lbl1.textColor = UIColor.red
//                    self.lbl2.textColor = UIColor.red
//                    self.lbl3.textColor = UIColor.red
//                    self.lbl4.textColor = UIColor.red
//
//                    self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
//                }
//
//                let newLength:Int = (textField.text?.count)! + string.count - range.length
//
//                if textField == enterPinTextField{
//                    return newLength <= 6
//                }
//                if textField == enterConfirmPinTextField{
//                    return newLength <= 6
//                }
//                return newLength <= 6
//
//    }
//
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        if textField == enterPinTextField {
//            enterConfirmPinTextField .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
//        } else if textField == enterConfirmPinTextField {
//            textField.resignFirstResponder()
//            if (isValidPassword(textfield: enterPinTextField, lastString: "") && isValidPassword(textfield: enterConfirmPinTextField, lastString: "")) == true{
//                callSubmit = true
//                lbl1.textColor = UIColor.green
//                lbl2.textColor = UIColor.green
//                lbl3.textColor = UIColor.green
//                lbl4.textColor = UIColor.green
//                self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
//
////            if isValidPassword() == true{
////
////                lbl1.textColor = UIColor.green
////                lbl2.textColor = UIColor.green
////                lbl3.textColor = UIColor.green
////                lbl4.textColor = UIColor.green
////                self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
//
//            }
//        }
//    }
//
////    func isValidPassword() -> Bool {
////        // least one uppercase,
////        // least one digit
////        // least one lowercase
////        // least one symbol
////        //  min 6 characters total
////        let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
////        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
////        return passwordCheck.evaluate(with: enterPinTextField.text!)
////    }
//
//
//    func isValidPassword(textfield: UITextField, lastString: String) -> Bool {
//
//        let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
//        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
//        return passwordCheck.evaluate(with: textfield.text!+lastString)
//    }
//       // MARK: - Action Methods
//
//    @IBAction func registerButtonPressed(_ sender: Any) {
//
//        if enterPinTextField.text?.count == 0 {
//            UtilManager.showAlertMessage(message: "password should be Alpha Numeric", viewController: self)
//        }
//
//        if enterConfirmPinTextField.text?.count == 0{
//            UtilManager.showAlertMessage(message: "password should be Alpha Numeric", viewController: self)
//        }
//        if enterPinTextField.text != enterConfirmPinTextField.text! {
////            lbl4.textColor = UIColor.red
//            UtilManager.showAlertMessage(message:"Password and Confirm Password not match" , viewController: self)
//
//        }
//
//        if isValidPassword(textfield: enterPinTextField, lastString: "") && isValidPassword(textfield: enterConfirmPinTextField, lastString: "") == true && ((enterPinTextField.text) == (enterConfirmPinTextField.text))
//        {
//
//            lbl1.textColor = UIColor.green
//            lbl2.textColor = UIColor.green
//            lbl3.textColor = UIColor.green
//            lbl4.textColor = UIColor.green
//            self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
//
//            self.enterPin()
//        }
//
//        else{
//            UtilManager.showAlertMessage(message: "Password should be Alpha Numeric", viewController: self)
//        }
//
////        if isValidPassword() == true
////        {
////        self.enterPin()
////        }
//    }
//
//    // MARK: - API CALL
//
//    private func enterPin() {
//
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//        var userCnic : String?
//
//        showActivityIndicator()
//
//        if (enterPinTextField.text?.isEmpty)! {
//            enterPinTextField.text = ""
//        }
//        if (enterConfirmPinTextField.text?.isEmpty)! {
//            enterConfirmPinTextField.text = ""
//        }
//        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//        }
//        else{
//            userCnic = ""
//        }
//
//        let compelteUrl = GlobalConstants.BASE_URL + "setLoginPin"
//
//        let parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","loginpin":enterPinTextField.text!]
//
//        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
//
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
//
//        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//
//        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//
//
//        print(params)
//        print(compelteUrl)
//        print(header)
//
//        NetworkManager.sharedInstance.enableCertificatePinning()
//
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
//
////            Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
//
//
//            self.hideActivityIndicator()
//
//            if response.response?.statusCode == 200 {
//
//                self.genericResponseObj = response.result.value
//                if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
//                    if let message = self.genericResponseObj?.messages{
//                        let removePessi : Bool = KeychainWrapper.standard.removeObject(forKey: "userKey")
//                        print("Remover \(removePessi)")
//
//                        self.showAlert(title: "", message: "Password Updated  Successfully!", completion: {
//
//                                    var userCnic : String?
//                                    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//                                        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//                                        self.login()
//                                    }
//                                    else{
//                                        userCnic = ""
//                                    }
//
////                            callhome
////                            self.login()
////                            let loginPinVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginPinVC") as! LoginPinVC
////                            self.navigationController!.pushViewController(loginPinVC, animated: true)
//
//                        })
//                    }
//                }
//                else {
//                    if let message = self.genericResponseObj?.messages{
//                        self.showAlert(title: "", message: message, completion:nil)
//                    }
//                }
//            }
//            else {
//                if let message = self.genericResponseObj?.messages{
//                    self.showAlert(title: "", message: message, completion:nil)
//                }
////                print(response.result.value)
////                print(response.response?.statusCode)
//            }
//        }
//    }
//    var viaBio : Bool = false
//    var loginObj : LoginActionModel?
//
//
//    func login()
//    {
//    self.showActivityIndicator()
//    if !NetworkConnectivity.isConnectedToInternet(){
//        self.showToast(title: "No Internet Available")
//        return
//    }
//
//
//
//    var pessi : String?
//    var userCnic : String?
//
////        let compelteUrl = GlobalConstants.BASE_URL + "login"
//    let compelteUrl = GlobalConstants.BASE_URL + "v2/login"
//
//
//    if KeychainWrapper.standard.hasValue(forKey: "userKey") && viaBio == true {
//        pessi = KeychainWrapper.standard.string(forKey: "userKey")
//    }
//    else if let password = self.enterPinTextField.text{
//        pessi = password
//    }
//    else{
//        self.showDefaultAlert(title: "", message: "Please Use Password for first time Login after Registration")
//        self.hideActivityIndicator()
//        return
//    }
//    if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//        userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//    }
//    else{
//        userCnic = ""
//    }
//
//    let parameters = ["cnic":userCnic!,"loginPin":pessi!,"imeiNo":DataManager.instance.imei!,"ipAddress":DataManager.instance.ipAddress!,"channelId":"\(DataManager.instance.channelID)","longitude":"\(DataManager.instance.Longitude!)","latitude":"\(DataManager.instance.Latitude!)","uuid":"\(DataManager.instance.userUUID ?? "")"]
//
//    print(parameters)
//
//    let result = splitString(stringToSplit: base64EncodedString(params: parameters))
//
//    let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//       let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
//
//
//    print(params)
//    print(compelteUrl)
//    NetworkManager.sharedInstance.enableCertificatePinning()
//
//    NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LoginActionModel>) in
////            Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LoginActionModel>) in
//
//        self.loginObj = response.result.value
//
//        if response.response?.statusCode == 200 {
//            self.hideActivityIndicator()
//            self.loginObj = response.result.value
//            if self.loginObj?.responsecode == 2 || self.loginObj?.responsecode == 1 {
//                if self.loginObj?.userData?.customerHomeScreens?[0].riskProfile == "Y"{
//                   let createWalletVC = self.storyboard!.instantiateViewController(withIdentifier: "RiskProfileVC") as! RiskProfileVC
//
//                     if let accessToken = self.loginObj?.userData?.token{
//                        DataManager.instance.accessToken = accessToken
//                        DataManager.instance.accountType = self.loginObj?.userData?.customerHomeScreens?[0].accountType
//                        DataManager.instance.customerId = self.loginObj?.userData?.customerHomeScreens?[0].customerId
//                        print("\(accessToken)")
//                     }
//                    self.navigationController!.pushViewController(createWalletVC, animated: true)
//                }
//
////                    DataManager.instance
//            else{
//
//
//
//                 if let accessToken = self.loginObj?.userData?.token{
//                    DataManager.instance.accessToken = accessToken
//                    DataManager.instance.accountType = self.loginObj?.userData?.customerHomeScreens?[0].accountType
//                    DataManager.instance.customerId = self.loginObj?.userData?.customerHomeScreens?[0].customerId
//                    print("\(accessToken)")
//                     if let passKey = self.enterPinTextField.text{
//                        let saveSuccessful : Bool = KeychainWrapper.standard.set(passKey, forKey: "userKey")
//                        print("SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
//                    }
//                    self.saveInDataManager()
//                }
//                    else {
//
//                if let message = self.loginObj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//                }
//                // Html Parse
//
//                if let title = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue){
//                    if title.contains("Request Rejected") {
//                        self.showDefaultAlert(title: "", message: "Network Connection Error. Contact 0800 34778")
//                    }
//                }
//            }
//
//        }
//    }
//        else {
//
//                self.showAlert(title: "", message: "Something Went Wrong", completion:nil)
////                print(response.result.value)
////                print(response.response?.statusCode)
//        }
//
//}
//}
//}
//    func AccessTokenEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.AccessToken = encryptedstring
//           print(DataManager.AccessToken)
//           return encryptedstring
//
//       }
//
//    //    ---------------------end--------------
//        private func saveInDataManager(){
//
//
//
//                    AccessTokenEncrypt(plaintext: (self.loginObj?.userData?.token)!, password: encryptionkey)
//                    print(self.loginObj?.userData?.token)
//
//
//
//
//            if let url = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
//                let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                    guard let data = data, error == nil else { return }
//
//                    DispatchQueue.main.async { /// execute on main thread
//
//                    }
//                }
//                task.resume()
//            }
//            var accountName : String?
//            if KeychainWrapper.standard.hasValue(forKey: "accountTitle") {
//                accountName = KeychainWrapper.standard.string(forKey: "accountTitle")
//                DataManager.instance.accountTitle = accountName
//            }
//            DataManager.instance.nanoloan = self.loginObj?.userData?.customerHomeScreens?[0].nanoloan! ?? ""
//            print("nanoloan is :" , self.loginObj?.userData?.customerHomeScreens?[0].nanoloan)
//            DataManager.instance.riskprofile = self.loginObj?.userData?.customerHomeScreens?[0].riskProfile ?? ""
//            self.navigateToHome()
//
//        }
//    private func navigateToHome(){
//        let HomeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//        print("success auto login")
//       self.navigationController!.pushViewController(HomeVC, animated: true)
//
//    }
//
//}
//
