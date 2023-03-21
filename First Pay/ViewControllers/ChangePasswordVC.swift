//
//  ChangePasswordVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 13/05/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import AlamofireObjectMapper
import PasswordTextField


class ChangePasswordVC: BaseClassVC , UITextFieldDelegate {
    
    @IBOutlet weak var enterOldPassTextField: PasswordTextField!
    @IBOutlet weak var enterPassTextField: PasswordTextField!
    @IBOutlet weak var enterConfirmPassTextField: PasswordTextField!

    @IBOutlet weak var alphanumericlbl: UILabel!
    @IBOutlet weak var lblalpha: UILabel!
    @IBOutlet var btn_6characters: UIButton!
    @IBOutlet var btn_ChangePass: UIButton!
    
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!
    @IBOutlet weak var lblInviteFriend: UILabel!
    
    
    var genericObj:GenericResponse?
    var flag = false
   
    var callSubmit:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
       ChangelanguageCode()
        enterPassTextField.delegate = self
        enterConfirmPassTextField.delegate = self
        self.btn_ChangePass.isEnabled = false
        alphanumericlbl.isHidden = true
        
        
        self.dismissKeyboard()
       
    }
    
    
    
    
    func ChangelanguageCode()
    {
      
      
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        btnChangePassword.setTitle("Change Password".addLocalizableString(languageCode: languageCode), for: .normal)
        enterOldPassTextField.placeholder = "Enter Old password".addLocalizableString(languageCode: languageCode)
        
        lblalpha.text = "Password should be Alpha Numeric".addLocalizableString(languageCode: languageCode)
//        lblPassword6Character.text = "Password should be Alpha Numeric".addLocalizableString(languageCode: languageCode)
        lblPassword6Character.text = "Password should be 6 characters (alpha numeric)".addLocalizableString(languageCode: languageCode)
        enterPassTextField.placeholder = "Enter New password".addLocalizableString(languageCode: languageCode)
        enterConfirmPassTextField.placeholder = "Confirm New Password".addLocalizableString(languageCode: languageCode)
        lblchangepassword.text = "Change Password".addLocalizableString(languageCode: languageCode)
  
//             
        
        
    }
    
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var lblchangepassword: UILabel!
    @IBOutlet weak var lblPassword6Character: UILabel!
    @IBOutlet weak var lblPsswordShouldbe2: UILabel!
    @IBOutlet weak var lblPasswordshould: UILabel!
    
    
    @IBAction func okaction(_ sender: UIButton) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if enterOldPassTextField == textField {
            return true
        }
        if textField == self.enterPassTextField {
            if range.length + range.location > (textField.text?.count)! {
                return false
            }
        }
        if let pessi = KeychainWrapper.standard.string(forKey: "userKey"){
            if enterOldPassTextField.text != pessi{
                UtilManager.showAlertMessage(message:  "Enter valid old password", viewController: self)
                
            }
        }
         if (isValidPassword(textfield: enterPassTextField, lastString: "") && isValidPassword(textfield: enterConfirmPassTextField, lastString: "")) == true  {
            callSubmit = true
            btn_ChangePass.isEnabled = true
            btn_6characters.setImage(UIImage(named: "checkbox_state2"), for: .normal)
          //  self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)excel
       
        }
//     if (isValidPassword(textfield: enterPassTextField, lastString: "") && isValidPassword(textfield: enterConfirmPassTextField, lastString: "")) == false
//        {
//            callSubmit = false
//            btn_ChangePass.isEnabled = false
//            btn_6characters.setImage(UIImage(named: "checkbox_state1"), for: .normal)
//            lblalpha.textColor = .red
//            self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
//        }
////            }
        else{
            callSubmit = false
            btn_ChangePass.isEnabled = false
            btn_6characters.setImage(UIImage(named: "checkbox_state1"), for: .normal)
            lblalpha.textColor = .red
            self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        }
        
        
        let newLength:Int = (textField.text?.count)! + string.count - range.length
        
        if textField == enterPassTextField{
            return newLength <= 6
        }
        if textField == enterConfirmPassTextField{
            return newLength <= 6
        }
        return newLength <= 6

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == enterPassTextField {
            enterConfirmPassTextField .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
        } else if textField == enterConfirmPassTextField {
            textField.resignFirstResponder()
            if (isValidPassword(textfield: enterPassTextField, lastString: "") && isValidPassword(textfield: enterConfirmPassTextField, lastString: "")) == true{
                callSubmit = true
                btn_ChangePass.isEnabled = true
                lblalpha.textColor = UIColor.green
                self.btn_6characters.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
                
            }
        }
    }
   
    
    
    
    func isValidPassword(textfield: UITextField, lastString: String) -> Bool {
    
        let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: textfield.text!+lastString)
    }
    
    // MARK: - Action Methods
    
    @IBAction func ChangePassButtonPressed(_ sender: Any) {
        
        if let pessi = KeychainWrapper.standard.string(forKey: "userKey"){
            if enterOldPassTextField.text != pessi{
                UtilManager.showAlertMessage(message:  "Enter valid old password", viewController: self)
                return
            }
        }
     
       
        if enterPassTextField.text?.count == 0 {
            return
        }
        else if (enterPassTextField.text?.count != 0)
         {
            
         }
        if enterConfirmPassTextField.text?.count == 0{
            return
        }
        if enterPassTextField.text! != enterConfirmPassTextField.text!
        {
            UtilManager.showAlertMessage(message:"Password and Confirm Password not match" , viewController: self)
            
        }
       else  if enterPassTextField.text == enterConfirmPassTextField.text{
            self.changePassword()
        }
        
        if isValidPassword(textfield: enterPassTextField, lastString: "") && isValidPassword(textfield: enterConfirmPassTextField, lastString: "") == true
        {
//            self.changePassword()
        }
        
      
        else{
            UtilManager.showAlertMessage(message: "Password should be Alpha Numeric", viewController: self)
        }
        
    }
//    
    // MARK: - API CALL
    
    private func changePassword() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        if (enterPassTextField.text?.isEmpty)! {
            enterPassTextField.text = ""
        }
        if (enterConfirmPassTextField.text?.isEmpty)! {
            enterConfirmPassTextField.text = ""
        }
        
//        let compelteUrl = GlobalConstants.BASE_URL + "changePassword"
        let compelteUrl = GlobalConstants.BASE_URL + "v2/changePassword"
        
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","oldpass":self.enterOldPassTextField.text!,"newpass":self.enterPassTextField.text!]
        
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
            
    
//        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
        
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.genericObj = response.result.value
                if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                    if let message = self.genericObj?.messages{
                        let removePessi : Bool = KeychainWrapper.standard.removeObject(forKey: "userKey")
                        print("Remover \(removePessi)")
                        self.showAlert(title: "", message: message, completion: {
//                            self.navigationController?.popToRootViewController(animated: true)
                            self.logoutUser()
                        })
                    }
                }
                else {
                    if let message = self.genericObj?.messages{
                        self.showAlert(title: "", message: message, completion:nil)
                    }
                }
            }
            else {
//
            }
        }
    }
    
  

    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func invitefriend(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func golootlo(_ sender: UIButton) {
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactus(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func tickets(_ sender: UIButton) {
       let  vc = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
       self.navigationController!.pushViewController(vc, animated: true)
        
    }
}




