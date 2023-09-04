//
//  Mobile_VerificationVC.swift
//  First Pay
//
//  Created by Irum Butt on 09/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import RNCryptor
import Foundation
let systemVersion = UIDevice.current.systemVersion
let devicemodel = UIDevice.current.localizedModel
class Mobile_VerificationVC: BaseClassVC, UITextFieldDelegate {
    var mobileRegistrationObj : mobileRegistrationModel?
    @IBOutlet weak var titleName: UILabel!
    var isFromLoginScreen = false

    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
    
    override func viewDidLoad(){
        FBEvents.logEvent(title: .Signup_login_landed)
        super.viewDidLoad()
        if isFromLoginScreen {
            titleName?.text = "Sign-in"
            btn_Explore.isHidden = true
            

        }
        else {
            TF_Mobileno.becomeFirstResponder()
            titleName?.text = "Lets Get Started"
            btn_Explore.isHidden = false
        }
        getIMEI()
        getIPAddressmac()
        getWiFiAddress()
        TF_Mobileno.delegate = self
        lblinvalid.isHidden = true
        lblinvalid.text = ""
//        dismissKeyboard()
        btnContinue.isUserInteractionEnabled = false
        btn_next_arrow.isUserInteractionEnabled = false
//        TF_Mobileno.mode = .localNumber
        self.TF_Mobileno.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
       
    }
        
//    @objc func changeNumberInTextField() {
//    let text = textFieldNumber.text!.replacingOccurrences(of: "+92-", with: "")
//    if textFieldNumber.text?.count == 1 && text == "0" {
//        textFieldNumber.text = nil
//        return
//    }
//    textFieldNumber.text = format(with: "+92-XXX-XXXXXXX", phone: text)
//}
    @objc func keyboardWillShow(_ notification: Notification) {
        // Hide your button here
        btnContinue.isHidden = false
    }
    
    @objc func changeTextInTextField() {
        print("end editing")
        let text = TF_Mobileno.text!.replacingOccurrences(of: "+92-", with: "")
            if TF_Mobileno.text?.count == 1 && text == "0" {
                TF_Mobileno.text = nil
                return
            }
        TF_Mobileno.text = format(with: "+92-XXX-XXXXXXX", phone: text)
        if self.TF_Mobileno.text!.count != 15
        {
            self.lblinvalid.isHidden = false
//            self.lblinvalid.text = "Invalid Phone Number."
            let image = UIImage(named:"grayArrow")
            self.btn_next_arrow.setImage(image, for: .normal)
            self.btnContinue.isUserInteractionEnabled = false
        }

        else if self.TF_Mobileno.text == ""
    {
            self.lblinvalid.isHidden = true
    }
    else{
        self.lblinvalid.isHidden = true
        let image = UIImage(named:"]greenarrow")
        self.btn_next_arrow.setImage(image, for: .normal)
    
        self.btnContinue.isUserInteractionEnabled = true
        self.btn_next_arrow.isUserInteractionEnabled = true
    }
       
    }
    
    @objc func validateMobileNumber() {
            if let mobileNumber = TF_Mobileno.text {
                if mobileNumber.count  < 15 {
                    lblinvalid.isHidden = false
//                    lblinvalid.text = "Mobile number should be at least 11 digits"
                    let image = UIImage(named:"grayArrow")
                    self.btn_next_arrow.setImage(image, for: .normal)
                    self.btnContinue.isUserInteractionEnabled = false
                } else {
                    let image = UIImage(named:"]greenarrow")
                    self.btn_next_arrow.setImage(image, for: .normal)
                    self.btnContinue.isUserInteractionEnabled = true
                    self.btn_next_arrow.isUserInteractionEnabled = true
                    lblinvalid.isHidden = true
                }
            }
        }
    private func textFieldDidEndEditing(_ textField: NumberTextField) {
 
        if TF_Mobileno.text?.count != 15
            {

                TF_Mobileno .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
                lblinvalid.isHidden = false
                lblinvalid.text = "Invalid Phone Number."
                TF_Mobileno.resignFirstResponder()

                let image = UIImage(named:"grayArrow")
                btn_next_arrow.setImage(image, for: .normal)
                btnContinue.isUserInteractionEnabled = false
           
            }

        else if TF_Mobileno.text == ""
        {
            lblinvalid.isHidden = true
        }
        else{
            lblinvalid.isHidden = true
            let image = UIImage(named:"]greenarrow")
            btn_next_arrow.setImage(image, for: .normal)
            btnContinue.isUserInteractionEnabled = true
            btn_next_arrow.isUserInteractionEnabled = true
        }
        }
    
    
    
    override func getWiFiAddress() -> [String] {
       
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            var addr = ptr.pointee.ifa_addr.pointee
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }
    
    // MARK: - Get IMEI
    func getIMEIAddress(){

        let str = String(describing: UIDevice.current.identifierForVendor!)
        let replacedImei = str.replacingOccurrences(of: "-", with: "")
        DataManager.instance.imei = replacedImei
//        print(replacedImei)

        _ = KeyChainUtils.getUUID()!
//         print(udid)

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
    }
//    -------------------------------
//    OutLets
//    --------------------------------
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btn_Explore: UIButton!
    @IBOutlet weak var TF_Mobileno: UITextField!
    @IBOutlet weak var lblinvalid: UILabel!
    //    -------------------------------
    @IBOutlet weak var btn_next_arrow: UIButton!
    //    Actions
    //    --------------------------------
    var phoneArr = ["0301","0302","0303","0304","0305","0306","0307","0308","0309","0310","0311", "0312","0313","0314","0315","0316","0317","0318","0319","0320","0321","0322","0323","0324","0325","0331","0332","0333","0334","0335","0336","0339","0340","0341","0342","0343","0344","0345","0346","0347","0348","0349","0355"]

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTP_Mobile_VerificationVC") as! OTP_Mobile_VerificationVC
//         OTPVerifyVC.mobileNo = TF_Mobileno.text!
//        self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
        mobileRegistration()
    }
//    private func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let newLength = (textField.text?.count)! + string.count - range.length
//
//        if textField == TF_Mobileno
//        {
//            return newLength <= 11
//            TF_Mobileno.isUserInteractionEnabled = true
//            if TF_Mobileno.text?.count == 4
//
//            {
//                var flag: Bool = false
//                for i in phoneArr
//                {
//                    if(i == TF_Mobileno.text)
//                    {
//                        flag = true
//                    }
//
//                }
//                if flag == false{
//                    lblinvalid.isHidden = false
//                    lblinvalid.text = "Invalid Phone Number."
//                    btnContinue.isUserInteractionEnabled = false
//                    let image = UIImage(named: "grayArrow")
//                    btn_next_arrow.setImage(image, for: .normal)
//
//
//                }
//                else{
//                    lblinvalid.isHidden = true
//
//                }
//
//
//            }
//            return newLength <= 11
//            changeTextInTextField()
//
//
//        }
//        else {
//
//       return newLength <= 11
//                }
//        return newLength <= 11
//
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {

        let newLength = (textField.text?.count)! + string.count - range.length

        if textField == TF_Mobileno {

            return newLength <= 15 // Bool
        }
        else {

            return newLength <= 15
        }
    }
    
   
    @IBAction func btnContinue(_ sender: UIButton) {
        if TF_Mobileno.text?.count != 0{
            btnContinue.isUserInteractionEnabled = true
            move_to_next()
        }
    }
    func move_to_next()
    {
        mobileRegistration()
        
    }

    var AccesstokenAfterDecrypt = ""
//
    func AccessTokenDecrypt(encryptedText: String, password: String) -> String{
           do{
               let data: Data = Data(base64Encoded: encryptedText)!
               let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
               let decryptedString = String(data: decryptedData, encoding: .utf8)
               print("decryptedString",decryptedString)
            AccesstokenAfterDecrypt = decryptedString!
               return decryptedString ?? ""
            print(AccesstokenAfterDecrypt)

           }
           catch{
               return "Failed"
           }
        
    }
    var mobileNumber : String?
    private func  mobileRegistration() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        if (TF_Mobileno.text?.isEmpty)!{
            TF_Mobileno.text = ""
        }
        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/mobileRegistration"
        let a = TF_Mobileno.text!
        mobileNumber = a.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+92", with: "0")
        
//        "mobileNo": textFieldNumber.text!.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "+92", with: "0"),
      
        DataManager.instance.mobNo = mobileNumber!
        let parameters = ["channelId":"\(DataManager.instance.channelID)","appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel,"mobileNo":(DataManager.instance.mobNo),"imeiNo":"\(DataManager.instance.imei!)","ipAddressA":"\(DataManager.instance.ipAddress!)","ipAddressP":"\(DataManager.instance.ipAddress!)"]

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))

        print(parameters)

        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        print(params)
        print(compelteUrl)

        FBEvents.logEvent(title: .Signup_login_attempt)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<mobileRegistrationModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.mobileRegistrationObj = Mapper<mobileRegistrationModel>().map(JSONObject: json)

//            self.mobileRegistrationObj = response.result.value
            if response.response?.statusCode == 200 {
                FBEvents.logEvent(title: .Signup_login_success)

                if self.mobileRegistrationObj?.responsecode == 2 || self.mobileRegistrationObj?.responsecode == 1 {
                    if let accessToken = self.mobileRegistrationObj?.data?.token{
                        DataManager.instance.AuthToken = accessToken
                    }
                    let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTP_Mobile_VerificationVC") as! OTP_Mobile_VerificationVC
                    OTPVerifyVC.mobileNo = self.TF_Mobileno.text!
                    DataManager.instance.mobNo =  self.mobileNumber!
                    self.navigationController!.pushViewController(OTPVerifyVC, animated: true)


                }
                else {
                    if let message = self.mobileRegistrationObj?.messages{
                        self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
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
                if let message = self.mobileRegistrationObj?.messages {
                    FBEvents.logEvent(title: .Signup_login_success, failureReason: message)
                    self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                }
                else {
                    self.showDefaultAlert(title: "Requested Rejected", message: "Network Connection Error! Please Check your internet Connection & try again.")
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}

