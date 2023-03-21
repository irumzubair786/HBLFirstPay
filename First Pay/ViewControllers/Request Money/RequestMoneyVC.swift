//
//  RequestMoneyVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 16/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS

class RequestMoneyVC: BaseClassVC,UITextFieldDelegate {
    
    @IBOutlet weak var walletNoTextField: UITextField!
     @IBOutlet weak var amountNoTextField: UITextField!
     @IBOutlet weak var commentsTextField: UITextField!
    @IBOutlet weak var lblAccountTitleName: UILabel!
    var titleFetchObj : TitleFetchModel?
    var genResponseObj : GenericResponse?
   
     @IBOutlet weak var btnSubmitOutlet: UIButton!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var lblAccountTitle: UILabel!
    @IBOutlet weak var lblmainTitlwe: UILabel!
    private let contactPicker = CNContactPickerViewController()
    @IBOutlet weak var lblAccount: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var lblEnterwalletNo: UILabel!
    
    @IBOutlet weak var btnSubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        walletNoTextField.delegate = self
        ChangeLangugae()
        // Do any additional setup after loading the view.
        self.setHidden()
        
      
    }
    func ChangeLangugae()
    {
       
        lblmainTitlwe.text = "Request Money".addLocalizableString(languageCode: languageCode)
        lblEnterwalletNo.text = "Enter Wallet No".addLocalizableString(languageCode: languageCode)
        walletNoTextField.placeholder = "Enter Wallet Number".addLocalizableString(languageCode: languageCode)
        btnVerify.setTitle("Verify".addLocalizableString(languageCode: languageCode), for: .normal)
        lblAccount.text = "Account".addLocalizableString(languageCode: languageCode)
        lblAccountTitle.text = "Account Title".addLocalizableString(languageCode: languageCode)
        amountNoTextField.placeholder = "Amount".addLocalizableString(languageCode: languageCode)
        lblComments.text = "Comments".addLocalizableString(languageCode: languageCode)
        commentsTextField.placeholder = "Comments".addLocalizableString(languageCode: languageCode)
        btnSubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        
       
        
        
        
        
    }
    
    func setHidden(){
        
     //   self.lblAmount.isHidden = true
        self.amountNoTextField.isHidden = true
    //    self.lblComments.isHidden = true
        self.commentsTextField.isHidden = true
        self.lblAccountTitle.isHidden = true
        self.lblAccountTitleName.isHidden = true
        self.btnSubmitOutlet.isUserInteractionEnabled = false
        self.btnVerify.titleLabel?.text = "Verify".addLocalizableString(languageCode: languageCode)
        
    }
    func setUnHidden(){
        
    //    self.lblAmount.isHidden = false
        self.amountNoTextField.isHidden = false
    //    self.lblComments.isHidden = false
        self.commentsTextField.isHidden = false
        self.lblAccountTitle.isHidden = false
        self.lblAccountTitleName.isHidden = false
        self.btnSubmitOutlet.isUserInteractionEnabled = true
        self.lblAccountTitleName.text = self.titleFetchObj?.accountTitle
        self.btnVerify.titleLabel?.text = "Verified"
        self.btnVerify.isUserInteractionEnabled = false
        
    }
    
    
    // MARK: - Actions Method
    
    @IBAction func submitPressed(_ sender: Any) {
        
        if amountNoTextField.text?.count == 0 {
            self.showDefaultAlert(title: "", message: "Please enter amount")
            return
        }
        if commentsTextField.text?.count == 0 {
            self.showDefaultAlert(title: "", message: "Please enter comments")
            return
        }
        let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Proceed".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            
            self.requestMoney()
            self.dismiss(animated: true, completion:nil)
        }))
        
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            
            self.dismiss(animated: true, completion:nil)
        }))
        
        present(consentAlert, animated: true, completion: nil)
        
       
    }
    
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           print(textField)
          
           if (textField == walletNoTextField)
           {
               print(textField)
               let maxLength = 11
               let currentString: NSString = textField.text! as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               return newString.length <= maxLength
           }
           
           return true
       }
    @IBAction func verifyPressed(_ sender: Any) {
        
           if walletNoTextField.text?.count == 0 {
            self.showDefaultAlert(title: "", message: "Please enter wallet number")
            return
        }
        if walletNoTextField.text == DataManager.instance.accountNo{
            self.showDefaultAlert(title: "", message: "Self request is not allowed")
            return
        }
        
        self.requestMoneyTitleFetch()
    }
    
    @IBAction func getContactsPressed(_ sender: Any) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    

  // MARK: - API call
    
    public func requestMoneyTitleFetch(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
               
               if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
                   userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
               }
               else{
                   userCnic = ""
               }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "requestMoneyTitleFetch"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"mobileNo":self.walletNoTextField.text!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<TitleFetchModel>) in
            
            self.hideActivityIndicator()
            
            self.titleFetchObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.titleFetchObj?.responsecode == 2 || self.titleFetchObj?.responsecode == 1 {
                    self.setUnHidden()
                }
                else {
                    if let message = self.titleFetchObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.titleFetchObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
       
    public func requestMoney(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "requestMoney"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"accountNo":self.titleFetchObj?.accountNo!,"amount":self.amountNoTextField.text!,"comments":self.commentsTextField.text!,"accountType":DataManager.instance.accountType!]
        
        print(parameters)
        
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
            
            self.hideActivityIndicator()
            
            self.genResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
                    if let message = self.genResponseObj?.messages{
                        self.showAlert(title: "Success", message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
                else {
                    if let message = self.genResponseObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genResponseObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }

}


extension RequestMoneyVC: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count

        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }

        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)

        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)

            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            alert -> Void in

            })
            alertController.addAction(cancelAction)

            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func setNumberFromContact(contactNumber: String) {

        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER

        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        

        
        let phoneUtil = NBPhoneNumberUtil()

          do {
            
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(contactNumber, defaultRegion: "PK")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .NATIONAL)

            print("Formatted String : \(formattedString)")
            self.walletNoTextField.text = replaceSpaceWithEmptyString(aStr: formattedString)
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
   
}
