//
//  DeLinkVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 23/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper


class DeLinkVC: BaseClassVC {
    
    var accountNumber : String?
    var genResObj : GenericResponse?
    var cbsAccountsObj : GetCbsModel?
    var accountList = [CBsmodeldata]()
    var accountNumberSelected : String?
    var arrAccountList : [String] = []
 
    @IBOutlet var dropDownAccounts: UIDropDown!
    
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var lbldelink: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "DeLink Account".addLocalizableString(languageCode: languageCode)
        lbldelink.text = "DeLink Account".addLocalizableString(languageCode: languageCode)
        btnsubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        dropDownAccounts.placeholder = "Select Account".addLocalizableString(languageCode: languageCode)
        self.getCbsAccounts()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - MethodDropDown Accounts
    
    private func methodDropDownAccounts(Accounts:[String]) {
        
        //        self.dropDownAccounts.placeholder = Accounts[0]
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
                if aAccount.accountNumber == title {
                    self.accountNumber = aAccount.accountNumber
//                    print(self.cbsAccountNo)
                }
            }
        })
    }
    
    // MARK: - Action Methods
    @IBAction func deLinkPressed(_ sender: Any) {
        self.deLinkAccountCall()
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    // MARK: - Utility Methods
    
    
    private func navigateToSucessScreen(message:String?){
        
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Success", style: .default, handler: { action in
            
            let manageFundVC = self.storyboard!.instantiateViewController(withIdentifier: "ManageFundsVC") as! ManageFundsVC
            self.navigationController!.pushViewController(manageFundVC, animated: true)
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - API CALL
    
    
    private func getCbsAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        showActivityIndicator()
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetCbsModel>) in
            
            self.hideActivityIndicator()
            
            self.cbsAccountsObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.cbsAccountsObj?.responsecode == 2 || self.cbsAccountsObj?.responsecode == 1 {
                    
                    if let account = self.cbsAccountsObj?.datacbs{
                        self.accountList = account
                    }
                    for aAccount in self.accountList {
                        self.arrAccountList.append(aAccount.accountNumber ?? "")
                    }
                    self.methodDropDownAccounts(Accounts: self.arrAccountList)
                }
                else {
//                     self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    private func deLinkAccountCall() {
        
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        var userCnic : String?
        
        showActivityIndicator()
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "deLinkAccount"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","lng":"\(DataManager.instance.Longitude!)","imeiNo":DataManager.instance.imei!,"cnicNo":userCnic!,"lat":"\(DataManager.instance.Latitude!)","accountNo":self.accountNumber!]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.genResObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    
                    // success
                    
                    if let message = self.genResObj?.messages{
                        self.navigateToSucessScreen(message: message)
                    }
                    
                    
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
