//
//  EmailSideDrawerVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 27/01/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import RNCryptor
import Kingfisher
var AlreadEmailVerify = ""
class EmailSideDrawerVC: BaseClassVC {
    var GenericResponseObj : GenericResponse?
    var checkEmailVerificationObj : checkEmailVerification?
   var isFromUpdate = ""
   var isFromVerify = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEmailVerification()
//        CheckEmailVerified()
        blurview.alpha = 0.9
        
        print("Check value is ",DataManager.instance.accountTitle)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var blurview: UIVisualEffectView!
    override func viewWillAppear(_ animated: Bool) {
        checkEmailVerification()
    }
    @IBAction func back(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
 
   
    @IBOutlet weak var lblMain: UILabel!
    //---------------Verify Email procee----------------
    
    private  func checkEmailVerification() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "v2/checkEmailVerification"
        
        print(compelteUrl)
//        print("user email already", DataManager.instance.UserEmail)
        print("user userUUID already", DataManager.instance.userUUID)
        // IPA Params
        let params = ["cnic":userCnic!, "imei": DataManager.instance.imei!, "channelId" : DataManager.instance.channelID, ] as [String : Any]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        let result = (splitString(stringToSplit: base64EncodedString(params: params)))
        let paramsencoded = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        
        print(paramsencoded)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: paramsencoded , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<checkEmailVerification>) in
            
            
            //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<lasttransaction>) in
            
            self.hideActivityIndicator()
            
            self.checkEmailVerificationObj = response.result.value
            
            if response.response?.statusCode == 200 {
             
            self.checkEmailVerificationObj = response.result.value
                if self.checkEmailVerificationObj?.responsecode == 2 || self.checkEmailVerificationObj?.responsecode == 1 {
                    
//                    DataManager.instance.Checkemail = "irum@gamil.com"
//                    DataManager.instance.CheckEmailVerified = "N"
                    
                    
                    DataManager.instance.Checkemail = self.checkEmailVerificationObj?.EmailData?.checkEmail
                    DataManager.instance.CheckEmailVerified = self.checkEmailVerificationObj?.EmailData?.checkEmailVerified
                    print("email verification is ", DataManager.instance.CheckEmailVerified)
                    if ((self.checkEmailVerificationObj?.EmailData?.checkEmail != nil) && (self.checkEmailVerificationObj?.EmailData?.checkEmailVerified == "Y"))
                    {
//                    if DataManager.instance.Checkemail != nil &&  DataManager.instance.CheckEmailVerified == "Y"{
                        self.lblMain.text = "Update Email"
                        let getemail = UserDefaults.standard.string(forKey: "EmailVerification")
                        let consentAlert = UIAlertController(title: "Already Verified Email", message: "Dear \(DataManager.instance.accountTitle! ?? "") your Email \(DataManager.instance.Checkemail ?? "") is Already Verified. Do you want Update the Same" , preferredStyle: UIAlertControllerStyle.alert)
           
                        consentAlert.addAction(UIAlertAction(title: "YES".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                           AlreadEmailVerify = "true"
                self.getOtpForEmailVerification()
                
                
                
    //
            }))
            
            consentAlert.addAction(UIAlertAction(title: "NO".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
    //            checkloanapply = "false"
                let vc =  self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                //
                    self.navigationController!.pushViewController(vc, animated: true)
//                self.navigationController!.popToRootViewController(animated: true)
                
                
    //            print("Handle Cancel Logic here")
            }))
                        self.present(consentAlert, animated: true, completion: nil)
        
                    }
                    else if ((self.checkEmailVerificationObj?.EmailData?.checkEmail == nil) && (self.checkEmailVerificationObj?.EmailData?.checkEmailVerified == "N"))
                    {
//                    else if ((DataManager.instance.Checkemail == nil) && (DataManager.instance.CheckEmailVerified == "N"))
//                    {
                        self.lblMain.text = "Update Email"
                        let message = "Dear \(DataManager.instance.accountTitle! ?? "") You have not yet registered your email address\(DataManager.instance.Checkemail ?? ""), please update and verify the same, to enjoy transactions alerts the other services.  Do you want to Update the Same??"
                        let consentAlert = UIAlertController(title: "Email Not Provided", message: message , preferredStyle: UIAlertControllerStyle.alert)
           
            consentAlert.addAction(UIAlertAction(title: "UPDATE".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
    //
                
                self.getOtpForEmailVerification()
                
                
    //
            }))
            
            consentAlert.addAction(UIAlertAction(title: "CANCEL".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
    //            checkloanapply = "false"
                let vc =  self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                //
                    self.navigationController!.pushViewController(vc, animated: true)
    //            print("Handle Cancel Logic here")
            }))
                        self.present(consentAlert, animated: true, completion: nil)
                       
                        
                        
                    }
                    else if ((self.checkEmailVerificationObj?.EmailData?.checkEmail != nil) && (self.checkEmailVerificationObj?.EmailData?.checkEmailVerified == "N"))
                    {
                    
                    
//                    else if ((DataManager.instance.Checkemail != nil) && (DataManager.instance.CheckEmailVerified == "N"))
//                    {
                        self.lblMain.text = "Email Verification"
                        let getemail = UserDefaults.standard.string(forKey: "EmailVerification")
                        let message = "Dear \(DataManager.instance.accountTitle! ?? "") Your email \(DataManager.instance.Checkemail ?? "") is not Verified Yet, if your Provided email is correct, please verify the same, otherwise update the same to enjoy transaction alert the other services."
                        let consentAlert = UIAlertController(title: "Unverified Email", message: message , preferredStyle: UIAlertControllerStyle.alert)
           
            consentAlert.addAction(UIAlertAction(title: "VERIFY".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
              
//              Unverified Email
                
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GenerateOtpForEmailVC") as! GenerateOtpForEmailVC
                isfromVerifyEmail = "true"
                IsFromUpdateEmail = "false"
//                    vc.maintitle  = "Verify Email".addLocalizableString(languageCode: languageCode)
                    self.navigationController?.pushViewController(vc, animated: true)
                

                
                
    //
            }))
                        consentAlert.addAction(UIAlertAction(title: "UPDATE".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                IsFromUpdateEmail = "true"
                            self.getOtpForEmailVerification()
                            
                            
                //
                        }))
            
            consentAlert.addAction(UIAlertAction(title: "Remind me Later".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
    //            checkloanapply = "false"
                let vc =  self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                //
                    self.navigationController!.pushViewController(vc, animated: true)
                
    //            print("Handle Cancel Logic here")
            }))
                        self.present(consentAlert, animated: true, completion: nil)
                        
                    }
                   
                    
                   
                }
                        else {
                 
                        if let message = self.checkEmailVerificationObj?.messages{
                                               self.showAlert(title: "", message: message, completion: {
                                                   let vc =  self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                                   //
                                                       self.navigationController!.pushViewController(vc, animated: true)
                                                                      })
                        }
                        
                                                  
                    }
                }
            
            
        
            else {
                if let message = self.checkEmailVerificationObj?.messages{
                                       self.showAlert(title: "", message: message, completion: {
                                           let vc =  self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                           //
                                               self.navigationController!.pushViewController(vc, animated: true)
                                                              })
                }
            }
            }
        }
    
    
    private  func getOtpForEmailVerification() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "v2/getOtpForEmailVerification"
        
        print(compelteUrl)
        
        // IPA Params
        let params = ["cnic":userCnic!, "imei": DataManager.instance.imei!, "accountType" : DataManager.instance.accountType!, "channelId" : DataManager.instance.channelID]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        let result = (splitString(stringToSplit: base64EncodedString(params: params)))
        let paramsencoded = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        
        print(paramsencoded)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: paramsencoded , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            
            //        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<lasttransaction>) in
            
            self.hideActivityIndicator()
            
            self.GenericResponseObj = response.result.value
            
            if response.response?.statusCode == 200 {
                
                self.GenericResponseObj = response.result.value
                if self.GenericResponseObj?.responsecode == 2 || self.GenericResponseObj?.responsecode == 1 {
                    
                   
                        let vc =  self.storyboard!.instantiateViewController(withIdentifier: "verifyOtpForEmailVC") as! verifyOtpForEmailVC
                        IsFromUpdateEmail = "true"
                    isfromVerifyEmail = "false"
                        vc.mainTitle = "Update Email".addLocalizableString(languageCode: languageCode)
                        self.navigationController!.pushViewController(vc, animated: true)
                    
                   
                    
                }
                else {
                    if let message = self.GenericResponseObj?.messages{
                        UtilManager.showAlertMessage(message: (self.GenericResponseObj?.messages)!, viewController: self)
//                                                 self.showAlert(title: "", message: message, completion:nil)
                    }
                }
            }
            else {
                self.showAlert(title: "", message: "No internert Connection ", completion:nil)
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }

}
