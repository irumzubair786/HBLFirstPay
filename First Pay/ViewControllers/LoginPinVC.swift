////
////  LoginPinVC.swift
////  First Wallet
////
////  Created by Syed Uzair Ahmed on 14/11/2018.
////  Copyright © 2018 FMFB Pakistan. All rights reserved.
////
//
//import UIKit
//import KYDrawerController
//import Alamofire
//import AlamofireObjectMapper
//import MapKit
//import PinCodeTextField
//import SwiftKeychainWrapper
//import LocalAuthentication
//import SafariServices
//import Foundation
//import CryptoSwift
//import RNCryptor
//
//class LoginPinVC: BaseClassVC  {
//
//       var homeObj : HomeModel?
//    var concateString = ""
//    var ecn = ""
//    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
//
////    ------------for hra
//
//    @IBOutlet weak var lblfirstawaz: UILabel!
//    @IBOutlet weak var lblFaceid: UILabel!
//    @IBOutlet weak var btnFirstAwz: UIButton!
//    @IBOutlet weak var lblTOUCHID: UILabel!
//    @IBOutlet weak var btnCreateNewAccount: UIButton!
//    @IBOutlet weak var btnFirstAwaz: UIButton!
//    @IBOutlet weak var btnTouchId: UIButton!
//    @IBOutlet weak var btnFaceiD: UIButton!
//    @IBOutlet weak var btnLoginWithother: UIButton!
//    @IBOutlet weak var btnForgotPassword: UIButton!
//    @IBOutlet weak var btnLogin: UIButton!
//    @IBOutlet weak var btnCreateWallet: UIButton!
//    var timer = Timer()
//        var counter = 0
//        @IBOutlet weak var pagecontrol: UIPageControl!
//        @IBOutlet weak var rotatingview: UIView!
//        @IBOutlet weak var outerview: UIView!
//        @IBOutlet weak var blurview: UIVisualEffectView!
//    @IBOutlet weak var pinTextField: PinCodeTextField!
//    var viaBio : Bool = false
//    var loginObj : LoginActionModel?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        ConvertLanguage()
//        // Do any additional setup after loading the view.
//        blurview.isHidden = true
//        outerview.isHidden = true
//        pinTextField.delegate = self
//        pinTextField.resignFirstResponder()
//        pinTextField.keyboardType = .namePhonePad
//        self.hideKeyboardWhenTappedAround()
//        DispatchQueue.main.async { [self] in
//            self.AccessTokenDecrypt(encryptedText: self.loginObj?.userData?.token ?? "" , password: encryptionkey)
//           print(self.loginObj?.userData?.token)
//        }
//        DispatchQueue.main.async {
//            self.AccNodecrypt(encryptedText: DataManager.AccountNo, password: self.encryptionkey)
//
//        }
//
//    }
//
//    func ConvertLanguage()
//    {
//
//        btnCreateWallet.setTitle("Create/Update FirstPay".addLocalizableString(languageCode: languageCode), for: .normal)
//        btnLogin.setTitle("LOGIN".addLocalizableString(languageCode: languageCode), for: .normal)
//        btnForgotPassword.setTitle("Forgot Password".addLocalizableString(languageCode: languageCode), for: .normal)
//        btnLoginWithother.setTitle("LOGIN WITH ANOTHER ACCOUNT".addLocalizableString(languageCode: languageCode), for: .normal)
//        lblFaceid.text = "Face ID".addLocalizableString(languageCode: languageCode)
//        lblTOUCHID.text = "Touch ID".addLocalizableString(languageCode: languageCode)
//        lblfirstawaz.text = "Awaaz".addLocalizableString(languageCode: languageCode)
//
//
//    }
//    func transitionAnimation1(view: UIView, animationOptions: UIView.AnimationOptions, isReset: Bool) {
//            let durationOfAnimationInSecond = 0.5
//            UIView.transition(with: view, duration: durationOfAnimationInSecond, options: animationOptions, animations: {
//                //view.backgroundColor = UIColor.init(named: isReset ? "darkGreen" :  "darkRed")
//            }){ finished in
//                var isAnimated = false
//                self.transitionAnimation1(view: self.rotatingview, animationOptions: .transitionFlipFromRight, isReset: isAnimated)
//            }
//        }
//    @objc func changeImage() {
//
//           if counter < 4 {
//            let index = IndexPath.init(item: counter, section: 0)
//
//                pagecontrol.currentPage = counter
//                counter += 1
//            } else {
//                counter = 0
//                let index = IndexPath.init(item: counter, section: 0)
//
//                pagecontrol.currentPage = counter
//                counter = 1
//            }
//        //        changeImage()
//        }
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
//
//    // MARK: - Action Methods
//
//    @IBAction func loginAction(_ sender: Any) {
//
//        if pinTextField.text?.count == 0  {
//            UtilManager.showToast(message: "Please Enter Your Password")
////            self.showToast(title: "Please Enter Your Password")
//            return
//        }
//        if pinTextField.text == nil && viaBio == false {
//            UtilManager.showToast(message: "Please Enter Your Password")
//            return
//        }
//
//        self.loginAction()
//    }
//
//    @IBAction func loginActionviaTouchID(_ sender: Any) {
//
//        if KeychainWrapper.standard.bool(forKey: "enableTouchID") == true {
//            self.authenticateUserViaTouchID()
//            viaBio = true
//            print("true")
//        }
//        else {
//            self.showToast(title: "Please Enable TouchID/FaceID by logging in with your Password")
//            print("false")
//        }
////        self.authenticateUserViaTouchID()
////        viaBio = true
//    }
//
//    @IBAction func loginWithAnotherAccount(_ sender: Any) {
////        let createWalletVC = self.storyboard!.instantiateViewController(withIdentifier: "CreateWalletRegVC") as! CreateWalletRegVC
////        DataManager.instance.registerNewDevice = true
////        DataManager.instance.forgotPassword = false
////        self.navigationController!.pushViewController(createWalletVC, animated: true)
//        let createWalletVC = self.storyboard!.instantiateViewController(withIdentifier: "CreateWalletRegVC") as! CreateWalletRegVC
//        DataManager.instance.registerNewDevice = true
//        DataManager.instance.forgotPassword = false
//        self.navigationController!.pushViewController(createWalletVC, animated: true)
////        let regVC = self.storyboard!.instantiateViewController(withIdentifier: "RegisterationVC") as! RegisterationVC
////        regVC.fromLoginWithAnotherAcccount = true
////        self.navigationController!.pushViewController(regVC, animated: true)
//    }
//    @IBAction func forgotAction(_ sender: Any) {
//        let createWalletVC = self.storyboard!.instantiateViewController(withIdentifier: "CreateWalletRegVC") as! CreateWalletRegVC
//        DataManager.instance.forgotPassword = true
//        DataManager.instance.registerNewDevice = false
//        self.navigationController!.pushViewController(createWalletVC, animated: true)
//    }
//


//    @IBAction func createUpdatePressed(_ sender: Any) {
//           let createWalletVC = self.storyboard!.instantiateViewController(withIdentifier: "CreateWalletRegVC") as! CreateWalletRegVC
//                  DataManager.instance.registerNewDevice = false
//                  DataManager.instance.forgotPassword = false
//                  self.navigationController!.pushViewController(createWalletVC, animated: true)
//       }
//
//    @IBAction func firstAwaazPressed(_ sender: Any) {
//
//        let url = URL(string: "https://awaz.hblmfb.com/")
//        let vc = SFSafariViewController(url: url!)
//        present(vc, animated: true, completion: nil)
//    }
//
//    //MARK: - Utility Methods
//
////    private func navigateToHome(){
////
////        let mainViewController   = self.storyboard!.instantiateViewController(withIdentifier: "HomeNavCntlr") as! UINavigationController
////
////        mainViewController.accountyp = self.loginObj?.userData?.customerHomeScreens?[0].accountType
////        mainViewController.cusid = self.loginObj?.userData?.customerHomeScreens?[0].customerId
//
//
////        let drawerViewController = self.storyboard!.instantiateViewController(withIdentifier: "SideDrawerVC") as! SideDrawerVC
////        var drawerController:KYDrawerController? = nil
////
////        drawerController = KYDrawerController(drawerDirection: .left,drawerWidth: 290)
////        drawerController!.mainViewController = mainViewController
////        drawerController!.drawerViewController = drawerViewController
////
////        self.navigationController! .pushViewController(drawerController!, animated: true)
//
//
//
////        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
////        mainViewController.accountyp = self.loginObj?.userData?.customerHomeScreens?[0].accountType
////             mainViewController.cusid = self.loginObj?.userData?.customerHomeScreens?[0].customerId
////
////        self.navigationController!.pushViewController(homeVC, animated: true)
//    }
//    func decrypt(encryptedText: String, password: String) -> String{
//           do{
//               let data: Data = Data(base64Encoded: encryptedText)!
//               let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
//               let decryptedString = String(data: decryptedData, encoding: .utf8)
//               return decryptedString ?? ""
//            print("decrytion is ",decryptedString)
//
//           }
//           catch{
//               return "Failed"
//           }
//    }
//
//
////       }
//
////  let key = "eBfArhcHpZe7jIqS"
////    let iv = "7829278610206212"
////    let s = DataManager.encryptionResult
////    let enc = try! DataManager.encryptionResult.aesEncrypt(key: "eBfArhcHpZe7jIqS" , iv: "7829278610206212")
////    let dec = try! enc.aesDecrypt(key: "eBfArhcHpZe7jIqS" , iv: "7829278610206212")
//
//   //FirstNameencrypy
////    -------------------data save encryopt in datamanager------------------
//
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
////    ------------------- Encrypt data save in datamanger--------
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
//           let encryptedstring : String =
//           encryptedData.base64EncodedString()
//           print("encryptedstring",encryptedstring)
//        DataManager.levelDescr = encryptedstring
//
//
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
////    ---------------------end--------------
//    private func saveInDataManager(){
//        //IRUM
////        DataManager.instance.customerId = self.loginObj?.userData?.customerHomeScreens?[0].customerId
////        DataManager.instance.firstName = self.loginObj?.userData?.customerHomeScreens?[0].firstName
////        DataManager.instance.lastName = self.loginObj?.userData?.customerHomeScreens?[0].lastName
////        DataManager.instance.middleName = self.loginObj?.userData?.customerHomeScreens?[0].middleName
////        DataManager.instance.accountId = self.loginObj?.userData?.customerHomeScreens?[0].accountId
////        DataManager.instance.accountAlias = self.loginObj?.userData?.customerHomeScreens?[0].accountAlias
////        DataManager.instance.accountNo = self.loginObj?.userData?.customerHomeScreens?[0].accountNo
////        DataManager.instance.balanceDate = self.loginObj?.userData?.customerHomeScreens?[0].balanceDate
////        DataManager.instance.currentBalance = self.loginObj?.userData?.customerHomeScreens?[0].currentBalance
//////-------------------encryption save data in Datamanager
////        concateString = "\(String(describing: self.loginObj?.userData?.customerHomeScreens?[0].customerId)),\(self.loginObj?.userData?.customerHomeScreens?[0].firstName ?? ""),\(String(describing: self.loginObj?.userData?.customerHomeScreens?[0].lastName)),\(self.loginObj?.userData?.customerHomeScreens?[0].middleName ?? ""),\(self.loginObj?.userData?.customerHomeScreens?[0].accountId ?? 0),\(self.loginObj?.userData?.customerHomeScreens?[0].accountAlias ?? ""),\(self.loginObj?.userData?.customerHomeScreens?[0].accountNo ?? ""),\(String(describing: self.loginObj?.userData?.customerHomeScreens?[0].balanceDate)),\(String(describing: self.loginObj?.userData?.customerHomeScreens?[0].currentBalance))"
//
//////        encryption work
////        DataManager.instance.insured = self.loginObj?.userData?.customerHomeScreens?[0].insured
////        print(self.loginObj?.userData?.customerHomeScreens?[0].insured)
////        print(self.loginObj?.userData?.customerHomeScreens?[0].insured)
//////    --------------calling encryption data
////        print(self.loginObj?.userData?.customerHomeScreens?[0].accountNo)
////        Accountencrypy(plaintext: (self.loginObj?.userData?.customerHomeScreens?[0].accountNo)!, password: encryptionkey)
////
////        FirstNameencrypy(plaintext: (self.loginObj?.userData?.customerHomeScreens?[0].firstName)!, password: encryptionkey)
////        MiddleNameencrypy(plaintext: (self.loginObj?.userData?.customerHomeScreens?[0].middleName) ?? "", password: encryptionkey)
////        LastNameencrypy(plaintext: (self.loginObj?.userData?.customerHomeScreens?[0].lastName)!, password: encryptionkey)
////        let AccountIdInString = String((self.loginObj?.userData?.customerHomeScreens?[0].accountId)!)
////        AccountIdencrypy(plaintext: AccountIdInString, password: encryptionkey)
////        let accountALiasinString = String((self.loginObj?.userData?.customerHomeScreens?[0].accountAlias)  ?? "")
////        AccountAliasencrypy(plaintext: accountALiasinString, password: encryptionkey)
////        BalanceDateencrypy(plaintext: (self.loginObj?.userData?.customerHomeScreens?[0].balanceDate)!, password: encryptionkey)
////        let currentBlncInString = String(((self.loginObj?.userData?.customerHomeScreens?[0].currentBalance)!))
////        CurrentBalanceencrypy(plaintext: "\(currentBlncInString)", password: encryptionkey)
////
//////-------------end-------------
////
//////        --------------calling encryption transaction --------------
////
////        let a = String((self.loginObj?.userData?.customerHomeScreens?[0].lasttransamt)!)
////        lasttransamtEncrypt(plaintext: "\(a)" , password: encryptionkey)
////
////        let b = String((self.loginObj?.userData?.customerHomeScreens?[0].dailyamtlmt)!)
////        dailyamtlmtEncrypt(plaintext: b, password: encryptionkey)
////
////        let c = String((self.loginObj?.userData?.customerHomeScreens?[0].dailytranslmt)!)
////        dailytranslmtEncrypt(plaintext: "\(c)", password: encryptionkey)
////
////        let d = Int((self.loginObj?.userData?.customerHomeScreens?[0].monthlyamtlmt) ?? 0)
////        monthlyamtlmtEncrypt(plaintext: "\(d)", password: encryptionkey)
////
////        let e = Int((self.loginObj?.userData?.customerHomeScreens?[0].monthlytranslmt) ?? 0)
////        monthlytranslmtEncrypt(plaintext: "\(e)", password: encryptionkey)
////
////        let f = Int((self.loginObj?.userData?.customerHomeScreens?[0].yearlyamtlmt) ?? 0)
////        yearlyamtlmtEncrypt(plaintext: "\(f)", password: encryptionkey)
////
////        let g = Int((self.loginObj?.userData?.customerHomeScreens?[0].yearlytranslmt) ?? 0)
////        yearlytranslmtEncrypt(plaintext: "\(g)", password: encryptionkey)
////
////        levelDescrEncrypt(plaintext: (self.loginObj?.userData?.customerHomeScreens?[0].levelDescr)!, password: encryptionkey)
////        accountPicEncrypt(plaintext: (self.loginObj?.userData?.customerHomeScreens?[0].accountPic) ?? "", password: encryptionkey)
////        AccessTokenEncrypt(plaintext: (self.loginObj?.userData?.token)!, password: encryptionkey)
////        print(self.loginObj?.userData?.token)
////        -----------------end-----------------------
//
////     <<---------------------------------->>
////        updated model login
////     <<----------------------------------->>
//
//
//
//
//                AccessTokenEncrypt(plaintext: (self.loginObj?.userData?.token)!, password: encryptionkey)
//                print(self.loginObj?.userData?.token)
//
//
//
//
//        if let url = URL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
//            let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                guard let data = data, error == nil else { return }
//
//                DispatchQueue.main.async { /// execute on main thread
////                    let pngImage =  UIImage(data: data)
////                    UserDefaults.standard.set(pngImage, forKey: "proImage")
//                }
//            }
//            task.resume()
//        }
//
//
//        var accountName : String?
//        if KeychainWrapper.standard.hasValue(forKey: "accountTitle") {
//            accountName = KeychainWrapper.standard.string(forKey: "accountTitle")
//            DataManager.instance.accountTitle = accountName
//        }
////        else{
////            DataManager.instance.accountTitle = self.loginObj?.userData?.customerHomeScreens?[0].accountTitile
////        }
////
////        if let arrTypes = self.loginObj?.userData?.customerHomeScreens {
////
////            for aAccountType in arrTypes {
////
////                let type = aAccountType.levelDescr
////                print(type)
////
////                DataManager.instance.arrAccountType.append("\(type!)")
////
////                print(DataManager.instance.arrAccountType)
////
////            }
////        }
//
//
////        DataManager.instance.lasttransamt = self.loginObj?.userData?.customerHomeScreens?[0].lasttransamt
////        DataManager.instance.dailyamtlmt = self.loginObj?.userData?.customerHomeScreens?[0].dailyamtlmt
////        DataManager.instance.dailytranslmt = self.loginObj?.userData?.customerHomeScreens?[0].dailytranslmt
////        DataManager.instance.monthlyamtlmt = self.loginObj?.userData?.customerHomeScreens?[0].monthlyamtlmt
////        DataManager.instance.monthlytranslmt = self.loginObj?.userData?.customerHomeScreens?[0].monthlytranslmt
////        DataManager.instance.yearlyamtlmt = self.loginObj?.userData?.customerHomeScreens?[0].yearlyamtlmt
////        DataManager.instance.yearlytranslmt = self.loginObj?.userData?.customerHomeScreens?[0].yearlytranslmt
////        DataManager.instance.levelDescr = self.loginObj?.userData?.customerHomeScreens?[0].levelDescr
////        DataManager.instance.emailVerified = self.loginObj?.userData?.customerHomeScreens?[0].emailVerified
////        print("emailverified is :" ,DataManager.instance.emailVerified)
//
//        DataManager.instance.nanoloan = self.loginObj?.userData?.customerHomeScreens?[0].nanoloan! ?? ""
//        print("nanoloan is :" , self.loginObj?.userData?.customerHomeScreens?[0].nanoloan)
//        DataManager.instance.riskprofile = self.loginObj?.userData?.customerHomeScreens?[0].riskProfile ?? ""
//        self.navigateToHome()
//
//    }
//
//
//
////    private func saveInDataManager(){
////
//////        DataManager.instance.customerId = self.loginObj?.customerId
//////        DataManager.instance.firstName = self.loginObj?.firstName
//////        DataManager.instance.lastName = self.loginObj?.lastName
//////        DataManager.instance.middleName = self.loginObj?.middleName
//////        DataManager.instance.accountId = self.loginObj?.accountId
//////        DataManager.instance.accountAlias = self.loginObj?.accountAlias
//////        DataManager.instance.accountNo = self.loginObj?.accountNo
//////        DataManager.instance.balanceDate = self.loginObj?.balanceDate
//////        DataManager.instance.currentBalance = self.loginObj?.currentBalance
//////
//////        var accountName : String?
//////        if KeychainWrapper.standard.hasValue(forKey: "accountTitle") {
//////            accountName = KeychainWrapper.standard.string(forKey: "accountTitle")
//////            DataManager.instance.accountTitle = accountName
//////        }
//////        else{
//////            DataManager.instance.accountTitle = self.loginObj?.accountTitile
//////        }
//////
//////        DataManager.instance.lasttransamt = self.loginObj?.lasttransamt
//////        DataManager.instance.dailyamtlmt = self.loginObj?.dailyamtlmt
//////        DataManager.instance.dailytranslmt = self.loginObj?.dailytranslmt
//////        DataManager.instance.monthlyamtlmt = self.loginObj?.monthlyamtlmt
//////        DataManager.instance.monthlytranslmt = self.loginObj?.monthlytranslmt
//////        DataManager.instance.yearlyamtlmt = self.loginObj?.yearlyamtlmt
//////        DataManager.instance.yearlytranslmt = self.loginObj?.yearlytranslmt
//////        DataManager.instance.levelDescr = self.loginObj?.levelDescr
//////        DataManager.instance.accountPic = self.loginObj?.accountPic
////
////        self.navigateToHome()
////
////    }
//
//
//
//
//
//
//    //MARK: - TextField Delegates
//
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        //        if range.length + range.location > (textField.text?.characters.count)! {
//        //            return false
//        //        }
//        //        let newLength:Int = (textField.text?.characters.count)! + string.characters.count - range.length
//
//        if range.length + range.location > (textField.text?.count)!{
//            return false
//        }
//        let newLength:Int = (textField.text?.count)! + string.count - range.length
//
//        if newLength == 6 {
//            self.loginAction()
//
//        }
//
//        return true
//    }
//
//    func authenticateUserViaTouchID() {
//
//        let touchIDManager = PITouchIDManager()
//
//        touchIDManager.authenticateUser(success: { () -> () in
//            OperationQueue.main.addOperation({ () -> Void in
//                self.loginAction()
//
//            })
//        }, failure: { (evaluationError: NSError) -> () in
//            switch evaluationError.code {
//            case LAError.Code.systemCancel.rawValue:
//                print("Authentication cancelled by the system")
//                self.showToast(title: "Authentication cancelled by the system")
//            case LAError.Code.userCancel.rawValue:
//                print("Authentication cancelled by the user")
//                self.viaBio = false
//                self.showToast(title: "Authentication cancelled by the user")
//            case LAError.Code.userFallback.rawValue:
//                print("User wants to use a password")
//                OperationQueue.main.addOperation({ () -> Void in
//                })
//            case LAError.Code.touchIDNotEnrolled.rawValue:
//                print("TouchID not enrolled")
//                self.showToast(title: "TouchID not enrolled")
//            case LAError.Code.passcodeNotSet.rawValue:
//                print("Passcode not set")
//                self.showToast(title: "Passcode not set")
//            default:
//                print("Authentication failed")
//                self.showToast(title: "Authentication failed")
//                OperationQueue.main.addOperation({ () -> Void in
//                })
//            }
//        })
//    }
//    //----Function encryption
////       func encript(myvalue : String){
////           do {
////
////               let message = myvalue
////
////               let aes = try AES(key: "eBfArhcHpZe7jIqS", iv: "7829278610206212") // aes128
////               let ciphertext = try aes.encrypt(Array(message.utf8))
////               ecn = Data(ciphertext).base64EncodedString()
////
////               print("-=-=- Encription -=-=-=")
////               print("enc is",ecn)
////               print("-=-=- End -=-=-=")
////           } catch { }
////
////       }
//
//    var checkEmailVerificationObj : checkEmailVerification?
//    // MARK: - API CALL
//    private  func checkEmailVerification() {
//
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
//        showActivityIndicator()
//        var userCnic : String?
//        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//        }
//        else{
//            userCnic = ""
//        }
//
//        let compelteUrl = GlobalConstants.BASE_URL + "v2/checkEmailVerification"
//
//        print(compelteUrl)
////        print("user email already", DataManager.instance.UserEmail)
//        print("user userUUID already", DataManager.instance.userUUID)
//        // IPA Params
//        let params = ["cnic":userCnic!, "imei": DataManager.instance.imei!, "channelId" : DataManager.instance.channelID, ] as [String : Any]
//        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//        let result = (splitString(stringToSplit: base64EncodedString(params: params)))
//        let paramsencoded = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//
//
//        print(paramsencoded)
//
//        print(params)
//        print(compelteUrl)
//        print(header)
//
//
//        NetworkManager.sharedInstance.enableCertificatePinning()
//
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: paramsencoded , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<checkEmailVerification>) in
//
//
//            //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<lasttransaction>) in
//
//            self.hideActivityIndicator()
//
//            self.checkEmailVerificationObj = response.result.value
//
//            if response.response?.statusCode == 200 {
//
//            self.checkEmailVerificationObj = response.result.value
//                if self.checkEmailVerificationObj?.responsecode == 2 || self.checkEmailVerificationObj?.responsecode == 1 {
//                    DataManager.instance.Checkemail = self.checkEmailVerificationObj?.EmailData?.checkEmail
//                    DataManager.instance.CheckEmailVerified = self.checkEmailVerificationObj?.EmailData?.checkEmailVerified
//
//        }
//            }
//        }
//    }
//
//
//
//
//
//
//
//
//
////    end
//
//    func loginAction() {
//
//        pagecontrol.numberOfPages = 4
//                pagecontrol.currentPage = 0
//        blurview.alpha = 0.4
//        blurview.isHidden = false
//        outerview.isHidden = false
//                DispatchQueue.main.async {
//                self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
//                }
//
//                var isAnimated = false
//                self.transitionAnimation1(view: self.rotatingview, animationOptions: .transitionFlipFromRight, isReset: isAnimated)
//                changeImage()
//
//
//
//        if !NetworkConnectivity.isConnectedToInternet(){
//            self.showToast(title: "No Internet Available")
//            return
//        }
////        showActivityIndicator()
//
//
//        var pessi : String?
//        var userCnic : String?
//
////        let compelteUrl = GlobalConstants.BASE_URL + "login"
//        let compelteUrl = GlobalConstants.BASE_URL + "v2/login"
//
//
//        if KeychainWrapper.standard.hasValue(forKey: "userKey") && viaBio == true {
//            pessi = KeychainWrapper.standard.string(forKey: "userKey")
//        }
//        else if let password = pinTextField.text {
//            pessi = password
//        }
//        else{
//            self.showDefaultAlert(title: "", message: "Please Use Password for first time Login after Registration")
//            self.hideActivityIndicator()
//            return
//        }
//        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
//            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
//        }
//        else{
//            userCnic = ""
//        }
////        "customerId": 9,
////                       "firstName": "ZAHEER",
////                       "lastName": "ZAKARIA",
////                       "middleName": "KHAN-2",
////                       "accountId": 11,
////                       "accountAlias": null,
////                       "accountNo": "03329204070",
////                       "balanceDate": "06-01-2021",
////                       "currentBalance": 989786,
////                       "accountTitile": "ZAHEER  ZAKARIA",
////                       "lasttransamt": 1,
////                       "dailyamtlmt": 999999999999999,
////                       "dailytranslmt": 999999999999999,
////                       "monthlyamtlmt": 999999999999999,
////                       "monthlytranslmt": 999999999999999,
////                       "yearlyamtlmt": 999999999999999,
////                       "yearlytranslmt": 999999999999999,
////                       "levelDescr": "LEVEL 1",
////                       "accountPic": null,
////                       "token": null,
////                       "accountType": "20"
//////                   },
//
//
////        let parameters = ["firstName" :DataManager.instance.firstName!, "lastName":DataManager.instance.lastName!,"middleName" : DataManager.instance.middleName!, "accountId" :DataManager.instance.accountId!,"accountAlias": DataManager.instance.accountAlias!,"accountNo": DataManager.instance.accountNo!,"balanceDate": DataManager.instance.balanceDate!,"currentBalance": DataManager.instance.currentBalance!,"accountTitile" :DataManager.instance.accountTitle!, "lasttransamt" :DataManager.instance.Latitude!, "dailyamtlmt" :DataManager.instance.dailyamtlmt!, "dailytranslmt" :DataManager.instance.dailytranslmt!,"monthlytranslmt" : DataManager.instance.monthlyamtlmt!, "monthlytranslmt" :DataManager.instance.monthlytranslmt!, "yearlyamtlmt" : DataManager.instance.yearlyamtlmt!, "yearlytranslmt" : DataManager.instance.yearlytranslmt!, "levelDescr" : DataManager.instance.levelDescr!, "accountPic" : DataManager.instance.accountPic!, "token": DataManager.instance.token!, "accountType" :DataManager.instance.accountType!]  as [String : Any]!
////
//
//
//
//
//        let parameters = ["cnic":userCnic!,"loginPin":pessi!,"imeiNo":DataManager.instance.imei!,"ipAddress":DataManager.instance.ipAddress!,"channelId":"\(DataManager.instance.channelID)","longitude":"\(DataManager.instance.Longitude!)","latitude":"\(DataManager.instance.Latitude!)","uuid":"\(DataManager.instance.userUUID ?? "")"]
//
////        GlobalData.lat = DataManager.instance.Latitude
////        GlobalData.long = DataManager.instance.Longitude
//        print(parameters)
//
//        let result = splitString(stringToSplit: base64EncodedString(params: parameters))
////        print(parameters)
////        print(result.apiAttribute1)
////        print(result.apiAttribute2)
//
//        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//
//
//        // longitude and latitude round off to 4 digits
//
//        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
//
//
//        print(params)
//        print(compelteUrl)
//        NetworkManager.sharedInstance.enableCertificatePinning()
//
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LoginActionModel>) in
////            Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LoginActionModel>) in
////            self.hideActivityIndicator()
//            self.loginObj = response.result.value
//
//            if response.response?.statusCode == 200 {
//
//                self.loginObj = response.result.value
//                if self.loginObj?.responsecode == 2 || self.loginObj?.responsecode == 1 {
////                    testingemail
////                    DataManager.instance.emailVerified = "N"
////                    DataManager.instance.emailExists = "irum@gmail.com"
////                    self.checkEmailVerification()
//                    DataManager.instance.emailVerified = self.loginObj?.userData?.customerHomeScreens?[0].checkEmailVerified
//                    DataManager.instance.emailExists = self.loginObj?.userData?.customerHomeScreens?[0].checkEmail
//                    if self.loginObj?.userData?.customerHomeScreens?[0].riskProfile == "Y"{
//                       let createWalletVC = self.storyboard!.instantiateViewController(withIdentifier: "RiskProfileVC") as! RiskProfileVC
//
//                         if let accessToken = self.loginObj?.userData?.token{
//                            DataManager.instance.accessToken = accessToken
//                            DataManager.instance.accountType = self.loginObj?.userData?.customerHomeScreens?[0].accountType
//                            DataManager.instance.customerId = self.loginObj?.userData?.customerHomeScreens?[0].customerId
//                            print("\(accessToken)")
//                         }
//                        self.navigationController!.pushViewController(createWalletVC, animated: true)
//                    }
//
////                    DataManager.instance
//                else{
//
//                    self.blurview.isHidden = true
//                    self.outerview.isHidden = true
//
//                     if let accessToken = self.loginObj?.userData?.token{
//                        DataManager.instance.accessToken = accessToken
//                        DataManager.instance.accountType = self.loginObj?.userData?.customerHomeScreens?[0].accountType
//                        DataManager.instance.customerId = self.loginObj?.userData?.customerHomeScreens?[0].customerId
//                        print("\(accessToken)")
//                        if let passKey = self.pinTextField.text{
//                            let saveSuccessful : Bool = KeychainWrapper.standard.set(passKey, forKey: "userKey")
//                            print("SuccessFully Added to KeyChainWrapper \(saveSuccessful)")
//                        }
//                        self.saveInDataManager()
//                    }
//
//
//                else {
//                    self.blurview.isHidden = true
//                    self.outerview.isHidden = true
//                    if let message = self.loginObj?.messages{
//                        self.showDefaultAlert(title: "", message: message)
//                    }
//                    // Html Parse
//
//                    if let title = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue){
//                        if title.contains("Request Rejected") {
//                            self.showDefaultAlert(title: "", message: "Network Connection Error. Contact 0800 42563")
//                        }
//                    }
//                }
//
//            }
//        }
//            else {
//                self.blurview.isHidden = true
//                self.outerview.isHidden = true
//                if let message = self.loginObj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
//                }
////                    self.showAlert(title: "", message: "Something Went Wrong", completion:nil)
////                print(response.result.value)
////                print(response.response?.statusCode)
//            }
//
//}
//    }
//}
//
//
//
//}
//
//
//extension LoginPinVC: PinCodeTextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
//        return true
//    }
//    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
//    }
//    func textFieldValueChanged(_ textField: PinCodeTextField) {
//    }
//    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
//        self.loginAction()
//
//        return true
//    }
//    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
//        return true
//    }
//}
//
//extension Int {
//    static func parse(from string: String) -> Int? {
//        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
//    }
//}
//
