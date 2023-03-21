//
//  FundsTransferConfirmationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/12/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class FundsTransferConfirmationVC: BaseClassVC , UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var outerview: UIView!
    var myarr : [transactiondata] = []
    @IBOutlet weak var lblSourceAccount: UILabel!
    @IBOutlet weak var lblBeneficaryAccount: UILabel!
    @IBOutlet weak var lblAccountTitle: UILabel!
    @IBOutlet weak var lblSourceAccountTitle: UILabel!
    @IBOutlet weak var lblTransAmount: UILabel!
    @IBOutlet weak var lblEnterOtp: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblFed: UILabel!
    @IBOutlet weak var blurview: UIVisualEffectView!
    @IBOutlet weak var otpcalloutlet: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var phoneno: UILabel!
    var mainTitle : String?
    @IBOutlet weak var lblMainTitle: UILabel!
    
    
    @IBOutlet weak var lblMainLastTransaction: UILabel!
    
    @IBOutlet weak var lblAddBeneficiary: UILabel!
    @IBOutlet weak var lblSourceAcc: UILabel!
    @IBOutlet weak var lblTransferAccount: UILabel!
    @IBOutlet weak var lblBeneifiaryAccount: UILabel!
    @IBOutlet weak var lblEnterOTP: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnResendOTP: UIButton!
    @IBOutlet weak var btnLastTransaction: UIButton!
    @IBOutlet weak var lblAccTitle: UILabel!
    
    @IBOutlet weak var btnok: UIButton!
    func ChangeLanguage()
    {
//        lblSourceAcc.text = "Source Account".addLocalizableString(languageCode: languageCode)
//        lblMainTitle.text = "Local Funds Transfer Confirmation".addLocalizableString(languageCode: languageCode)
//                    lblBeneifiaryAccount.text = "Beneficiary Account".addLocalizableString(languageCode: languageCode)
        btnok.setTitle("Ok".addLocalizableString(languageCode: languageCode), for: .normal)
        lblMainLastTransaction.text = "Last Transaction".addLocalizableString(languageCode: languageCode)
//                    lblTransferAccount.text = "Transfer Account".addLocalizableString(languageCode: languageCode)
        btnResendOTP.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
                    btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
                    btnSubmit.setTitle("PAY NOW".addLocalizableString(languageCode: languageCode), for: .normal)
//        lblBeneifiaryAccount.text = "Beneficiary Account".addLocalizableString(languageCode: languageCode)
//        lblEnterOtp.text = "Enter OTP".addLocalizableString(languageCode: languageCode)
//        btnResendOTP.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
        btnLastTransaction.setTitle("Last Transaction".addLocalizableString(languageCode: languageCode), for: .normal)
        lblAddBeneficiary.text = "Add Beneficiary".addLocalizableString(languageCode: languageCode)
        nickNameTextField.placeholder = "Nickname".addLocalizableString(languageCode: languageCode)
        mobileNumberTextField.placeholder = "Mobile Number".addLocalizableString(languageCode: languageCode)
        emailTextField.placeholder = "Email".addLocalizableString(languageCode: languageCode)
//        
                     
    }
    
    
    var sourceAccount:String?
    var beneficaryAccount:String?
    var transferAmount:String?
    var accountTitle: String?
    var feeAmount: Double?
    var fedAmount: Double?
    var transPurposeCode: String?
    var otpReq: String?
    
    var responseobj : TransactionResponse?
    var trasactionamount : Int?
    var trsactiondate : String?
    var accounttype: String?
 
    var lastTransactionsArray = [LastTransactionsResponse]()
//
   
    var genResponse : GenericResponse?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBottomButtons: UIView!
    @IBOutlet weak var viewAddBeneficiary: UIView!
    @IBOutlet var viewBottomButtonsUpperConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomButtonsDownConstraint: NSLayoutConstraint!
    @IBOutlet var btn_AddBene: UIButton!
    var addBeneficiary:Bool?
    var addBeneValue : String = "N"
    @IBOutlet  var nickNameTextField: UITextField!
    @IBOutlet  var mobileNumberTextField: UITextField!
    @IBOutlet  var emailTextField: UITextField!
    @IBOutlet  var otpTextField: UITextField!
    var indexOfDropDown : String?
    var fundsTransSuccessObj: FundsTransferApiResponse?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        blurview.isHidden = true
        otpcalloutlet.isHidden = true
        self.clearAll()
        self.updateUI()
        
        addBeneficiary = true
        btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
        self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
        self.viewAddBeneficiary.isHidden = true
        
        if self.otpReq == "N"{
            self.otpTextField.isHidden = true
            self.lblEnterOtp.isHidden = true
        }
        else{
            self.otpTextField.isHidden = false
            otpcalloutlet.isHidden = false
            self.lblEnterOtp.isHidden = false
           
        }
     
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.viewBottomButtons.frame.origin.y) + (self.viewBottomButtons.frame.size.height) + 50)
      

    }
    
    // MARK: - Utility Methods
    
    private func clearAll(){
        
        self.lblSourceAccount.text = ""
        self.lblBeneficaryAccount.text = ""
        self.lblAccountTitle.text = ""
        self.lblTransAmount.text = ""
        //        self.lblFee.text = ""
        //        self.lblFed.text = ""
        
    }

    
    private func updateUI(){
       if mainTitle == "Donations" {
           lblMainTitle.text = mainTitle
        }
        
        else
        {
            lblMainTitle.text = "Local Funds Transfer Confirmation".addLocalizableString(languageCode: languageCode)
        }
        if let account = sourceAccount  {
            self.lblSourceAccount.text = account
        }
        if let sourceAccount = DataManager.instance.serverAccountTitile  {
            self.lblSourceAccountTitle.text = sourceAccount
        }
        if let beneAccount = beneficaryAccount{
            self.lblBeneficaryAccount.text = beneAccount
        }
        if let Tamount = transferAmount{
            self.lblTransAmount.text = "PKR \(convertToCurrrencyFormat(amount:String(Tamount)))"
        }
        if let accountTitle = accountTitle{
            self.lblAccountTitle.text = accountTitle
            self.nickNameTextField.text = accountTitle
        }
        if let feeAmount = feeAmount{
            self.lblFee.text = "PKR \(convertToCurrrencyFormat(amount:String(feeAmount)))"
        }
        if let fedAmount = fedAmount{
            self.lblFed.text = "PKR \(convertToCurrrencyFormat(amount:String(fedAmount)))"
           
        }
//        if let title = self.mainTitle{
//            self.lblMainTitle.text = "\(title) Confirmation"
//        }
        
    }
    
    // MARK: - UITextfield Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == mobileNumberTextField{
            return newLength <= 11
        }
        else {
            return newLength <= 16
        }
        
        
    }
    
    // MARK: - Action Methods
    
    
    
    @IBAction func lastrsactionsbtn(_ sender: UIButton) {
        self.Lasttransactions()
     
          
    }
    
    
    @IBAction func okaction(_ sender: UIButton) {
        
        blurview.isHidden = true
    }
    
    
    @IBAction func payNowPressed(_ sender: Any) {
        
        if self.otpReq == "Y"{
            if otpTextField.text?.count == 0 {
                self.showToast(title: "Please Enter OTP")
                return
            }
        }
        
        if emailTextField.text!.count > 0{
            if isValidEmail(testStr: emailTextField.text!)
            {
                print("Valid Email ID")
                // self.showToast(title: "Validate EmailID")
            }
            else
            {
                print("Invalid Email ID")
                self.showDefaultAlert(title: "Error", message: "Invalid Email ID")
                return
            }
            
        }
        self.initiateFundTrasnfer()
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func otvCallFTPressed(_ sender: Any) {
        self.OTVCall()
    }
    
    @IBAction func action_AddBeneficiary(_ sender: Any) {
        
        addBeneficiary = !addBeneficiary!
        
        if addBeneficiary! {
            btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
            self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
            self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
            self.addBeneValue = "N"
            self.viewAddBeneficiary.isHidden = true
            self.scrollView.layoutIfNeeded()
        }
        else {
            btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
            self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 998)
            self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 999)
            self.addBeneValue = "Y"
            self.viewAddBeneficiary.isHidden = false
            self.scrollView.layoutIfNeeded()
        }
        
        
    }
   
    

    
    
    private func navigateToDetailsVC(){
        let localFundsDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "FundsTransferSuccessfullVC") as! FundsTransferSuccessfullVC
        
        localFundsDetailsVC.sourceAccount = DataManager.instance.accountNo
        localFundsDetailsVC.beneficaryAccount = self.beneficaryAccount
        localFundsDetailsVC.beneficaryAccountTitle = self.accountTitle!
        localFundsDetailsVC.transferAmount = self.transferAmount
        localFundsDetailsVC.TransRefNumber = self.fundsTransSuccessObj?.data?.authIdResponse
        localFundsDetailsVC.TransTime = self.fundsTransSuccessObj?.data?.transDate
       
        
       if  isFromDonations ==  true
        {
           localFundsDetailsVC.mainTitle = "Donations".addLocalizableString(languageCode: languageCode)
       }
        
        self.navigationController!.pushViewController(localFundsDetailsVC, animated: true)
    }
    
    
    // MARK: - API CALL
    
    private func initiateFundTrasnfer() {
        
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
        var requestMoneyId : String?
        
        if let iD = DataManager.instance.requesterMoneyId {
            requestMoneyId = iD
        }
        else{
            requestMoneyId = ""
        }
        if addBeneValue == "N"{
            self.nickNameTextField.text = ""
        }
    
        
        showActivityIndicator()
        
        
//        let compelteUrl = GlobalConstants.BASE_URL + "fundsTransferLocal"
        let compelteUrl = GlobalConstants.BASE_URL + "v2/fundsTransferLocal"
       
        
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"narration":"","cnic":userCnic!,"accountNo":self.beneficaryAccount!,"amount":self.transferAmount!,"transPurpose":self.transPurposeCode!,"accountTitle":self.accountTitle!,"beneficiaryName":self.nickNameTextField.text!,"beneficiaryMobile":self.mobileNumberTextField.text!,"beneficiaryEmail":self.emailTextField.text!,"addBeneficiary":self.addBeneValue,"otp":self.otpTextField.text!,"requestMoneyId":requestMoneyId,"accountType": DataManager.instance.accountType!]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FundsTransferApiResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.fundsTransSuccessObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.fundsTransSuccessObj?.responsecode == 2 || self.fundsTransSuccessObj?.responsecode == 1 {
                    self.navigateToDetailsVC()
                }
                else {
                    if let message = self.fundsTransSuccessObj?.messages{
                        self.showDefaultAlert(title: "", message: "\(message) \(self.fundsTransSuccessObj?.messages ?? "") ")
                    }
                }
            }
            else {
                if let message = self.fundsTransSuccessObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
  
    private func OTVCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
        
        let parameters = ["mobileNo":"\(DataManager.instance.accountNo!)","type":GlobalOTPTypes.OTP_FUNDS_TRANSFER,"channelId":"\(DataManager.instance.channelID)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        print(params)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.genResponse = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genResponse?.responsecode == 2 || self.genResponse?.responsecode == 1 {
                  
                    self.showDefaultAlert(title: "", message: self.genResponse!.messages!)
                    
                }
                else {
                    if let message = self.genResponse?.messages {
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.genResponse?.messages {
                    self.showAlert(title: "", message: message, completion: nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
   
//    -----------------
    private func Lasttransactions() {
        
        
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

        let compelteUrl = GlobalConstants.BASE_URL + "v2/lastTransactions"
        
        let parameters = ["accountNo":"\(self.beneficaryAccount!)","imei": DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","transactionType" : "IBT" ,"cnic":userCnic!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        print(params)
        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<TransactionResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.responseobj = response.result.value
        
            if response.response?.statusCode == 200 {
                if self.responseobj?.responsecode == 2 || self.responseobj?.responsecode == 1 {
                    blurview.isHidden = false
                    
                    outerview.dropShadow1()
                    phoneno.text = DataManager.instance.mobile_number
                    tableview.delegate = self
                    tableview.dataSource = self
                    tableview.reloadData()
//                    self.showDefaultAlert(title: "", message: self.responseobj!.messages!)
                    
                }
                else {
                    if let message = self.responseobj?.messages {
                        UtilManager.showAlertMessage(message: (responseobj?.messages)!, viewController: self)
                        
//                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.responseobj?.messages {
                    UtilManager.showAlertMessage(message: (responseobj?.messages)!, viewController: self)
//                    self.showAlert(title: "", message: message, completion: nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    func loadtrasanctiondata()
    {
        var tempobj = transactiondata()
        
        tempobj.amount = (responseobj?.data?[0].amount)!
        tempobj.transactionDate = (responseobj?.data?[0].transactionDate)!
        myarr.append(tempobj)
    }

    
}

extension FundsTransferConfirmationVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return responseobj?.data?.count ?? 0
        
        
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableview.dequeueReusableCell(withIdentifier: "LFundsCellVC") as! LFundsCellVC
       
        let aRequest = self.responseobj?.data?[indexPath.row]
       
        aCell.datelbl.text = aRequest?.transactionDate ?? ""
        let a =  (Int((aRequest?.amount!)!))
        aCell.rupeelbl.text =    "\("PKR.")\(a)"
        aCell.viewcell.dropShadow1()
        return aCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
                cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
                },completion: { finished in
                    UIView.animate(withDuration: 0.1, animations: {
                        cell.layer.transform = CATransform3DMakeScale(1,1,1)
                    })
            })
        }
   
}

class transactiondata
{
    var transactionDate = ""
    var amount = 0
}
