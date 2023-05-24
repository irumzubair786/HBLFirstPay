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
import AlamofireObjectMapper
import SwiftKeychainWrapper
class ChangepasswordVC: BaseClassVC, UITextFieldDelegate {
    var genericObj:GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonback.setTitle("", for: .normal)
        oldPasswordTextfield.delegate = self
        newPasswordTextfield.delegate = self
        confirmPasswordTextfield.delegate = self
        buttonContinue.isUserInteractionEnabled = false
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imgNextArrow.isUserInteractionEnabled = true
        imgNextArrow.addGestureRecognizer(tapGestureRecognizerr)
        // Do any additional setup after loading the view.
        self.confirmPasswordTextfield.addTarget(self, action: #selector(changeTextInTextField2), for: .editingDidEnd)

    }
    @objc func changeTextInTextField2() {
        if oldPasswordTextfield.text?.count != 0 && newPasswordTextfield.text?.count != 0
        {
            if self.confirmPasswordTextfield.text?.count == 6 {

                if isValidPassword() == true
                        {
                    labelPasswordlength.textColor = UIColor(hexValue : 0x00CC96)
                    buttonContinue.isUserInteractionEnabled = true
                    let img = UIImage(named: "]greenarrow")
                    imgNextArrow.image = img
                    
                }
                   else
                        {
                       labelPasswordlength.textColor = UIColor(hexValue: 0xFF3932)
                       buttonContinue.isUserInteractionEnabled = false
                       let img = UIImage(named: "grayArrow")
                       imgNextArrow.image = img
                       
                       
                   }
                self.confirmPasswordTextfield.resignFirstResponder()
                
            }
        }
        print(self.confirmPasswordTextfield.text)
    }
    @IBOutlet weak var oldPasswordTextfield: PasswordTextField!
    
    @IBOutlet weak var labelPasswordlength: UILabel!
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
        if textField ==  newPasswordTextfield
        {
            if newPasswordTextfield.text?.count ?? 0 < 6
            {
                
                labelPasswordlength.textColor = UIColor(hexValue: 0xFF3932)
               
                if isValidPassword() == true
                    
                {
                    print("test", newPasswordTextfield.text)
                    print("test2", confirmPasswordTextfield.text)
                }
                else{
//                        lbl1.textColor = UIColor(red: -0/255.0, green: 204/255.0, blue: 150/255.0, alpha: 1.0)
                }
//
            if isValidPassword() == true
                    {
                labelPasswordlength.textColor = UIColor(hexValue : 0x00CC96)
                
            }
               else
                    {
                   labelPasswordlength.textColor = UIColor(hexValue: 0xFF3932)
                   
                   
               }
                    
                   
                
                
                }
                
            }

        
        
        
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
          
            else{

                print("not done")
                if newPasswordTextfield.text == confirmPasswordTextfield.text{
//
//                    lbl4.textColor = UIColor.green
            }
            else
            {
                
//                    lbl4.textColor = UIColor.red
//
            }
                
            }
           
            if  numberresult == true /*&& newString.count == 6*/{
//                callSubmit = true
               
//
            }
            else {
//                callSubmit = false
//
            }
            
        }
        
        let newLength:Int = (textField.text?.count)! + string.count - range.length
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
        
  }
    func isValidPassword() -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 6 characters total
        let passwordRegx = "^(?=.*?[a-z])(?=.*?[0-9]).{6,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: newPasswordTextfield.text!)
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
        let parameters = ["channelId":"\(DataManager.instance.channelID ?? "")","oldpass":self.oldPasswordTextfield.text! ?? "","newpass":self.confirmPasswordTextfield.text! ?? "","imei": DataManager.instance.imei! ?? "" ,"cnic" : userCnic!  ?? ""]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(parameters)
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
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
                        self.showAlertCustomPopup(title: "", message: message)
                        self.logoutUser()
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
