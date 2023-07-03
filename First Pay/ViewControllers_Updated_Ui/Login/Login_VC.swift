//
//  Login_VC.swift
//  First Pay
//
//  Created by Irum Butt on 11/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//
import UIKit
import KYDrawerController
import Alamofire
import AlamofireObjectMapper
import MapKit
import PinCodeTextField
import SwiftKeychainWrapper
import LocalAuthentication
import SafariServices
import Foundation
import CryptoSwift
import RNCryptor
import PasswordTextField
import CoreLocation
import OneSignal


class Login_VC: BaseClassVC, UITextFieldDelegate  {
    var homeObj : HomeModel?
    var concateString = ""
    var ecn = ""
    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
    var viaBio : Bool = false
    var loginObj : login?
    var flag :Bool = false
    var moveToSignUp: (() -> ())!
    
////<<<<<<< HEAD
////
////=======
////<<<<<<< HEAD
////
////=======
////>>>>>>> a408e5e (pod update)
//>>>>>>> 9c3ef07 (add cash ui fix)
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    @IBOutlet weak var labelFive: UILabel!
    @IBOutlet weak var labelSix: UILabel!

    @IBOutlet weak var viewCircleOne: UIView!
    @IBOutlet weak var viewCircleTwo: UIView!
    @IBOutlet weak var viewCircleThree: UIView!
    @IBOutlet weak var viewCircleFour: UIView!
    @IBOutlet weak var viewCircleFive: UIView!
    @IBOutlet weak var viewCircleSix: UIView!
    
    @IBOutlet weak var viewLineOne: UIView!
    @IBOutlet weak var viewLineTwo: UIView!
    @IBOutlet weak var viewLineThree: UIView!
    @IBOutlet weak var viewLineFour: UIView!
    @IBOutlet weak var viewLineFive: UIView!
    @IBOutlet weak var viewLineSix: UIView!

    
    override func viewDidDisappear(_ animated: Bool) {
        UITextField.appearance().tintColor = .systemBlue
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//<<<<<<< HEAD
//
//#if targetEnvironment(simulator)
//#else
//#endif
//
//=======
//<<<<<<< HEAD
//=======
//
//#if targetEnvironment(simulator)
//#else
//#endif
//
//>>>>>>> a408e5e (pod update)
>>>>>>> 9c3ef07 (add cash ui fix)

        labelOne.text = ""
        labelTwo.text = ""
        labelThree.text = ""
        labelFour.text = ""
        labelFive.text = ""
        labelSix.text = ""
        
        passwordShow(isShow: false)
        UITextField.appearance().tintColor = .clear
        textFieldSetting()
//        self.showAlertCustomPopup(title: "", message: "",buttonName: ["OK","CANCEL"],viewController: self)
        lbl_InvalidPassword.isHidden = true
        pinTextField.delegate = self
        show_text.setTitle("", for: .normal)
        //        pinTextField.resignFirstResponder()
        pinTextField.keyboardType = .namePhonePad
        self.hideKeyboardWhenTappedAround()
        pinTextField.isSecureTextEntry = true
        getIMEI()
        getIPAddressmac()
        
        self.pinTextField.addDoneButtonOnKeyboardWithAction { [self] in
            self.pinTextField.resignFirstResponder()
            
            if self.pinTextField.text?.count == 6 {
            UserDefaults.standard.set(self.pinTextField.text, forKey: "userKey")
           
                self.pinTextField.resignFirstResponder()
                self.loginAction()
            }
        }
        self.pinTextField.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
      
        
        // Do any additional setup after loading the view.
        
        
    }
    
    func fingerPrintConfigurationSetup() {
//        let fingerprintConfig = FingerprintConfig(
//                                mode: .EXPORT_WSQ,
//                                hand: .BOTH_HANDS,
//                                fingers: .EIGHT_FINGERS,
//                                liveness: true,
//                                isPackPng: false)
    }
    
    @objc func changeTextInTextField() {
        checkFields(filedNo: self.pinTextField.text?.count ?? 0)
        
        if self.pinTextField.text?.count == 6 {
            UserDefaults.standard.set(self.pinTextField.text, forKey: "userKey")
//             let removePessi : Bool =  KeychainWrapper.standard.removeObject(forKey: "userKey")
//             print("Remover \(removePessi)")
            
            self.pinTextField.resignFirstResponder()
            self.loginAction()
        }
        print(self.pinTextField.text)
    }
    
    func textFieldSetting() {
        lbl_InvalidPassword.isHidden = true
        viewCircleOne.circle()
        viewCircleTwo.circle()
        viewCircleThree.circle()
        viewCircleFour.circle()
        viewCircleFive.circle()
        viewCircleSix.circle()
        
        viewLineOne.circle()
        viewLineTwo.circle()
        viewLineThree.circle()
        viewLineFour.circle()
        viewLineFive.circle()
        viewLineSix.circle()
        
        viewCircleOne.backgroundColor = .clear
        viewCircleTwo.backgroundColor = .clear
        viewCircleThree.backgroundColor = .clear
        viewCircleFour.backgroundColor = .clear
        viewCircleFive.backgroundColor = .clear
        viewCircleSix.backgroundColor = .clear
        
        viewLineOne.backgroundColor = .clrLightGrayCalendar
        viewLineTwo.backgroundColor = .clrLightGrayCalendar
        viewLineThree.backgroundColor = .clrLightGrayCalendar
        viewLineFour.backgroundColor = .clrLightGrayCalendar
        viewLineFive.backgroundColor = .clrLightGrayCalendar
        viewLineSix.backgroundColor = .clrLightGrayCalendar
    }
    func checkFields(filedNo: Int) {
        viewCircleOne.backgroundColor = .clear
        viewCircleTwo.backgroundColor = .clear
        viewCircleThree.backgroundColor = .clear
        viewCircleFour.backgroundColor = .clear
        viewCircleFive.backgroundColor = .clear
        viewCircleSix.backgroundColor = .clear
        
        viewLineOne.backgroundColor = .clrLightGrayCalendar
        viewLineTwo.backgroundColor = .clrLightGrayCalendar
        viewLineThree.backgroundColor = .clrLightGrayCalendar
        viewLineFour.backgroundColor = .clrLightGrayCalendar
        viewLineFive.backgroundColor = .clrLightGrayCalendar
        viewLineSix.backgroundColor = .clrLightGrayCalendar
        
        labelOne.text = ""
        labelTwo.text = ""
        labelThree.text = ""
        labelFour.text = ""
        labelFive.text = ""
        labelSix.text = ""
        
        if filedNo == 0 {
            return
        }
        
        let array = pinTextField.text!.reduce(into: [Character]()) { result, letter in
            result.append(letter)
        }
        print(array[0] )

//        labelThree.text = array[0]
//        labelFour.text = array[0]
//        labelFive.text = array[0]
//        labelSix.text = array[0]
        
        for i in 1...filedNo {
            print(i)
            if i == 1 {
                labelOne.text = "\(array[0])"
                viewLineOne.backgroundColor = .white
                viewCircleOne.backgroundColor = .white
            }
            if i == 2 {
                labelTwo.text = "\(array[1])"
                viewLineOne.backgroundColor = .white
                viewCircleOne.backgroundColor = .white
                viewLineTwo.backgroundColor = .white
                viewCircleTwo.backgroundColor = .white
            }
            else if i == 3 {
                labelThree.text = "\(array[2])"
                viewLineOne.backgroundColor = .white
                viewCircleOne.backgroundColor = .white
                viewLineTwo.backgroundColor = .white
                viewCircleTwo.backgroundColor = .white
                viewLineThree.backgroundColor = .white
                viewCircleThree.backgroundColor = .white
            }
            else if i == 4 {
                labelFour.text = "\(array[3])"
                viewLineOne.backgroundColor = .white
                viewCircleOne.backgroundColor = .white
                viewLineTwo.backgroundColor = .white
                viewCircleTwo.backgroundColor = .white
                viewLineThree.backgroundColor = .white
                viewCircleThree.backgroundColor = .white
                viewLineFour.backgroundColor = .white
                viewCircleFour.backgroundColor = .white
            }
            else if i == 5 {
                labelFive.text = "\(array[4])"
                viewLineOne.backgroundColor = .white
                viewCircleOne.backgroundColor = .white
                viewLineTwo.backgroundColor = .white
                viewCircleTwo.backgroundColor = .white
                viewLineThree.backgroundColor = .white
                viewCircleThree.backgroundColor = .white
                viewLineFour.backgroundColor = .white
                viewCircleFour.backgroundColor = .white
                viewLineFive.backgroundColor = .white
                viewCircleFive.backgroundColor = .white
            }
            else if i == 6 {
                labelSix.text = "\(array[5])"
                viewLineOne.backgroundColor = .white
                viewCircleOne.backgroundColor = .white
                viewLineTwo.backgroundColor = .white
                viewCircleTwo.backgroundColor = .white
                viewLineThree.backgroundColor = .white
                viewCircleThree.backgroundColor = .white
                viewLineFour.backgroundColor = .white
                viewCircleFour.backgroundColor = .white
                viewLineFive.backgroundColor = .white
                viewCircleFive.backgroundColor = .white
                viewLineSix.backgroundColor = .white
                viewCircleSix.backgroundColor = .white
            }
        }
    }
    
    
    //    --------------------
    //    outlets
    //    --------------------
    @IBOutlet weak var btnTouchId: UIButton!
    @IBOutlet weak var btnFaceiD: UIButton!
    @IBOutlet weak var lbl_InvalidPassword: UILabel!
    @IBOutlet weak var pinTextField: PasswordTextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    @IBOutlet weak var show_text: UIButton!
    
    @IBAction func Show_Passowrd(_ sender: UIButton) {
//        flag = true
//        if flag == false
//        {
//            pinTextField.isSecureTextEntry  = true
//        }
//        else
//        {
//            pinTextField.isSecureTextEntry  = false
//        }
        if show_text.tag == 0 {
            passwordShow(isShow: true)
        }
        else {
            passwordShow(isShow: false)
        }
    }
    
    func passwordShow(isShow: Bool) {
        if isShow {
            show_text.setImage(UIImage(named: "Change Password"), for: .normal)
            show_text.tag = 1
            labelOne.isHidden = false
            labelTwo.isHidden = false
            labelThree.isHidden = false
            labelFour.isHidden = false
            labelFive.isHidden = false
            labelSix.isHidden = false
            
            viewCircleOne.isHidden = true
            viewCircleTwo.isHidden = true
            viewCircleThree.isHidden = true
            viewCircleFour.isHidden = true
            viewCircleFive.isHidden = true
            viewCircleSix.isHidden = true
        }
        else {
            show_text.setImage(UIImage(named: "svgg"), for: .normal)
            show_text.tag = 0
            labelOne.isHidden = true
            labelTwo.isHidden = true
            labelThree.isHidden = true
            labelFour.isHidden = true
            labelFive.isHidden = true
            labelSix.isHidden = true
            
            viewCircleOne.isHidden = false
            viewCircleTwo.isHidden = false
            viewCircleThree.isHidden = false
            viewCircleFour.isHidden = false
            viewCircleFive.isHidden = false
            viewCircleSix.isHidden = false
        }
    }
    
    
    @IBAction func loginActionviaTouchID(_ sender: UIButton) {
        fingerPrintConfigurationSetup()
        return()
        if KeychainWrapper.standard.bool(forKey: "enableTouchID") == true  {
            self.authenticateUserViaTouchID()
            viaBio = true
            print("true")
            print("password",KeychainWrapper.standard.string(forKey: "userKey"))
        }
        else {
            self.showToast(title: "Please Enable TouchID/FaceID by logging in with your Password")
            print("false")
        }
    }
    
    //    func textFieldDidEndEditing(_ textField: PinCodeTextField) {
    //       navigateToHome()
    //    }
    
    @IBAction func forgotAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPassword_SetNewPassVC")
        DataManager.instance.forgotPassword == true
        //        self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getIPAddressmac(){
        
        let addr = getWiFiAddress()
        if !addr.isEmpty{
            DataManager.instance.ipAddress = addr[0]
            print(DataManager.instance.ipAddress!)
        }
        else{
            DataManager.instance.ipAddress = ""
            print("No Address")
        }
        getOneSignalUUIDD()
        
    }
    
    private func saveInDataManager(){
        //        AccessTokenEncrypt(plaintext: (self.loginObj?.userData?.token)!, password: encryptionkey)
        //        print(self.loginObj?.userData?.token)
        
        if let url = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    //                    let pngImage =  UIImage(data: data)
                    //                    UserDefaults.standard.set(pngImage, forKey: "proImage")
                }
            }
            task.resume()
        }
        //shakeel
        self.navigateToHome()
////<<<<<<< HEAD
//<<<<<<< HEAD
////
//////        return
////        if self.loginObj?.data?.customerHomeScreens?.first?.accountDiscrepant ?? "" == "N" {
////            let storyboard = UIStoryboard(name: "CNICVerification", bundle: nil)
////            let vc = storyboard.instantiateViewController(withIdentifier: "CNICVerification") as! CNICVerification
////            vc.modalPresentationStyle = .fullScreen
////            vc.successFullNICVerification = { success in
////                if success {
////                    self.navigateToHome()
////                }
////                else {
////                    print("Error Display Verification Failed")
////                    print("Error Display Verification Failed")
////                    self.pinTextField.text = nil
////                    self.textFieldSetting()
////                }
////            }
////            self.present(vc, animated: true)
////
////        }
////        else {
////            self.navigateToHome()
////        }
//=======
//
//        return
        if self.loginObj?.data?.customerHomeScreens?.first?.accountDiscrepant ?? "" == "N" {
            let storyboard = UIStoryboard(name: "CNICVerification", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CNICVerification") as! CNICVerification
            vc.modalPresentationStyle = .fullScreen
            vc.successFullNICVerification = { success in
                if success {
                    self.navigateToHome()
                }
                else {
                    print("Error Display Verification Failed")
                    print("Error Display Verification Failed")
                    self.pinTextField.text = nil
                    self.textFieldSetting()
                }
            }
            self.present(vc, animated: true)

        }
        else {
            self.navigateToHome()
        }
//>>>>>>> 9c3ef07 (add cash ui fix)
//=======

//        return
        if self.loginObj?.data?.customerHomeScreens?.first?.accountDiscrepant ?? "" == "N" {
            
            if self.loginObj?.data?.customerHomeScreens?.first?.accountDiscrepant ?? "" == "Y" {
                
                let storyboard = UIStoryboard(name: "CNICVerification", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CNICVerification") as! CNICVerification
                vc.modalPresentationStyle = .fullScreen
                vc.successFullNICVerification = { success in
                    if success {
                        self.navigateToHome()
                    }
                    else {
                        print("Error Display Verification Failed")
                        print("Error Display Verification Failed")
                        self.pinTextField.text = nil
                        self.textFieldSetting()
                    }
                }
                self.present(vc, animated: true)
                
            }
            else {
                self.navigateToHome()
            }
        }
//<<<<<<< HEAD
//=======
//>>>>>>> a408e5e (pod update)
//>>>>>>> 9c3ef07 (add cash ui fix)
    }
    //MARK: - TextField Delegates
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //
    //        if range.length + range.location > (textField.text?.count)!{
    //            return false
    //        }
    //        let newLength:Int = (textField.text?.count)! + string.count - range.length
    //        if pinTextField?.text?.count == 6 {
    //            print("done", pinTextField.text)
    //            print("pin count", pinTextField.text?.count)
    //            self.loginAction()
    ////            self.navigateToHome()
    //
    //        }
    //
    //       return true
    //    }
    ////
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == pinTextField){
            let characterCountLimit = 6
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            print("count",newLength)
            //                loginAction()
            //                if newLength == 6
            //                {
            //                    loginAction()
            //
            //                }
            return newLength <= characterCountLimit
            
            
            
            return true
        }
        return true
    }
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        if pinTextField?.text?.count == 6
    //        {
    ////              loginAction()
    ////            navigateToHome()
    //
    //        }
    //        else{
    //
    //        }
    ////            return true
    //    }
    
    func authenticateUserViaTouchID() {
        let touchIDManager = PITouchIDManager()
        touchIDManager.authenticateUser(success: { () -> () in
            OperationQueue.main.addOperation({ () -> Void in
                self.loginAction()
                //                self.navigateToHome()
                
            })
        }, failure: { (evaluationError: NSError) -> () in
            switch evaluationError.code {
            case LAError.Code.systemCancel.rawValue:
                print("Authentication cancelled by the system")
                self.showToast(title: "Authentication cancelled by the system")
            case LAError.Code.userCancel.rawValue:
                print("Authentication cancelled by the user")
                self.viaBio = false
                self.showToast(title: "Authentication cancelled by the user")
            case LAError.Code.userFallback.rawValue:
                print("User wants to use a password")
                OperationQueue.main.addOperation({ () -> Void in
                })
            case LAError.Code.touchIDNotEnrolled.rawValue:
                print("TouchID not enrolled")
                self.showToast(title: "TouchID not enrolled")
            case LAError.Code.passcodeNotSet.rawValue:
                print("Passcode not set")
                self.showToast(title: "Passcode not set")
            default:
                print("Authentication failed")
                self.showToast(title: "Authentication failed")
                OperationQueue.main.addOperation({ () -> Void in
                })
            }
        })
    }
    
    
    @IBAction func textfieldPin(_ sender: PasswordTextField) {
        if pinTextField.text?.count == 6
        {
            //            loginAction()
        }
    }
    private func navigateToHome()
    {
        //     LoginChnaged
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
    }
    func getOneSignalUUIDD(){
        //One Signal Start
        //         let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        //         let hasPrompted = status.permissionStatus.hasPrompted
        //         print("hasPrompted = \(hasPrompted)")
        //         let userStatus = status.permissionStatus.status
        //         print("userStatus = \(userStatus)")
        //         let isSubscribed = status.subscriptionStatus.subscribed
        //         print("isSubscribed = \(isSubscribed)")
        //         let userSubscriptionSetting = status.subscriptionStatus.userSubscriptionSetting
        //         print("userSubscri ptionSetting = \(userSubscriptionSetting)")
        //         let userID = status.subscriptionStatus.userId
        //         print("userID = \(userID)")
        //        DataManager.instance.userUUID = userID
        //         let pushToken = status.subscriptionStatus.pushToken
        //         print("pushToken = \(pushToken)")
        //     let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
        //                print("Received Notification - \(notification?.payload.notificationID) - \(notification?.payload.title)")
        //            }
        //One Signal End
        
    }
    func loginAction() {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
       
        
        showActivityIndicator()
        var pessi : String?
        var userCnic : String?
        
        //      let compelteUrl = GlobalConstants.BASE_URL + "v2/fundsTransferIbft"
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/login"
        
        if KeychainWrapper.standard.hasValue(forKey: "userKey") && viaBio == true {
//            pessi = KeychainWrapper.standard.string(forKey: "userKey")
            pessi = UserDefaults.standard.string(forKey: "userKey")
        }
        
        else if let password = pinTextField.text {
            
            pessi = password
            UserDefaults.standard.set(pessi, forKey: "userKey")
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
      
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        //userCnic!
        //    "\(DataManager.instance.userCnic!)
        //        mustChange
        guard let cnic = UserDefaults.standard.string(forKey: "userCnic")else {
            let parameters = ["cnic":   "\(DataManager.instance.userCnic!)","loginPin":"\(pessi!)","imeiNo":"\(DataManager.instance.imei!)","ipAddress":"\(DataManager.instance.ipAddress! )","channelId":"\(DataManager.instance.channelID )","longitude":"\(DataManager.instance.Longitude!)","latitude":"\(DataManager.instance.Latitude!)","uuid":"\(DataManager.instance.userUUID ?? "e5f458f7-a1ad-4398-92ba-62c15a22738d")" ,"osVersion": "\(systemVersion ?? "")"]
            return
        }
        
        let parameters = ["cnic":   userCnic!,"loginPin":"\(pessi!)","imeiNo":"\(DataManager.instance.imei!)","ipAddress":"\(DataManager.instance.ipAddress! )","channelId":"\(DataManager.instance.channelID )","longitude":"\(DataManager.instance.Longitude!)","latitude":"\(DataManager.instance.Latitude!)","uuid":"\(DataManager.instance.userUUID ?? "e5f458f7-a1ad-4398-92ba-62c15a22738d")" ,"osVersion": "\(systemVersion ?? "")"]
        //        testcase
        
        //        GlobalData.lat = DataManager.instance.Latitude
        //        GlobalData.long = DataManager.instance.Longitude
        print(parameters)
        
        let result = splitString(stringToSplit: base64EncodedString(params: parameters))
        //        print(parameters)
        //        print(result.apiAttribute1)
        //        print(result.apiAttribute2)
        
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        
        // longitude and latitude round off to 4 digits
        
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecret]
        
        
        print(params)
        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<login>) in
            //            Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LoginActionModel>) in
            self.hideActivityIndicator()
            self.loginObj = response.result.value
            if response.response?.statusCode == 200 {
                FBEvents.logEvent(title: .Login_success)
                FaceBookEvents.logEvent(title: .Login_success)
                
                if self.pinTextField.text != ""
                {
                    UserDefaults.standard.set(self.pinTextField.text, forKey: "userKey")
                }
                self.loginObj = response.result.value
                if self.loginObj?.responsecode == 2 || self.loginObj?.responsecode == 1 {
                    if self.loginObj?.data != nil{
                        
                        if let accessToken = self.loginObj?.data?.token{
                            DataManager.instance.accessToken = accessToken
                            DataManager.instance.accountType = self.loginObj?.data?.customerHomeScreens?[0].accountType
                            DataManager.instance.customerId = self.loginObj?.data?.customerHomeScreens?[0].customerId
                            print("\(accessToken)")
                            if let passKey = self.pinTextField.text{
                                let saveSuccessful : Bool = KeychainWrapper.standard.set(passKey, forKey: "userKey")
                                print("SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
                            }
                            
                        }
                        if self.loginObj?.data?.customerHomeScreens?[0].accountDormant == "Y"
                        {
                            let vc = storyboard?.instantiateViewController(withIdentifier: "dormantPopupVC") as! dormantPopupVC
                            vc.consentStatus = loginObj?.data?.customerHomeScreens?[0].accountDormant
                            vc.loginHistoryId = loginObj?.data?.customerHomeScreens?[0].loginHistoryId
                            //                            DataManager.instance.accessToken   = loginObj?.data?.customerHomeScreens?[0].token
                            self.navigationController?.pushViewController(vc, animated: true)
                            //                            self.present(vc, animated: true)
                        }
                        else
                        {
                            self.saveInDataManager()
                        }
                    }
                }
                else{
                    let message = self.loginObj?.messages ?? ""
//                    if self.loginObj?.responseblock == nil {

                    if self.loginObj?.responseblock?.responseType?.lowercased() == "L".lowercased() {
                        lbl_InvalidPassword.isHidden = true
                        self.showAlertCustomPopup(title: "", message: message,iconName: .iconError) {_ in
                            self.navigationController?.popViewController(animated: true)
                            self.moveToSignUp!()
                        }
                    }
                    else if self.loginObj?.responseblock?.responseType?.lowercased() == "P".lowercased() {
                        lbl_InvalidPassword.isHidden = false
                        lbl_InvalidPassword.text = message
                        lbl_InvalidPassword.textColor = .red
                    }
                    else {
                        lbl_InvalidPassword.isHidden = false
                        lbl_InvalidPassword.text = message
                        lbl_InvalidPassword.textColor = .red
                    }
                    //                    if let message = self.loginObj?.messages{
                    //                        if message == "Password Authentication Failed" {
                    //                            lbl_InvalidPassword.isHidden = false
                    //                            lbl_InvalidPassword.text = message
                    //                            lbl_InvalidPassword.textColor = .red
                    //                        }
                    //
                    //                      else
                    //                        {
                    //                          lbl_InvalidPassword.isHidden = true
                    //                          self.showAlertCustomPopup(title: "", message: message,iconName: .iconError)
                    //                      }
                    
                    
                    
                    //                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError, buttonNames: [
                    //
                    //                            ["buttonName": "OK",
                    //                            "buttonBackGroundColor": UIColor.clrOrange,
                    //                            "buttonTextColor": UIColor.white]
                    
                    //                                ["buttonName": "CANCEL",
                    //                                "buttonBackGroundColor": UIColor.clrOrange,
                    //                                "buttonTextColor": UIColor.white]
                    
                    
                    //                        ] as? [[String: AnyObject]])
                    
                }
            }
            else{
                self.showDefaultAlert(title: "Requested Rejected", message: "Network Connection Error! Please Check your internet Connection & try again.")
            }
            print(response.result.value)
            print(response.response?.statusCode)
        }
    }
}
extension Login_VC: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
    }
    func textFieldValueChanged(_ textField: PinCodeTextField) {
    }
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        self.loginAction()
        //        self.navigateToHome()
        
        return true
    }
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}

//    func Accountencrypy(plaintext : String , password : String) -> String
//    {
//        let data: Data = plaintext.data(using: .utf8)!
//        let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//        let encryptedstring : String = encryptedData.base64EncodedString()
//        print("encryptedstring",encryptedstring)
//        DataManager.AccountNo = encryptedstring
//
//        return encryptedstring
//
//
//    }
//    func FirstNameencrypy(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//           DataManager.FirstNAme = encryptedstring
//
//           return encryptedstring
//
//
//       }
//    func MiddleNameencrypy(plaintext : String , password : String) -> String
//          {
//              let data: Data = plaintext.data(using: .utf8)!
//              let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//              let encryptedstring : String = encryptedData.base64EncodedString()
//              print("encryptedstring",encryptedstring)
//              DataManager.MiddleName = encryptedstring
//
//              return encryptedstring
//
//
//    }
//    var AccountNoDecrypt = ""
//     func AccNodecrypt(encryptedText: String, password: String) -> String{
//            do{
//                let data: Data = Data(base64Encoded: encryptedText)!
//                let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
//                let decryptedString = String(data: decryptedData, encoding: .utf8)
//                print("decryptedString",decryptedString)
//             DataManager.AccountNo  = decryptedString!
//                return decryptedString ?? ""
//            }
//            catch{
//                return "Failed"
//            }
//        }
//
//    func LastNameencrypy(plaintext : String , password : String) -> String
//            {
//                let data: Data = plaintext.data(using: .utf8)!
//                let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//                let encryptedstring : String = encryptedData.base64EncodedString()
//                print("encryptedstring",encryptedstring)
//                DataManager.LastName = encryptedstring
//
//                return encryptedstring
//
//
//            }
//    func AccountIdencrypy(plaintext : String , password : String) -> String
//                {
//                    let data: Data = plaintext.data(using: .utf8)!
//                    let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//                    let encryptedstring : String = encryptedData.base64EncodedString()
//                    print("encryptedstring",encryptedstring)
//                    DataManager.AccountID  = encryptedstring
//
//                    return encryptedstring
//
//
//                }
//    func AccountAliasencrypy(plaintext : String , password : String) -> String
//                   {
//                       let data: Data = plaintext.data(using: .utf8)!
//                       let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//                       let encryptedstring : String = encryptedData.base64EncodedString()
//                       print("encryptedstring",encryptedstring)
//                       DataManager.AccountAlias  = encryptedstring
//
//                       return encryptedstring
//
//
//                   }
//    func BalanceDateencrypy(plaintext : String , password : String) -> String
//                      {
//                          let data: Data = plaintext.data(using: .utf8)!
//                          let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//                          let encryptedstring : String = encryptedData.base64EncodedString()
//                          print("encryptedstring",encryptedstring)
//                          DataManager.BalanceDate  = encryptedstring
//
//                          return encryptedstring
//
//
//                      }
//    func CurrentBalanceencrypy(plaintext : String , password : String) -> String
//                         {
//                             let data: Data = plaintext.data(using: .utf8)!
//                             let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//                             let encryptedstring : String = encryptedData.base64EncodedString()
//                             print("encryptedstring",encryptedstring)
//                             DataManager.Currentbalanc  = encryptedstring
//
//                             return encryptedstring
//
//
//                         }
//
//    func CoustomerIDencrypy(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//           DataManager.coustomerID = encryptedstring
//
//           return encryptedstring
//
//       }
//
//
//    var AccesstokenAfterDecrypt = ""
//
//    func AccessTokenDecrypt(encryptedText: String, password: String) -> String{
//           do{
//               let data: Data = Data(base64Encoded: encryptedText)!
//               let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
//               let decryptedString = String(data: decryptedData, encoding: .utf8)
//               print("decryptedString",decryptedString)
//            AccesstokenAfterDecrypt = decryptedString!
//               return decryptedString ?? ""
//            print(AccesstokenAfterDecrypt)
//
//           }
//           catch{
//               return "Failed"
//           }
//
//
//       }
//    ------------------- Encrypt data save in datamanger--------
//    func lasttransamtEncrypt(plaintext : String , password : String) -> String
//       {
//
//        let data: Data = plaintext.data(using: .utf8)!
//        let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//        let encryptedstring : String = encryptedData.base64EncodedString()
//        print("encryptedstring",encryptedstring)
//        DataManager.lasttransamt = encryptedstring
//           return encryptedstring
//
//       }
//    func dailyamtlmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.dailyamtlmt = encryptedstring
//
//           return encryptedstring
//
//       }
//    func dailytranslmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.dailytranslmt = encryptedstring
//
//           return encryptedstring
//
//       }
//    func monthlyamtlmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.monthlyamtlmt = encryptedstring
//
//           return encryptedstring
//
//       }
//
//    func monthlytranslmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.monthlytranslmt = encryptedstring
//
//           return encryptedstring
//
//       }
//    func yearlyamtlmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.yearlyamtlmt = encryptedstring
//
//           return encryptedstring
//
//       }
//    func yearlytranslmtEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.yearlytranslmt = encryptedstring
//
//           return encryptedstring
//
//       }
//
//    func levelDescrEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.levelDescr = encryptedstring
//           return encryptedstring
//
//       }
//    func accountPicEncrypt(plaintext : String , password : String) -> String
//       {
//           let data: Data = plaintext.data(using: .utf8)!
//           let encryptedData = try RNCryptor.encrypt(data: data, withPassword: encryptionkey)
//           let encryptedstring : String = encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.accountPic = encryptedstring
//
//           return encryptedstring
//
//       }
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
//    func encript(myvalue : String){
//              do {
//
//                  let message = myvalue
//
//                  let aes = try AES(key: "eBfArhcHpZe7jIqS", iv: "7829278610206212") // aes128
//                  let ciphertext = try aes.encrypt(Array(message.utf8))
//                  ecn = Data(ciphertext).base64EncodedString()
//
//                  print("-=-=- Encription -=-=-=")
//                  print("enc is",ecn)
//                DataManager.MiddleName = ecn
//                  print("-=-=- End -=-=-=")
//
//              } catch { }
//
//          }
//
