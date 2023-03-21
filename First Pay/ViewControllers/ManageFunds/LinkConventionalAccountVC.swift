//
//  LinkConventionalAccountVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 23/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper


class LinkConventionalAccountVC: BaseClassVC , UITextFieldDelegate{
    
    var cbsAccountsObj : GetCBSAccounts?
    var genResObj : GenericResponse?
    var filteredAccounts = [CbsData]()
    var arrAccountList : [String] = []
    var accountList = [CbsData]()
    @IBOutlet weak var cnicNumberTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    var accountNumberSelected : String?
    
    var accountTitle : String?
    var accountNumber : String?
    var branchCode : String?
    var branchName : String?
    var accountType: String?
    var accountTypeId: String?
    
    @IBOutlet var dropDownAccounts: UIDropDown!
    //    static let networkManager = NetworkManager()
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblEMobile: UILabel!
    @IBOutlet weak var lblEnterCNIC: UILabel!
    @IBOutlet weak var lblSeelctaccount: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        COnvertLanguage()
        
        self.getCbsAccounts()
        
        // Do any additional setup after loading the view.
    }
    
    func COnvertLanguage()
    {
        lblMainTitle.text = "LINK ACCOUNT".addLocalizableString(languageCode: languageCode)
        lblSeelctaccount.text = "Select Account".addLocalizableString(languageCode: languageCode)
        lblEnterCNIC.text = "Enter Your CNIC Number".addLocalizableString(languageCode: languageCode)
        lblEMobile.text = "Enter Your Mobile Number".addLocalizableString(languageCode: languageCode)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnSubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        cnicNumberTextField.placeholder  = "Enter Your CNIC Number".addLocalizableString(languageCode: languageCode)
        mobileNumberTextField.text = "Enter Your Mobile Number".addLocalizableString(languageCode: languageCode)
    }
    // MARK: - MethodDropDown Accounts
    
    private func methodDropDownAccounts(Accounts:[String]) {
        
//        self.dropDownAccounts.placeholder = Acc.nunts[0]
        self.dropDownAccounts.placeholder = "Select Account"
        self.dropDownAccounts.tableHeight = 150.0
        self.dropDownAccounts.rowBackgroundColor = #colorLiteral(red: 0.4700977206, green: 0.5852692723, blue: 0.7767686844, alpha: 1)
        self.dropDownAccounts.textColor = #colorLiteral(red: 0.1286819577, green: 0.3171259165, blue: 0.6042343378, alpha: 1)
        self.dropDownAccounts.optionsTextColor =  #colorLiteral(red: 0.1286819577, green: 0.3171259165, blue: 0.6042343378, alpha: 1)
        self.dropDownAccounts.options = Accounts
        self.dropDownAccounts.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.accountNumberSelected = option
            
            let title = self.accountNumberSelected
            for aAccount in self.accountList {
                if aAccount.cbsAccountNo == title {
                    
                    self.accountTitle = aAccount.cbsAccountTitle
                    self.accountNumber = aAccount.cbsAccountNo
                    self.branchCode = aAccount.branchCode
                    self.branchName = aAccount.branchName
                    self.accountType = aAccount.cbsAccountType
                    self.accountTypeId = "\(aAccount.accountCbsLinkId)"
                    
                    print(self.accountTitle)
                    print(self.accountNumber)
                    print(self.branchCode)
                    print(self.branchName)
                    print(self.accountType)
                    print(self.accountTypeId)
                    
                }
            }
        })
    }
    
    // MARK: - Utility Method
    
    private func navigateToConfirmation(){
        
        let linkConvenConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "LinkConventionalAccountConfirmationVC") as! LinkConventionalAccountConfirmationVC
        
        linkConvenConfirmVC.accountTitle = self.accountTitle
        linkConvenConfirmVC.accountNumber = self.accountNumber
        linkConvenConfirmVC.branchCode = self.branchCode
        linkConvenConfirmVC.branchName = self.branchName
        linkConvenConfirmVC.accountType = self.accountType
        linkConvenConfirmVC.userCnic = self.cnicNumberTextField.text
        linkConvenConfirmVC.userMobNo = self.mobileNumberTextField.text
        linkConvenConfirmVC.accountTypeId = self.accountTypeId
        //linkConvenConfirmVC.otpReq = self.otpReq
        
        self.navigationController!.pushViewController(linkConvenConfirmVC, animated: true)
    }
    
    // MARK: - UITextfield Delegate Methods
       
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
           let newLength = (textField.text?.count)! + string.count - range.length
           
           if textField == cnicNumberTextField{
               return newLength <= 13
           }
           if textField == mobileNumberTextField{
               return newLength <= 11
           }
           else {
               return newLength <= 16
           }
       }
       
       
//       func textFieldDidEndEditing(_ textField: UITextField) {
//           
//           if textField == cnicNumberTextField {
//               cnicNumberTextField .perform(#selector(becomeFirstResponder),with:nil, afterDelay:0.1)
//           } else if textField == mobileNumberTextField {
//               textField.resignFirstResponder()
//           }
//       }
    
    
    // MARK: - Action Method
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    @IBAction func submitPressed(_ sender: Any) {
        
        if cnicNumberTextField.text?.count == 0 {
            self.showToast(title: "Please enter CNIC")
            return
        }
        if mobileNumberTextField.text?.count == 0 {
            self.showToast(title: "Please enter Mobile Number")
            return
        }
        
        self.initiateLinkAccount()
    }
    
    
    
    // MARK: - API CALL
    
    private func getCbsAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        showActivityIndicator()
        
        // HardCode
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "getCbsAccount"
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","lng":"\(DataManager.instance.Longitude!)","imeiNo":DataManager.instance.imei!,"cnicNo":userCnic!,"lat":"\(DataManager.instance.Latitude!)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetCBSAccounts>) in
            
            
            self.hideActivityIndicator()
            
            self.cbsAccountsObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.cbsAccountsObj?.responsecode == 2 || self.cbsAccountsObj?.responsecode == 1 {
                    
                    if let account = self.cbsAccountsObj?.accdata{
                        self.accountList = account
                    }
                    for aAccount in self.accountList {
                        self.arrAccountList.append(aAccount.cbsAccountNo ?? "")
                    }
                    self.methodDropDownAccounts(Accounts: self.arrAccountList)
                    
                    
                }
                else {
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
//
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    
    private func initiateLinkAccount() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "initiateAddLinkAccount"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","lng":"\(DataManager.instance.Longitude!)","imeiNo":DataManager.instance.imei!,"cnicNo":self.cnicNumberTextField.text!,"lat":"\(DataManager.instance.Latitude!)","mobileNo":mobileNumberTextField.text!,"accountNo":self.accountNumberSelected!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.genResObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    self.navigateToConfirmation()
                }
                else {
                    
                    if let messsage = self.genResObj?.messages{
                        self.showDefaultAlert(title: "Error", message: messsage)
                    }
                    
                    }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    
}

