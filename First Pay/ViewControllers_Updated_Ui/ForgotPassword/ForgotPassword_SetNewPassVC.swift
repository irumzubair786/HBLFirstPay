//
//  ForgotPassword_SetNewPassVC.swift
//  First Pay
//
//  Created by Irum Butt on 14/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper


class ForgotPassword_SetNewPassVC:BaseClassVC , UITextFieldDelegate {
    let systemVersion = UIDevice.current.systemVersion
    let devicemodel = UIDevice.current.localizedModel
    var genericResponseObj : GenericResponseModel?
    override func viewDidLoad() {
        FBEvents.logEvent(title: .Signup_forgotpass_landed)
        super.viewDidLoad()
        cnicTextField.becomeFirstResponder()
        cnicTextField.delegate = self
        mobileNumberTextField.delegate = self
        lbl_InvalidCnic.isHidden = true
        cnicTextField.placeholder = "3740516XXXXX5"

        lblInvalidMobileNo.text = "Invalid Mobile Number.Please enter correct number."
        lblInvalidMobileNo.isHidden = true
//        btn_next.isUserInteractionEnabled = false
        getIMEI()
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        IMG_NEXT_ARROW.isUserInteractionEnabled = false
        IMG_NEXT_ARROW.addGestureRecognizer(tapGestureRecognizerr)
//        mobileNumberTextField.mode = .localNumber
//        cnicTextField.mode = .cnic
//
        self.mobileNumberTextField.addTarget(self, action: #selector(changeTextInTextField), for: .editingDidEnd)
        
        self.cnicTextField.addTarget(self, action: #selector(changeTextInTextField2), for: .editingChanged)
        
        
    }
    var phoneArr = ["0301","0302","0303","0304","0305","0306","0307","0308","0309","0310","0311", "0312","0313","0314","0315","0316","0317","0318","0319","0320","0321","0322","0323","0324","0325","0331","0332","0333","0334","0335","0336","0340","0341","0342","0343","0344","0345","0346","0347","0348","0349","0355"]
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var Main_view: UIView!
    @IBOutlet weak var lbl_InvalidCnic: UILabel!
    @IBOutlet weak var cnicTextField: UITextField!
    
    @IBOutlet weak var IMG_NEXT_ARROW: UIImageView!
    @IBOutlet weak var lblInvalidMobileNo: UILabel!
    @IBOutlet weak var btn_next: UIButton!
    @IBAction func Action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        
        if textField == mobileNumberTextField{
          
            return newLength <= 15
        }
        
        else {
            cnicTextField.isUserInteractionEnabled = true
            return newLength <= 13
            
        }
        
        
    }
    
    
    
    @IBAction func Action_Next(_ sender: UIButton) {
        
//        DataManager.instance.userCnic = cnicTextField.text
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
        else {
               verifyCustResetPass()
        }

    }
    
    
    @IBAction func textfieldCnic(_ sender: UITextField) {
    
        if mobileNumberTextField.text?.count ?? 0 < 15
        {
            lblInvalidMobileNo.isHidden = false
            lblInvalidMobileNo.text = "Invalid Mobile Number"
            btn_next.isUserInteractionEnabled = false
            let image = UIImage(named: "grayArrow")
            IMG_NEXT_ARROW.image = image
//0
            
        }

            if cnicTextField.text?.count ?? 0 < 13
            {
                lbl_InvalidCnic.isHidden = false
                lbl_InvalidCnic.text = "Invalid Cnic"
                btn_next.isUserInteractionEnabled = false
                let image = UIImage(named: "grayArrow")
                IMG_NEXT_ARROW.image = image
                
            }
        
            else if cnicTextField.text == ""
            {
                lbl_InvalidCnic.isHidden = true
            }
            else
            {
                
                let image = UIImage(named: "]greenarrow")
                IMG_NEXT_ARROW.image = image
//                btn_next.setImage(image, for: .normal)
                btn_next.isUserInteractionEnabled = true
                lbl_InvalidCnic.isHidden = true
                lblInvalidMobileNo.isHidden = true
                
            }
        }
        
        
    
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let newLength = (textField.text?.count)! + string.count - range.length
//
//        if textField == mobileNumberTextField
//        { mobileNumberTextField.isUserInteractionEnabled = true
//
//            if mobileNumberTextField.text?.count == 4
//
//            {
//                var flag: Bool = false
//                for i in phoneArr
//                {
//                    if(i == mobileNumberTextField.text)
//                    {
//                        flag = true
//                    }
//
//                }
//                if flag == false{
//                    lblInvalidMobileNo.isHidden = false
//                    btn_next.isUserInteractionEnabled = false
//                    let image = UIImage(named: "grayArrow")
//                    IMG_NEXT_ARROW.image = image
//
//                }
//                else{
//                    lblInvalidMobileNo.isHidden = true
//
//                }
//
//
//            }
//
//
//            return newLength <= 11
//        }
//
//        if textField == cnicTextField{
//            cnicTextField.isUserInteractionEnabled = true
//            return newLength <= 15
//        }
//
//
//        if textField == cnicTextField
//        {
//            lbl_InvalidCnic.isHidden = true
//        }
//
//
//
//
//
//       return true
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {
//        let getFirstDigit = mobileNumberTextField?.text?.substring(to: 1)
//        print("getFirstDigit done ",getFirstDigit )

        if mobileNumberTextField.text?.count ?? 0 < 15
        {
            lblInvalidMobileNo.isHidden = false
            lblInvalidMobileNo.text = "Invalid Mobile Number.Please enter correct number."
            btn_next.isUserInteractionEnabled = false
            let image = UIImage(named: "grayArrow")
            IMG_NEXT_ARROW.image = image
//
            
        }
       
        else
        {
            lblInvalidMobileNo.isHidden = true
            
        }
         if textField == cnicTextField
        {
            if cnicTextField.text?.count ?? 0 < 13
            {
                lbl_InvalidCnic.isHidden = false
                lbl_InvalidCnic.text = "Invalid Cnic"
                btn_next.isUserInteractionEnabled = false
                let image = UIImage(named: "grayArrow")
                IMG_NEXT_ARROW.image = image
                
            }
           
            else if cnicTextField.text == ""
            {
                lbl_InvalidCnic.isHidden = true
            }
            else
            {
                
                let image = UIImage(named: "]greenarrow")
                IMG_NEXT_ARROW.image = image
//                btn_next.setImage(image, for: .normal)
                btn_next.isUserInteractionEnabled = true
                lbl_InvalidCnic.isHidden = true
                lblInvalidMobileNo.isHidden = true
                
            }
        }
        
    }

    @objc func changeTextInTextField() {
        
        let text = mobileNumberTextField.text!.replacingOccurrences(of: "+92-", with: "")
          if mobileNumberTextField.text?.count == 1 && text == "0" {
              mobileNumberTextField.text = nil
              return
          }
        mobileNumberTextField.text = format(with: "+92-XXX-XXXXXXX", phone: text)
        
        if mobileNumberTextField.text?.count ?? 0 < 15
        {
            lblInvalidMobileNo.isHidden = false
            lblInvalidMobileNo.text = "Invalid Mobile Number.Please enter correct number."
            btn_next.isUserInteractionEnabled = false
            let image = UIImage(named: "grayArrow")
            IMG_NEXT_ARROW.image = image
        }
        else
        {
            lblInvalidMobileNo.isHidden = true
            
        }
    }
    @objc func changeTextInTextField2() {
        let a = cnicTextField.text?.replacingOccurrences(of: "-", with: "")
        
        if (cnicTextField.text?.count ?? 0) == 13
        {
            let image = UIImage(named: "]greenarrow")
            IMG_NEXT_ARROW.image = image
//                btn_next.setImage(image, for: .normal)
            btn_next.isUserInteractionEnabled = true
            lbl_InvalidCnic.isHidden = true
            lblInvalidMobileNo.isHidden = true
 
        }
        else if (cnicTextField.text?.count ?? 0) != 13 ||  mobileNumberTextField.text?.count ?? 0 < 15
        {
            lbl_InvalidCnic.isHidden = false
            lbl_InvalidCnic.text = "Invalid Cnic"
            btn_next.isUserInteractionEnabled = false
            let image = UIImage(named: "grayArrow")
            IMG_NEXT_ARROW.image = image
        }
        
        
    }
    var mobileNumber: String?
    private func verifyCustResetPass() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "WalletCreation/v1/verifyCustResetPass"
        
        
        //    "osVersion": "15.5", "appVersion": "3.1.2", "deviceModel": "iPhone", "channelId": "1", "mobileNo": "03406401050", "imeiNo": "B0749FED5A5D48A38C9DBFF01F4A5663", "cnic": "3740526510394"\
        
        
        let a = mobileNumberTextField.text!
        
        mobileNumber = a.replacingOccurrences(of: "-", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: "_", with: "")
        mobileNumber = mobileNumber?.replacingOccurrences(of: "+92", with: "0")
        let b = cnicTextField.text!
        var cnicNumber = b.replacingOccurrences(of: "-", with: "")
        cnicNumber = cnicNumber.replacingOccurrences(of: "_", with: "")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":cnicNumber,"mobileNo":(mobileNumber!),"imeiNo":DataManager.instance.imei!,"appVersion": DataManager.instance.appversion,"osVersion": systemVersion,"deviceModel": devicemodel] as [String : Any]
        //51
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        print(params)
        print(header)
        print(compelteUrl)
        FBEvents.logEvent(title: .Signup_forgotpass_attempt)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<GenericResponseModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.genericResponseObj = Mapper<GenericResponseModel>().map(JSONObject: json)
            
//            self.genericResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                FBEvents.logEvent(title: .Signup_forgotpass_success)
                if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "ForgotPassword_OTPVerificationVC") as! ForgotPassword_OTPVerificationVC
                    vc.Fetch_MobNo = self.mobileNumber
                    vc.fetchCnic = self.cnicTextField.text!
                    DataManager.instance.userCnic = cnicNumber
                    self.navigationController!.pushViewController(vc, animated: true)
                }
                else {
                    if let message = self.genericResponseObj?.messages{
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
                if let message = self.genericResponseObj?.messages {
                    FBEvents.logEvent(title: .Signup_forgotpass_success, failureReason: message)

                    self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                }
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        verifyCustResetPass()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword_OTPVerificationVC") as! ForgotPassword_OTPVerificationVC
//        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    
    
    
    
}
//extension ForgotPassword_SetNewPassVC{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        if textField == mobileNumberTextField
////        {
////            if range.lowerBound <= 11{
////                if string.isBackspace{
////                    if textField.text?.count == 6{
////                        textField.text?.removeLast(1)
////
////                    }
////
////                    btn_next.backgroundColor = .gray
////                    btn_next.isUserInteractionEnabled = false
////
////                    return true
////                }
////                else{
////
////                    guard string.isNumeric(string: textField.text! as NSString, range: range) else { return false }
////
////                    //  insert 03 as prefix
////                    if textField.text?.count == 0{
////
////                        return (string == "0")
////                    }
////
////                    if textField.text?.count == 1{
////
////                        return (string == "3")
////                    }
////
////                    //  insert space after 03xx
////                    if textField.text?.count == 4{
////                        DispatchQueue.main.async {
////                            textField.text! += "-"+string
////                        }
////                    }
////                    let field = "\(textField.text ?? "")\(string)"
////
//////                    btn_next.isUserInteractionEnabled = field.count == 12 ? true : false
//////                    btn_next.backgroundColor = field.count == 12 ? .green : .gray
////                    return true
////                }
////
////            }
////            return false
////        }
////        //  will limit characters
////        else
////        {
//            if range.lowerBound <= 14{
//                if string.isBackspace{
//                    if textField.text?.count == 15{ textField.text?.removeLast(1) }
//                    if textField.text?.count == 7{ textField.text?.removeLast(1) }
////
////                    lbl_InvalidCnic.isHidden = false
////                    lbl_InvalidCnic.text = "Invalid Cnic"
////                    btn_next.isUserInteractionEnabled = false
////                    let image = UIImage(named: "grayArrow")
////                    IMG_NEXT_ARROW.image = image
//
//                    return true
//                }
//                else{
//
//                    guard string.isNumeric(string: textField.text! as NSString, range: range) else { return false }
//
//                    //  insert space after 03xx
//                    if textField.text?.count == 5{
//                        DispatchQueue.main.async {
//                            textField.text! += "-"+string
//                        }
//                    }else if textField.text?.count == 13{
//                        DispatchQueue.main.async {
//                            textField.text! += "-"+string
//
//                        }
//                    }
//                    let field = "\(textField.text ?? "")\(string)"
//
//
//                    if field.count == 14
//                    {
//                        let image = UIImage(named: "]greenarrow")
//                        IMG_NEXT_ARROW.image = image
//            //                btn_next.setImage(image, for: .normal)
//                        btn_next.isUserInteractionEnabled = true
//                        lbl_InvalidCnic.isHidden = true
//                        lblInvalidMobileNo.isHidden = true
//                    }
//                    else
//
//                    {
//                        lbl_InvalidCnic.isHidden = false
//                        lbl_InvalidCnic.text = "Invalid Cnic"
//                        btn_next.isUserInteractionEnabled = false
//                        let image = UIImage(named: "grayArrow")
//                        IMG_NEXT_ARROW.image = image
//                    }
//
//                    return true
//                }
//
//            }
//            return false
////        }
//
//    }
//}
