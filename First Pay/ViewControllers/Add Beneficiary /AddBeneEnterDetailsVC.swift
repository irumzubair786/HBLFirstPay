//
//  AddBeneEnterDetailsVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 25/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class AddBeneEnterDetailsVC: BaseClassVC , UITextFieldDelegate {
    
    static let networkManager = NetworkManager()
    @IBOutlet var dropDownBankNames: UIDropDown!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var lblbeneDesc: UILabel!
    
    
    @IBOutlet weak var lblmain: UILabel!
    
    
    @IBOutlet weak var btncal: UIButton!
    @IBOutlet weak var btnsub: UIButton!
    @IBOutlet weak var lblBAcNo: UILabel!
    @IBOutlet weak var lblBeneficairybank: UILabel!
    func convertLanguage()
    {
        lblmain.text = "Add Beneficiary".addLocalizableString(languageCode: languageCode)
        lblBeneficairybank.text = "Beneficiary Bank Name".addLocalizableString(languageCode: languageCode)
        lblBAcNo.text = "Beneficiary Account Number".addLocalizableString(languageCode: languageCode)
        accountNumberTextField.placeholder = "Enter 16 digit Account number".addLocalizableString(languageCode: languageCode)
        btnsub.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        btncal.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        
    }
    var arrBanksList : [String]?
    var getBeneObj : GetBeneficiaryTitleModel?
    var banksObj:GetBankNames?
    var banksList = [SingleBank]()
    var genericResponse:GenericResponse?
    var arrIbftBene = [SingleBeneficiary]()
    var sourceBank:String?
    var accountImd : String?
    var accountImdId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        convertLanguage()
        self.getBankNames()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    private func updateUI(){
        let title = self.sourceBank
        for aBank in self.banksList {
            if aBank.bankName == title {
                
                if let bankDescription = aBank.descr{
                    let str = bankDescription
                    let replaced = str.replacingOccurrences(of: "_", with: "\n")
                    self.lblbeneDesc.text = replaced
                }
                
                if let bankForamt = aBank.format {
                    if bankForamt.contains("_"){
                        let replaced = bankForamt.replacingOccurrences(of: "_", with: " or ")
                        self.accountNumberTextField.placeholder = "Please enter \(replaced) digit Account Number"
                    }
                    else {
                                                self.accountNumberTextField.placeholder = "Please enter \(bankForamt) digit Account Number"
                    }
                }
            }
        }
    }

    
    
    //MARK: - DropDown
    
    private func methodDropDownBanks(Banks:[String]) {
   
        self.dropDownBankNames.placeholder = "Select Bank"
        self.dropDownBankNames.tableHeight = 250.0
        self.dropDownBankNames.options = Banks
        self.dropDownBankNames.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.dropDownBankNames.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.sourceBank = option
            
            let title = self.sourceBank
            for aBank in self.banksList {
                if aBank.bankName == title {
                    self.accountImd = aBank.imdNo
                    self.accountImdId = "\(aBank.imdListId ?? 0)"
                    self.updateUI()
                   // self.accountNumberTextField.placeholder = aBank.descr
                }
            }
        })
    }
    
    //MARK: - UITextField Delegate Methods
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn  range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == accountNumberTextField {
            
            return newLength <= 20 // Bool
        }
        else {
            
            return newLength <= 10
        }
    }
    
    
    // MARK: - Utility Method
    
    private func navigateToConfirmation(){
        
        let addBeneConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "AddBeneConfirmationVC") as! AddBeneConfirmationVC
        addBeneConfirmVC.accountTitle = self.getBeneObj?.accountTitle
        addBeneConfirmVC.accountNumber = self.getBeneObj?.accountNo
        addBeneConfirmVC.bankName = self.sourceBank
        addBeneConfirmVC.accountIMD = self.accountImd
        addBeneConfirmVC.iban = self.getBeneObj?.iban
        addBeneConfirmVC.otpReq = self.getBeneObj?.OTPREQ
        addBeneConfirmVC.accountImdId = self.accountImdId
        
        //        if isFromHome == true{
        //            ibftFundConfirmVC.isFromHome = true
        //        }
        //        else{
        //            ibftFundConfirmVC.isFromHome = false
        //        }
        
        let title = self.sourceBank
        for aBank in self.banksList {
            if aBank.bankName == title {
                addBeneConfirmVC.singleBank = aBank
            }
        }
        
        
        self.navigationController!.pushViewController(addBeneConfirmVC, animated: true)
    }
    
    // MARK: - Action Method
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    @IBAction func submitPressed(_ sender: Any) {
        
        if (accountNumberTextField.text?.count)! < 6 {
            self.showDefaultAlert(title: "", message: "Please enter valid account number")
            return
        }
        if accountImd == nil{
            self.showDefaultAlert(title: "", message: "Please Select Bank")
            return
        }
        if accountNumberTextField.text?.count == 0 {
            self.showDefaultAlert(title: "", message: "Please enter valid account number")
            return
        }
        
        
                for aBene in (arrIbftBene){
                    
                    let title = self.sourceBank
                    for aBank in self.banksList {
                        if aBank.bankName == title {
                            if aBank.imdNo == aBene.beneficiaryImd && aBene.beneficiaryAccountNo == self.accountNumberTextField.text {
                                self.showToast(title: "Already Exists")
                                return
                            }
                    }
                    }
                }

        
        self.getBeneDetails()
        
        //  self.navigateToConfirmation()
    }
    
    // MARK: - API CALL
    
    private func getBankNames() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getAllImdList"
        let header = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetBankNames>) in
            
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.banksObj = response.result.value
                if self.banksObj?.responsecode == 2 || self.banksObj?.responsecode == 1 {
                    if let banks = self.banksObj?.singleBank{
                        self.banksList = banks
                    }
                    self.arrBanksList = self.banksObj?.stringBanks
                    self.methodDropDownBanks(Banks: self.arrBanksList!)
                    
                }
                else {
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
//
            }
        }
    }
    
    private func getBeneDetails() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "getBeneficiaryTitle"
        
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","imei":DataManager.instance.imei!,"cnic":userCnic!,"accountNo":self.accountNumberTextField.text!,"accountIMD":self.accountImd!,"amount":"1","transPurpose":"0122","channelId":"\(DataManager.instance.channelID)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetBeneficiaryTitleModel>) in
            
            
            
            self.hideActivityIndicator()
            
            self.getBeneObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.getBeneObj?.responsecode == 2 || self.getBeneObj?.responsecode == 1 {
                    self.navigateToConfirmation()
                }
                else {
                    if let message = self.getBeneObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.getBeneObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
}
