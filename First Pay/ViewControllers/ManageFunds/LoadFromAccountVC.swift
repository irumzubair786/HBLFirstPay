//
//  LoadFromAccountVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 23/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class LoadFromAccountVC: BaseClassVC {
    
    var accountNumber : String?
    var cbsAccountsObj : GetCBSAccounts?
    var accountList = [CbsData]()
    var accountNumberSelected : String?
    var arrAccountList : [String] = []
    @IBOutlet var dropDownAccounts: UIDropDown!
    @IBOutlet weak var amountTextField: UITextField!
    var genResObj : GenericResponse?
    var accountTitle : String?
    @IBOutlet weak var lblMainTitle: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblEnterAccount: UILabel!
    @IBOutlet weak var lblSelectAccount: UILabel!
    
      @IBOutlet weak var lblhome: UILabel!
       @IBOutlet weak var lblContactus: UILabel!
       @IBOutlet weak var lblBookme: UILabel!
       @IBOutlet weak var lblInviteFriend: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        self.getCbsAccounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
           
        self.lblMainTitle.text = DataManager.instance.PushPullTitle
       }

    func ChangeLanguage()
    {
        
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        self.lblMainTitle.text = DataManager.instance.PushPullTitle?.addLocalizableString(languageCode: languageCode)
        lblSelectAccount.text = "Select Account".addLocalizableString(languageCode: languageCode)
        lblEnterAccount.text = "Enter Amount".addLocalizableString(languageCode: languageCode)
        amountTextField.placeholder = "Enter Amount".addLocalizableString(languageCode: languageCode)
        btnSubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        dropDownAccounts.placeholder = "Select Account".addLocalizableString(languageCode: languageCode)
        
    }
    
    // MARK: - MethodDropDown Accounts
    
    
    private func methodDropDownAccounts(Accounts:[String]) {
        
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
                    self.accountNumber = aAccount.cbsAccountNo
                    self.accountTitle = aAccount.cbsAccountTitle
                    
                    print(self.accountNumber)
                    print(self.accountTitle)
                }
            }
        })
    }
    
    
    // MARK: - Utility Method
    
    private func navigateToConfirmation(){
        
        let loadFromAccountConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "LoadFromAccountConfirmationVC") as! LoadFromAccountConfirmationVC
        
        loadFromAccountConfirmVC.accountTitle = self.accountTitle
        if DataManager.instance.PushPull == "PUSH"{
            loadFromAccountConfirmVC.sourceAccountNo = DataManager.instance.accountNo
            loadFromAccountConfirmVC.beneAccountNo = self.accountNumber
        }
        else {
            loadFromAccountConfirmVC.sourceAccountNo = self.accountNumber
            loadFromAccountConfirmVC.beneAccountNo = DataManager.instance.accountNo
        }
        loadFromAccountConfirmVC.accountNumber = self.accountNumber
        loadFromAccountConfirmVC.amount = self.amountTextField.text
        
        loadFromAccountConfirmVC.mainTitle = "\(DataManager.instance.PushPullTitle ?? " ") Confirmation"
        //linkConvenConfirmVC.otpReq = self.otpReq
        
        self.navigationController!.pushViewController(loadFromAccountConfirmVC, animated: true)
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
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
       self.navigationController!.pushViewController(vc, animated: true)
    }
    // MARK: - Action Methods
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        if self.accountNumberSelected == nil{
            self.showToast(title: "Kindly select Account")
            return
        }
        if amountTextField.text?.count == 0 {
            self.showToast(title: "Please enter Amount")
            return
        }
        
        self.initiatePushPullAccount()
        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    
    // MARK: - API CALL
    
    
    private func getCbsAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getLinkAccount"
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","lng":"\(DataManager.instance.Longitude!)","imeiNo":DataManager.instance.imei!,"cnicNo":userCnic!,"lat":"\(DataManager.instance.Latitude!)"]
        print(parameters)
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
               
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    private func initiatePushPullAccount() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "initiatePP"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","lng":"\(DataManager.instance.Longitude!)","imeiNo":DataManager.instance.imei!,"cnicNo":userCnic!,"lat":"\(DataManager.instance.Latitude!)","amount":amountTextField.text!,"accountNo":self.accountNumberSelected!,"type":DataManager.instance.PushPull!]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
       // print(header)
        print(compelteUrl)
       // print(params)
        
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
