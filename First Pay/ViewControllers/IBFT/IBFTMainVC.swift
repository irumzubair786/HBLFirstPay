    //
    //  IBFTMainVC.swift
    //  First Wallet
    //
    //  Created by Syed Uzair Ahmed on 26/10/2019.
    //  Copyright © 2019 FMFB Pakistan. All rights reserved.
    //
    
    import UIKit
    import Alamofire
    import AlamofireObjectMapper
    import SwiftKeychainWrapper
   var isFromDonations:Bool = false
    
    class IBFTMainVC: BaseClassVC {
        
        @IBOutlet weak var beneAccountNumberTextField: UITextField!
        @IBOutlet weak var amountTextField: UITextField!
        @IBOutlet weak var sourceAccountTextField: UITextField!
        @IBOutlet var dropDownReasons: UIDropDown!
        var sourceReasonCodeForTrans: String?
        var sourceReasonTitleForTrans : String?
        @IBOutlet var dropDownBankNames: UIDropDown!
        var banksObj:GetBankNames?
        var banksList = [SingleBank]()
        var sourceBank:String?
        var accountImd : String?
        var varBeneAccountNum:String?
        var transactionApiResponseObj : FTApiResponse?
      
        var reasonsObj : GetReasonsModel?
        var reasonsList = [ReasonsData]()
        var arrReasonsList : [String]?
        var accounttipe : String?
        var responseobj : TransactionResponse?
        var mainTitle  = ""
        @IBOutlet weak var MainTitle: UILabel!
        
        @IBOutlet weak var lblSourceAcc: UILabel!
        
        @IBOutlet weak var lblTransferAccount: UILabel!
        @IBOutlet weak var lblBeneifiaryAccount: UILabel!
        
        @IBOutlet weak var btnCancel: UIButton!
        @IBOutlet weak var btnSubmit: UIButton!
        @IBOutlet weak var lblPurposeofPayment: UILabel!
        @IBOutlet weak var lblBeneficiaryBankName: UILabel!
         
        
        
        func ChangeLanguage()
        {
            
            lblSourceAcc.text = "Source Account".addLocalizableString(languageCode: languageCode)
            lblBeneficiaryBankName.text = "Beneficiary Bank Name".addLocalizableString(languageCode: languageCode)
            lblBeneifiaryAccount.text = "Beneficiary Account".addLocalizableString(languageCode: languageCode)
            beneAccountNumberTextField.placeholder = "Enter 11 digits mobile number".addLocalizableString(languageCode: languageCode)
            lblTransferAccount.text = "Transfer Amount".addLocalizableString(languageCode: languageCode)
            amountTextField.placeholder = "Enter Amount".addLocalizableString(languageCode: languageCode)
            lblPurposeofPayment.text = "Purpose of Payment".addLocalizableString(languageCode: languageCode)
            btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
            btnSubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
            txtfieldaccounttype.placeholder = "Enter".addLocalizableString(languageCode: languageCode)
//            MainTitle.text = "IBFT".addLocalizableString(languageCode: languageCode)
            
        }
        
        
        
        
        
        @IBOutlet weak var txtfieldaccounttype: UITextField!
        override func viewDidLoad() {
            super.viewDidLoad()
            
            txtfieldaccounttype.isHidden = true
            ChangeLanguage()
            self.updateUI()
            self.getBankNames()
            
        }
        
        private func updateUI(){
            
            self.methodDropDownBanks(Banks:[self.sourceBank!])
            self.beneAccountNumberTextField.text = self.varBeneAccountNum
            self.beneAccountNumberTextField.isUserInteractionEnabled = false
//         
            //    methodDropDownReasons(Reasons: reasonsArr)
            self.sourceAccountTextField.text = DataManager.instance.accountNo
            self.sourceAccountTextField.isUserInteractionEnabled = false

//            self.txtfieldaccounttype.text = DataManager.instance.accountType
//            print(DataManager.instance.accountType)
            if isFromDonations == true{
                MainTitle.text = mainTitle
            }
            else
            {
                MainTitle.text = "IBFT".addLocalizableString(languageCode: languageCode)
            }
        }
        
        
        // MARK: - MethodDropDown Reasons
        
        private func methodDropDownReasons(Reasons:[String]) {
            
            if isFromDonations == true{
            self.dropDownReasons.isUserInteractionEnabled = false
                self.dropDownReasons.placeholder = Reasons[0]
            }
            else{
                self.dropDownReasons.placeholder = "Select Reasons"
                 self.dropDownReasons.isUserInteractionEnabled = true
            }
          
            self.dropDownReasons.tableHeight = 150.0
            self.dropDownReasons.rowBackgroundColor = #colorLiteral(red: 0.4700977206, green: 0.5852692723, blue: 0.7767686844, alpha: 1)
            self.dropDownReasons.textColor = #colorLiteral(red: 0.1286819577, green: 0.3171259165, blue: 0.6042343378, alpha: 1)
            self.dropDownReasons.optionsTextColor =  #colorLiteral(red: 0.1286819577, green: 0.3171259165, blue: 0.6042343378, alpha: 1)
            self.dropDownReasons.options = Reasons
            self.dropDownReasons.didSelect(completion: {
                (option , index) in
                print("You Just select: \(option) at index: \(index)")
                self.sourceReasonTitleForTrans = option
            })
        }
        
        private func methodDropDownBanks(Banks:[String]) {
            
            self.dropDownBankNames.placeholder = Banks[0]
            self.dropDownBankNames.isUserInteractionEnabled = false
            // self.dropDownBankNames.placeholder = "Select Bank"
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
                    }
                }
            })
        }
        
        // MARK: - Action Method
        
        @IBAction func cancelPressed(_ sender: Any) {
            self.navigationController!.popViewController(animated: true)
            
        }
        @IBAction func submitPressed(_ sender: Any) {
            
            if isFromDonations == true{
                let title = self.sourceBank
//                let title = "Donations"
                for aBank in self.banksList {
                    if aBank.bankName == title {
                        self.accountImd = aBank.imdNo
                        self.accounttipe = DataManager.instance.accountType
//                        self.txtfieldaccounttype.text = DataManager.instance.accountType
                        print(DataManager.instance.accountType)
                        
                        
                    }
                }
            }
            
            let transPurpose = self.sourceReasonTitleForTrans
            for aCode in self.reasonsList {
                if aCode.descr == transPurpose {
                    self.sourceReasonCodeForTrans = aCode.code
                }
            }

            
            if self.beneAccountNumberTextField.text == nil || self.beneAccountNumberTextField.text == ""{
                self.showToast(title:"Please enter valid account number")
                return
            }
            
            if amountTextField.text?.count == 0 {
                self.showToast(title: "Please enter amount")
                return
            }
            
            if self.sourceReasonCodeForTrans == nil || (self.sourceReasonCodeForTrans!.isEmpty){
                self.showToast(title: "Please select reason")
                return
            }
            
            self.initiateIBFT()
        }
        
        // MARK: - Utility Method
        
        private func navigateToConfirmation(){
            
            let ibftConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "IBFTConfirmationVC") as! IBFTConfirmationVC
            
            ibftConfirmVC.sourceAccount = DataManager.instance.accountNo
            ibftConfirmVC.beneficaryAccount = self.beneAccountNumberTextField.text
            ibftConfirmVC.beneficaryBankName = self.sourceBank
            ibftConfirmVC.accountTitle = self.transactionApiResponseObj?.data?.accountTitle
            ibftConfirmVC.transferAmount = self.amountTextField.text
            ibftConfirmVC.transPurposeCode = self.sourceReasonCodeForTrans
            ibftConfirmVC.transPurpose = self.sourceReasonTitleForTrans
            ibftConfirmVC.otpReq = self.transactionApiResponseObj?.data?.oTPREQ
            ibftConfirmVC.accountImd = self.accountImd
            ibftConfirmVC.beneIban = self.transactionApiResponseObj?.data?.iban
          
          if isFromDonations == true
            {
              ibftConfirmVC.mainTitle = "Donations".addLocalizableString(languageCode: languageCode)
          }
//            if (self.transactionApiResponseObj?.data?.lastTransactions) != nil
//            {
////                ibftConfirmVC.lsttrsc = transactionApiResponseObj?.data?.lastTransactions
//                ibftConfirmVC.lsttrsc = responseobj?.data?[0].amount
//
//            }

    
            self.navigationController!.pushViewController(ibftConfirmVC, animated: true)
        }
        
        // MARK: - APi Call
        
        
        func getReasonsForTrans() {
            
            if !NetworkConnectivity.isConnectedToInternet(){
                self.showToast(title: "No Internet Available")
                return
            }
            
            showActivityIndicator()
            
            let compelteUrl = GlobalConstants.BASE_URL + "getAllTransPurPose"
            let header = ["Accept":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
            
            
            print(header)
            print(compelteUrl)
            
            NetworkManager.sharedInstance.enableCertificatePinning()
            
            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetReasonsModel>) in
                self.hideActivityIndicator()
                
                if response.response?.statusCode == 200 {
                    
                    self.reasonsObj = response.result.value
                    if self.reasonsObj?.responsecode == 2 || self.reasonsObj?.responsecode == 1 {
                        
                        if isFromDonations == true{
                            self.methodDropDownReasons(Reasons:[self.sourceReasonTitleForTrans!])
                        }
                        else{
                            self.arrReasonsList = self.reasonsObj?.stringReasons
                            self.methodDropDownReasons(Reasons: self.arrReasonsList!)
                        }
                        
                        if let reasonCodes = self.reasonsObj?.reasonsData{
                            self.reasonsList = reasonCodes
                        }
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    
//                    print(response.result.value)
//                    print(response.response?.statusCode)
                }
            }
        }
        
        
        private func getBankNames() {
            
            if !NetworkConnectivity.isConnectedToInternet(){
                self.showToast(title: "No Internet Available")
                return
            }
            
            showActivityIndicator()
            
            let compelteUrl = GlobalConstants.BASE_URL + "getAllImdList"
            let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
            
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
                        self.getReasonsForTrans()
                        //                        self.arrBanksList = self.banksObj?.stringBanks
                        //                        self.methodDropDownBanks(Banks: self.arrBanksList!)
                        
                    }
                    else {
                        // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                    }
                }
                else {
                    
//                    print(response.result.value)
//                    print(response.response?.statusCode)
                    
                }
            }
        }
        
        private func initiateIBFT() {
            
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
            
//            let compelteUrl = GlobalConstants.BASE_URL + "initiateIbft"
            let compelteUrl = GlobalConstants.BASE_URL + "v2/initiateIbft"
            
//                  
            
         
            
            let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"accountNo":self.beneAccountNumberTextField.text!,"accountIMD":self.accountImd!,"amount":self.amountTextField.text!,"transPurpose":self.sourceReasonCodeForTrans!,"accountType":DataManager.instance.accountType!]
            print(parameters)
            
            let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
            
            print(result.apiAttribute1)
            print(result.apiAttribute2)
            
            let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
            
            let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
            
            print(params)
            print(compelteUrl)
            
            NetworkManager.sharedInstance.enableCertificatePinning()
            
            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FTApiResponse>) in
                
                self.hideActivityIndicator()
                
                self.transactionApiResponseObj = response.result.value
                if response.response?.statusCode == 200 {
                    
                    if self.transactionApiResponseObj?.responsecode == 2 || self.transactionApiResponseObj?.responsecode == 1 {
                        self.navigateToConfirmation()
//
                    }
                    else {
                        if let message = self.transactionApiResponseObj?.messages{
//                            self.showDefaultAlert(title: "", message: message)
                        }
                    }
                }
                else {
                    if let message = self.transactionApiResponseObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
//                    print(response.response?.statusCode) 
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
//            let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//            navigationController?.pushViewController(vc, animated: true)
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
    
   
