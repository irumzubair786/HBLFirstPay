//
//  GenerateOtpForEmailVC.swift
//  First Pay
//
//  Created by Irum Zubair on 13/08/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
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
var isfromVerifyEmail = ""
var IsFromUpdateEmail = ""
var emails = ""
class GenerateOtpForEmailVC: BaseClassVC, UITextFieldDelegate {
    var maintitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if AlreadEmailVerify == "true"
        {
//        emailtextfield.text = DataManager.instance.Checkemail
//            emailtextfield.isUserInteractionEnabled = false
            lblMain.text = "Update Email".addLocalizableString(languageCode: languageCode)
            emailtextfield.text = ""
            emailtextfield.isUserInteractionEnabled = true
        }
        if isfromVerifyEmail == "true"
        {
            lblMain.text = "Email Verification".addLocalizableString(languageCode: languageCode)
            emailtextfield.text =  DataManager.instance.emailExists
            emailtextfield.isUserInteractionEnabled = true
        }
    if IsFromUpdateEmail == "true"
        {
            lblMain.text = "Update Email".addLocalizableString(languageCode: languageCode)
            emailtextfield.text = ""
            emailtextfield.isUserInteractionEnabled = true
        }
        
        
        
        
        emailtextfield.delegate = self
        self.dismissKeyboard()
        btnnext.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btncancel.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
      
        lblEnterEmail.text = "Enter Your Email".addLocalizableString(languageCode: languageCode)
        emailtextfield.placeholder = "Enter Your Email".addLocalizableString(languageCode: languageCode)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblEnterEmail: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnnext: UIButton!
    var responseobj : GenericResponse?
    @IBAction func backpressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.logoutUser()
       
    }

    @IBOutlet weak var emailtextfield: UITextField!



    @IBAction func submit(_ sender: UIButton) {
        if isValidEmail(testStr: emailtextfield.text!)
        {
            print("Valid Email ID")
            // self.showToast(title: "Validate EmailID")
        }
        else
        {
            print("Invalid Email ID")
            self.showDefaultAlert(title: "Error", message: "Invalid Email ID")
            return
        }

        self.generateOtpForEmail()
    }
    
    private func generateOtpForEmail(){

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


        let compelteUrl = GlobalConstants.BASE_URL + "v2/generateOtpForEmail"
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

        let parameters = ["cnic":userCnic!,"email": emailtextfield.text!, "imei": DataManager.instance.imei!,"channelId": DataManager.instance.channelID]

//        GlobalData.lat = DataManager.instance.Latitude
//        GlobalData.long = DataManager.instance.Longitude
        print(parameters)

        let result = splitString(stringToSplit: base64EncodedString(params: parameters))
//        print(parameters)
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]


        print(params)
        print(compelteUrl)

        NetworkManager.sharedInstance.enableCertificatePinning()
        print(
            DataManager.instance.accessToken)
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
     //       Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CitiesList>) in

            self.hideActivityIndicator()

            self.responseobj = response.result.value
            if response.response?.statusCode == 200 {

                if self.responseobj?.responsecode == 2 || self.responseobj?.responsecode == 1 {

                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "verifyOtpForEmailVC") as! verifyOtpForEmailVC
                    emails = self.emailtextfield.text ?? ""
                   
//                    DataManager.instance.UserEmail  = self.emailtextfield.text!
                    vc.IsFromEmailOTp = "true"
                    self.navigationController!.pushViewController(vc, animated: true)
                }
                else{
                    if let message = self.responseobj?.messages{
                        self.showDefaultAlert(title: "", message: message)

                    }
                }
            }
            else {
                if let message = self.responseobj?.messages{
                    self.showDefaultAlert(title: "", message: message)

                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }

}
