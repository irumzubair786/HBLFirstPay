//
//  ChangepasswordVC.swift
//  First Pay
//
//  Created by Irum Butt on 27/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import PasswordTextField
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class ChangepasswordVC: BaseClassVC, UITextFieldDelegate {
    var genericObj:GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonback.setTitle("", for: .normal)
        oldPasswordTextfield.becomeFirstResponder()
        newPasswordTextfield.becomeFirstResponder()
        confirmPasswordTextfield.becomeFirstResponder()
        oldPasswordTextfield.delegate = self
        newPasswordTextfield.delegate = self
        confirmPasswordTextfield.delegate = self
        buttonContinue.isUserInteractionEnabled = false
        newPasswordTextfield.isUserInteractionEnabled = false
        confirmPasswordTextfield.isUserInteractionEnabled = false
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imgNextArrow.isUserInteractionEnabled = true
        imgNextArrow.addGestureRecognizer(tapGestureRecognizerr)
        self.newPasswordTextfield.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        self.confirmPasswordTextfield.addTarget(self, action: #selector(changeTextInTextField2), for: .editingChanged)
        //        lbl1.textColor = UIColor(hexValue: 0xFF3932)
        //        lbl2.textColor = UIColor(hexValue: 0xFF3932)
        //        lbl3.textColor = UIColor(hexValue: 0xFF3932)
        //        lbl4.textColor = UIColor(hexValue: 0xFF3932)
        buttonContinue.circle()
        
    }
    @objc func changeTextInTextField2() {
        if self.newPasswordTextfield.text?.count == 6  && oldPasswordTextfield.text?.count == 6 {
            //            if isAlphabaticContain() {
            lbl1.textColor = .clrGray
            lbl2.textColor = .clrGray
            lbl3.textColor = .clrGray
            lbl4.textColor = .clrGray
            let stringIntegersOnly = confirmPasswordTextfield.text!.getIntegerValue()
            let stringStringOnly = confirmPasswordTextfield.text!.getStringValue()
            
            var isPasswordValid = 0
            
            if (confirmPasswordTextfield?.text!.count)! >= 6 {
                lbl1.textColor = UIColor(hexValue: 0x00CC96)
                isPasswordValid += 1
            }
            if stringStringOnly != "" {
                lbl2.textColor = UIColor(hexValue: 0x00CC96)
                isPasswordValid += 1
            }
            if stringIntegersOnly != "" {
                lbl3.textColor = UIColor(hexValue: 0x00CC96)
                isPasswordValid += 1
            }
            if confirmPasswordTextfield.text! == newPasswordTextfield.text! {
                lbl4.textColor = UIColor(hexValue: 0x00CC96)
                isPasswordValid += 1
            }
            
            if isPasswordValid >= 4 {
                buttonContinue.isUserInteractionEnabled = true
                let img = UIImage(named: "]greenarrow")
                imgNextArrow.image = img
            }
            else {
                buttonContinue.isUserInteractionEnabled = false
                let img = UIImage(named: "grayArrow")
                imgNextArrow.image = img
            }
            //            self.confirmPasswordTextfield.resignFirstResponder()
        }
        print(self.confirmPasswordTextfield.text)
    }
    
    
    @objc func changeTextInTextField() {
        if self.newPasswordTextfield.text?.count == 6 {
            self.newPasswordTextfield.resignFirstResponder()
            
        }
        print(self.newPasswordTextfield.text)
        
    }
    
    
    
    
    
    
    
    
    //    @objc func changeTextInTextField2() {
    //        if oldPasswordTextfield.text?.count != 0 && newPasswordTextfield.text?.count != 0
    //        {
    //            if self.confirmPasswordTextfield.text?.count == 6 {
    //
    //                self.confirmPasswordTextfield.resignFirstResponder()
    //
    //                if isValidPassword() == true
    //                        {
    ////
    //                    buttonContinue.isUserInteractionEnabled = true
    //                    let img = UIImage(named: "]greenarrow")
    //                    imgNextArrow.image = img
    //
    //                }
    //                   else
    //                        {
    ////                       labelPasswordlength.textColor = UIColor(hexValue: 0xFF3932)
    //                       buttonContinue.isUserInteractionEnabled = false
    //                       let img = UIImage(named: "grayArrow")
    //                       imgNextArrow.image = img
    //
    //
    //                   }
    //                self.confirmPasswordTextfield.resignFirstResponder()
    //
    //            }
    //        }
    //        print(self.confirmPasswordTextfield.text)
    //    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if oldPasswordTextfield.text?.count == 6
        {
            
            newPasswordTextfield.isUserInteractionEnabled = true
            
        }
        if newPasswordTextfield.text?.count == 6
        {
            
            confirmPasswordTextfield.isUserInteractionEnabled = true
            
        }
        
        
        if self.newPasswordTextfield.text?.count == 6  && oldPasswordTextfield.text?.count == 6
        {
            if textField ==  newPasswordTextfield {
                confirmPasswordTextfield .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
            } else if textField == confirmPasswordTextfield {
                textField.resignFirstResponder()
                if isValidPassword() == true{
                    
                    
                    if newPasswordTextfield?.text?.count == 6
                    {
                        if isValidPassword() == true{
                            lbl1.textColor = UIColor(hexValue : 0x00CC96)
                            lbl1.textColor = UIColor(hexValue: 0x00CC96)
                            lbl2.textColor = UIColor(hexValue: 0x00CC96)
                            lbl3.textColor = UIColor(hexValue: 0x00CC96)
                        }
                        
                    }
                    else{
                        lbl1.textColor = UIColor(hexValue: 0xFF3932)
                        lbl2.textColor =  UIColor(hexValue: 0xFF3932)
                        lbl3.textColor =  UIColor(hexValue: 0xFF3932)
                    }
                    
                    
                    
                    if newPasswordTextfield.text == confirmPasswordTextfield.text{
                        
                        
                        lbl1.textColor = UIColor(hexValue:  0x00CC96)
                        lbl2.textColor = UIColor(hexValue: 0x00CC96)
                        lbl3.textColor = UIColor(hexValue: 0x00CC96)
                        lbl4.textColor = UIColor(hexValue: 0x00CC96)
                        buttonContinue.isUserInteractionEnabled = true
                        let img = UIImage(named: "]greenarrow")
                        imgNextArrow.image = img
                        
                        //                lbl4.textColor = UIColor.green
                    }
                    else
                    {
                        lbl4.textColor = UIColor(hexValue:  0xFF3932)
                        buttonContinue.isUserInteractionEnabled = false
                        let img = UIImage(named: "grayArrow")
                        imgNextArrow.image = img
                    }
                    if confirmPasswordTextfield?.text?.count == 0
                    {
                        lbl4.textColor = UIColor(hexValue:  0xFF3932)
                        buttonContinue.isUserInteractionEnabled = false
                        let img = UIImage(named: "grayArrow")
                        imgNextArrow.image = img
                    }
                    if newPasswordTextfield?.text?.count == 0
                    {
                        lbl1.textColor = UIColor(hexValue:  0xFF3932)
                        lbl2.textColor = UIColor(hexValue: 0xFF3932)
                        lbl3.textColor = UIColor(hexValue:  0xFF3932)
                        buttonContinue.isUserInteractionEnabled = false
                        let img = UIImage(named: "grayArrow")
                        imgNextArrow.image = img
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var oldPasswordTextfield: PasswordTextField!
    
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var newPasswordTextfield: PasswordTextField!
    @IBOutlet weak var confirmPasswordTextfield: PasswordTextField!
    @IBAction func newPasswordTextfield(_ sender: PasswordTextField) {
    }
    
    @IBAction func buttonback(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var imgNextArrow: UIImageView!
    
    @IBOutlet weak var buttonback: UIButton!
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        if newPasswordTextfield.text?.count == 0 {
            self.showAlertCustomPopup(title: "",message: "password should be Alpha Numeric",iconName: .iconError)
        }
        
        if newPasswordTextfield.text?.count == 0{
            self.showAlertCustomPopup(title: "",message: "password should be Alpha Numeric",iconName: .iconError)
        }
        if newPasswordTextfield.text != confirmPasswordTextfield.text! {
            self.showAlertCustomPopup(title: "",message: "Password and Confirm Password not match",iconName: .iconError)
            return
        }
        
        if isValidPassword() == true
        {
            movetonext()
            
        }
        
    }
    func movetonext()
    {
        
        changePassword()
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        changePassword()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength:Int = (textField.text?.count)! + string.count - range.length
        //        if textField ==  newPasswordTextfield
        //        {
        //
        //
        if textField == oldPasswordTextfield{
            return newLength <= 6
        }
        if textField == newPasswordTextfield{
            return newLength <= 6
        }
        if textField == confirmPasswordTextfield{
            return newLength <= 6
        }
        return newLength <= 6
        //        lbl1.textColor = UIColor.green
        
        if textField == self.newPasswordTextfield {
            if range.length + range.location > (textField.text?.count)! {
                return false
            }
            let newLength:Int = (textField.text?.count)! + string.count - range.length
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberRegEx  = ".*[0-9]+.*"
            let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            let numberresult = texttest1.evaluate(with: newString)
            print("\(numberresult)")
            
            if isValidPassword() == true{
                print("doneee")
            }
            
        }
        
        
    }
    func isValidPassword() -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 6 characters total
        let passwordRegx = "^(?=.*?[a-zA-Z])(?=.*?[0-9]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: confirmPasswordTextfield.text!)
    }
    
    func isAlphabaticContain() -> Bool {
        let passwordRegx = "^(?=.*?[a-zA-Z]).{0,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: confirmPasswordTextfield.text!)
    }
    
    func isNumericContain() -> Bool {
        let passwordRegx = "^(?=.*?[0-9])$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: confirmPasswordTextfield.text!)
    }
    
    // MARK: - API CALL
    
    private func changePassword() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        if (oldPasswordTextfield.text?.isEmpty)! {
            oldPasswordTextfield.text = ""
        }
        if (newPasswordTextfield.text?.isEmpty)! {
            newPasswordTextfield.text = ""
        }
        if (confirmPasswordTextfield.text?.isEmpty)! {
            confirmPasswordTextfield.text = ""
        }
        
        //        let compelteUrl = GlobalConstants.BASE_URL + "changePassword"
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/changePassword"
        
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID ?? "")","oldPass":self.oldPasswordTextfield.text! ?? "","newPass":self.confirmPasswordTextfield.text! ?? "","imei": DataManager.instance.imei! ?? "" ,"cnic" : userCnic!  ?? ""]
        
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(parameters)
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //            (response: DataResponse<GenericResponse>) in
            
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<GenericResponse>) in
            
            
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                
                if response.response?.statusCode == 200 {
                    self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
                    
                    //                self.genericObj = response.result.value
                    if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                        if let message = self.genericObj?.messages{
                            let removePessi : Bool = KeychainWrapper.standard.removeObject(forKey: "userKey")
                            print("Remover \(removePessi)")
                            let  message = "Close this window & Login agian     \(self.genericObj?.messages!)"
                            self.showAlertCustomPopup(title: "", message: message, iconName: .iconError, buttonNames: [
                                
                                ["buttonName": "LOGIN AGAIN",
                                 "buttonBackGroundColor": UIColor.clrOrange,
                                 "buttonTextColor": UIColor.white]
                                
                                
                            ]
                                                      //                     add completion button here....
                                                      as? [[String: AnyObject]]){ _ in
                                self.logoutUser()
                            }
                            
                        }
                    }
                    else {
                        if let message = self.genericObj?.messages{
                            self.showAlertCustomPopup(title: "",message: message,iconName: .iconError)
                        }
                    }
                }
                else {
                    if let message = self.genericObj?.messages{
                        self.showAlertCustomPopup(title: "",message: message,iconName: .iconError)
                    }
                }
            }
        }
    }
}


extension String {
    var isAlphabaticContain: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    var isNumericContain: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }
    var isAlphaNumericContain: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
