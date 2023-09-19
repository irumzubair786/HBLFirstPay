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
import ObjectMapper
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
import OneSignalFramework
import FingerprintSDK

class Login_VC: BaseClassVC, UITextFieldDelegate  {
    var homeObj : HomeModel?
    var concateString = ""
    var ecn = ""
    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
    var viaBio : Bool = false
    var loginObj : login?
    var flag :Bool = false
    var moveToSignUp: (() -> ())!
    var isFromLoginScreen = true
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UITextField.appearance().tintColor = .systemBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UITextField.appearance().tintColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFaceIdActive()
        
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
        //>>>>>>> 9c3ef07 (add cash ui fix)
        
        labelOne.text = ""
        labelTwo.text = ""
        labelThree.text = ""
        labelFour.text = ""
        labelFive.text = ""
        labelSix.text = ""
        
        passwordShow(isShow: false)

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
    
    func checkFaceIdActive()
    {
        guard let  ActiveId = UserDefaults.standard.string(forKey:  "enableTouchID")else
        
        {
            pinTextField.becomeFirstResponder()
            print("not active")
            return
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
            show_text.setImage(UIImage(named: "eyeOrange"), for: .normal)
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
        //shakeel test code
//        self.navigateToHome()
//        return()
        
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
      
    }
    
    var fingerPrintVerification: FingerPrintVerification!

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
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecret]
        print(params)
        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { [self]
            //            (response: DataResponse<login>) in
            //            Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<LoginActionModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                //            self.loginObj = Mapper<login>().map(JSONObject: json)
                
                //            self.loginObj = response.result.value
                if response.response?.statusCode == 200 {
                    FBEvents.logEvent(title: .Login_success)
                    FaceBookEvents.logEvent(title: .Login_success)
                    
                    if self.pinTextField.text != "" {
                        UserDefaults.standard.set(self.pinTextField.text, forKey: "userKey")
                    }
                    self.loginObj = Mapper<login>().map(JSONObject: json)
                    
                    //                self.loginObj = response.result.value
                    
                    
                    
                    if self.loginObj?.responsecode == 2 || self.loginObj?.responsecode == 1 {
                        
                        //                    if self.loginObj?.responseblock?.responseType == nil
                        //                    {
                        //                        let message = self.loginObj?.messages ?? ""
                        //                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                        //                    }
                        //
                        //
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
                        
                        
                        if self.loginObj?.responseblock?.responseType == nil
                        {
                            
                            self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                        }
                        
                        else  if self.loginObj?.responseblock?.responseType?.lowercased() == "L".lowercased() {
                            lbl_InvalidPassword.isHidden = false
                            lbl_InvalidPassword.text = message
                            lbl_InvalidPassword.textColor = .red
                        }
                        else if self.loginObj?.responseblock?.responseType?.lowercased() == "I".lowercased() {
                            lbl_InvalidPassword.isHidden = false
                            lbl_InvalidPassword.text = message
                            lbl_InvalidPassword.textColor = .red
                        }
                        else if self.loginObj?.responseblock?.responseType?.lowercased() == "P".lowercased() {
                            lbl_InvalidPassword.isHidden = true
                            self.showAlertCustomPopup(title: "Device Authentication", message: message,iconName: .iconError, buttonNames: [
                                [
                                    "buttonName": "SIGN-IN",
                                    "buttonBackGroundColor": UIColor.clrOrange,
                                    "buttonTextColor": UIColor.white] as [String : Any],
                                [
                                    "buttonName": "CANCEL",
                                    "buttonBackGroundColor": UIColor.white,
                                    "buttonTextColor": UIColor.clrOrange]
                            ] as? [[String: AnyObject]]) {buttonName in
                                self.navigationController?.popViewController(animated: false)
                                if buttonName == "SIGN-IN" {
                                    self.moveToSignUp!()
                                }
                            }
                        }
                        else {
                            
                            lbl_InvalidPassword.isHidden = false
                            lbl_InvalidPassword.text = message
                            lbl_InvalidPassword.textColor = .red
                        }
                        
                    }
                }
                
                else{
                    
                    self.showDefaultAlert(title: "Requested Rejected", message: "Network Connection Error! Please Check your internet Connection & try again.")
                }
                print(response.value)
                print(response.response?.statusCode)
            }
        }
    }
    
    
    func fingerPrintVerification(viewController: UIViewController) {
        //#if targetEnvironment(simulator)
        //        #else

        let customUI = CustomUI(
            topBarBackgroundImage: nil,
            topBarColor: .clrNavigationBarBVS,
            topBarTextColor: .white,
            containerBackgroundColor: UIColor.white,
            scannerOverlayColor: UIColor.clrGreenBVS,
            scannerOverlayTextColor: UIColor.white,
            instructionTextColor: UIColor.white,
            buttonsBackgroundColor: .clrNextButtonBackGroundBVS,
            buttonsTextColor: UIColor.white,
            imagesColor: .clrGreenBVS,
            isFullWidthButtons: true,
            guidanceScreenButtonText: "NEXT",
            guidanceScreenText: "User Demo",
            guidanceScreenAnimationFilePath: nil,
            showGuidanceScreen: true)

        let customDialog = CustomDialog(
            dialogImageBackgroundColor: UIColor.white,
            dialogImageForegroundColor: .green,
            dialogBackgroundColor: UIColor.white,
            dialogTitleColor: .clrGreenBVS,
            dialogMessageColor: .clrBlack,
            dialogButtonTextColor: UIColor.white,
            dialogButtonBackgroundColor: .orange)
        
        let uiConfig = UIConfig(
            splashScreenLoaderIndicatorColor: .clrBlack,
            splashScreenText: "Please wait",
            splashScreenTextColor: UIColor.white,
            customUI: customUI,
            customDialog: customDialog,
            customFontFamily: nil)
        
        let fingerprintConfig = FingerprintConfig(mode: .EXPORT_WSQ,
                                                  hand: .BOTH_HANDS,
                                                  fingers: .EIGHT_FINGERS,
                                                  isPackPng: true, uiConfig: uiConfig)
        let vc = FaceoffViewController.init(nibName: "FaceoffViewController", bundle: Bundle(for: FaceoffViewController.self))
        
        vc.fingerprintConfig = fingerprintConfig
        vc.fingerprintResponseDelegate = viewController as? FingerprintResponseDelegate
        viewController.present(vc, animated: true, completion: nil)
        //        #endif
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
