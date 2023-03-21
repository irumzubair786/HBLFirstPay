//
//  UtilityBillPaymentConfirmationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 17/01/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class UtilityBillPaymentConfirmationVC: BaseClassVC , UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{ //,UITableViewDelegate,UITableViewDataSource{
    
   
    @IBOutlet weak var blurView: UIVisualEffectView!
    var myarr : [transactionlistbill] = []
    var reasonsObj : GetReasonsModel?
    var reasonsList = [ReasonsData]()
    var responseobj : TransactionResponse?
    var arrReasonsList : [String]?
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblBillStatus: UILabel!
    
    @IBOutlet weak var lblAmountWithinDue: UILabel!
    @IBOutlet weak var lblAmountAfterDueDate: UILabel!
    @IBOutlet weak var lblEnterOtp: UILabel!
    @IBOutlet  var otpTextField: UITextField!
    @IBOutlet weak var accountnolbl: UILabel!
    @IBOutlet weak var phonenolbl: UILabel!
 
    @IBOutlet weak var payableAmountTextField: UITextField!
    @IBOutlet weak var lblpayableamount: UILabel!
  
    var dueDate:String?
   
  
    var totalAmountl:String?
    var paidAmount:String?
    var remainingAmount:String?
    var amountAfterDD:String?
    var remAmountAftrDD:String?
    var status:String?
    var companyName:String?
    var utilityBillCompany:String?
    var utilityConsumerNo:String?
    var utilityBillCompanyId : Int?
    var lsttrsc : [lasttransactionupdated]?
    var trasactionamount : Int?
    
    var sourceAccount:String?
    var beneficaryAccount:String?
    var accountTitle: String?
    var comments: String?
    var otpReq: String?
    
    var genResObj : GenericResponse?
    var ubpSuccessObj : FundsTransferApiResponse?
    var billtransactionOBj : BillAPiResponse?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBottomButtons: UIView!
    @IBOutlet weak var viewAddBeneficiary: UIView!
    
    @IBOutlet var btn_AddBene: UIButton!
    var addBeneficiary:Bool?
    var addBeneValue : String = "N"
    @IBOutlet var viewBottomButtonsUpperConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomButtonsDownConstraint: NSLayoutConstraint!
    @IBOutlet  var nickNameTextField: UITextField!
    @IBOutlet  var mobileNumberTextField: UITextField!
    @IBOutlet  var emailTextField: UITextField!
    
    @IBOutlet weak var lblBillSta: UILabel!
    @IBOutlet weak var lblCompny: UILabel!
    @IBOutlet weak var lblCusName: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblAmountDD: UILabel!
    @IBOutlet weak var lblAmountAfterD: UILabel!
 
      @IBOutlet weak var lblEnterOTP: UILabel!
      @IBOutlet weak var btnCancel: UIButton!
      @IBOutlet weak var btnSubmit: UIButton!
      @IBOutlet weak var btnResendOTP: UIButton!
      @IBOutlet weak var btnLastTransaction: UIButton!
      
    
    
    func Change()
    {
       
        lblCompny.text = "Company".addLocalizableString(languageCode: languageCode)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnSubmit.setTitle("PAY NOW".addLocalizableString(languageCode: languageCode), for: .normal)
        lblCusName.text = "Customer Name".addLocalizableString(languageCode: languageCode)
        lblBillSta.text = "Bill Status".addLocalizableString(languageCode: languageCode)
        lblAmountDD.text = "Amount within Due Date".addLocalizableString(languageCode: languageCode)
        lblAmountAfterD.text = "Amount After Due Date".addLocalizableString(languageCode: languageCode)
        lblEnterOtp.text = "Enter OTP".addLocalizableString(languageCode: languageCode)
            btnResendOTP.setTitle("Resend OTP via Call".addLocalizableString(languageCode: languageCode), for: .normal)
            btnLastTransaction.setTitle("Last Transaction".addLocalizableString(languageCode: languageCode), for: .normal)
            nickNameTextField.placeholder = "Nickname".addLocalizableString(languageCode: languageCode)
            mobileNumberTextField.placeholder = "Mobile Number".addLocalizableString(languageCode: languageCode)
            emailTextField.placeholder = "Email".addLocalizableString(languageCode: languageCode)
        btnLastTransaction.setTitle("Last Transaction".addLocalizableString(languageCode: languageCode), for: .normal)
        lblTransationMainTitle.text = "Last Transaction".addLocalizableString(languageCode: languageCode)
        btnok.setTitle("OK".addLocalizableString(languageCode: languageCode), for: .normal)
    }
    
    @IBOutlet weak var btnok: UIButton!
    @IBOutlet weak var lblTransationMainTitle: UILabel!
    
    var isPaid : Bool = false

    @IBOutlet weak var lblmainTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Change()
        payableAmountTextField.delegate = self
        blurView.isHidden = true
        lblpayableamount.isHidden = true
        payableAmountTextField.isHidden = true
        if self.otpReq == "N"{
            self.otpTextField.isHidden = true
            self.lblEnterOtp.isHidden = true
        }
        else{
            self.otpTextField.isHidden = false
            self.lblEnterOtp.isHidden = false
        }
        
       
        self.clearAll()
        self.updateUI()
        
        addBeneficiary = true
        btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
//        self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
//        self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
        self.viewAddBeneficiary.isHidden = true
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.viewBottomButtons.frame.origin.y) + (self.viewBottomButtons.frame.size.height) + 50)
        
    }
    
    
    
    
    @IBAction func lasttrasactions(_ sender: UIButton) {
        self.Lasttransactions()
        
        
    }
    
    
    
    @IBAction func otpcall(_ sender: UIButton) {
        OTVCall()
       
    }
    
    @IBAction func okaction(_ sender: UIButton) {
        blurView.isHidden = true
        
    }
    
    func setvalue()
    {
        phonenolbl.text = DataManager.instance.accountNo
        
    }
    
    
    
    
    
    // MARK: - Utility Methods
    
    private func clearAll(){
        
        self.lblCompanyName.text = ""
        self.lblCustomerName.text = ""
        self.lblBillStatus.text = ""

        self.lblAmountWithinDue.text = ""
        self.lblAmountAfterDueDate.text = ""
    }
    
    private func OTVCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getOtpCall"
        
        
        let parameters = ["mobileNo":"\(DataManager.instance.accountNo!)","type":GlobalOTPTypes.OTP_BILL_PAYMENT,"channelId":"\(DataManager.instance.channelID)"]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
//
//        print(params)
//        print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
            self.hideActivityIndicator()
            
            self.genRespBaseObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genRespBaseObj?.responsecode == 2 || self.genRespBaseObj?.responsecode == 1 {
                    
                    self.showDefaultAlert(title: "", message: self.genRespBaseObj!.messages!)
                    
                }
                else {
                    if let message = self.genRespBaseObj?.messages {
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.genRespBaseObj?.messages {
                    self.showAlert(title: "", message: message, completion: nil)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    private func updateUI(){
        
       
        
        if let companyNameText = self.companyName{
            self.lblCompanyName.text = companyNameText
            self.nickNameTextField.text = companyNameText
        }
        if let accountTitleText = self.accountTitle{
            self.lblCustomerName.text = accountTitleText
        }
        
        if let billStatusText = self.status{
            if billStatusText == "U"{
                self.lblBillStatus.text = "Unpaid"
            }
            if billStatusText == "P"{
                self.lblBillStatus.text = "Paid"
            }
            if billStatusText == "T"{
                self.lblBillStatus.text = "Partial Payment"
            }
            if billStatusText == "B"{
                self.lblBillStatus.text = "Blocked"
            }
        }
//
        if let amountWithinDueText = self.totalAmountl{
            self.lblAmountWithinDue.text = String(amountWithinDueText)
        }
        if let amountAfterDueText = self.amountAfterDD{
            self.lblAmountAfterDueDate.text = String(amountAfterDueText)
        }
        if lblAmountWithinDue.text == "0"
        {
            lblpayableamount.isHidden = false
            payableAmountTextField.isHidden = false
            payableAmountTextField.delegate = self
           
        }
       
        if lblAmountWithinDue.text != "0"
        {
            lblpayableamount.isHidden = true
            payableAmountTextField.isHidden = true
            
            payableAmountTextField.text = lblAmountWithinDue.text!
        }
    }
    
    private func navigateToDetailsVC(){
        
        let billPaymentSuccessVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentSuccessfulVC") as! UtilityBillPaymentSuccessfulVC
        
        billPaymentSuccessVC.companyName = self.companyName
        billPaymentSuccessVC.customerName = self.accountTitle
        billPaymentSuccessVC.consumerNumber = self.utilityConsumerNo
        billPaymentSuccessVC.transferAmount = payableAmountTextField.text
        billPaymentSuccessVC.TransRefNumber = self.ubpSuccessObj?.data?.authIdResponse
        billPaymentSuccessVC.TransTime = self.ubpSuccessObj?.data?.transDate
 
        
        
        
        self.navigationController!.pushViewController(billPaymentSuccessVC, animated: true)
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
    @IBAction func payNowPressed(_ sender: Any) {
        
        if self.otpReq == "Y"{
            if otpTextField.text?.count == 0 {
                self.showToast(title: "Please Enter OTP")
                return
            }
        }
        if let billStatusText = self.status{
            if billStatusText == "P"{
                self.showToast(title: "Bill Already Paid")
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
        
       self.inititatePayment()
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBOutlet weak var outerview: UIView!
    @IBAction func action_AddBeneficiary(_ sender: Any) {
          
          addBeneficiary = !addBeneficiary!
          
          if addBeneficiary! {
              btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
//              self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
//              self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
              self.addBeneValue = "N"
              self.viewAddBeneficiary.isHidden = true
              self.scrollView.layoutIfNeeded()
          }
          else {
              btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
//              self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 998)
//              self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 999)
              self.addBeneValue = "Y"
              self.viewAddBeneficiary.isHidden = false
              self.scrollView.layoutIfNeeded()
          }
          
          
      }
    
    
    // MARK: - Api Call

    private func inititatePayment() {

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
//        self.utilityBillCompany
        showActivityIndicator()
        
  //      let compelteUrl = GlobalConstants.BASE_URL + "billPayment"
        let compelteUrl = GlobalConstants.BASE_URL + "v2/billPayment"
        
        let parameters = ["lat":"\(DataManager.instance.Latitude)","lng":"\(DataManager.instance.Longitude)","cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","utilityBillCompany":"\((utilityBillCompany) ?? "")","accountType": DataManager.instance.accountType!,"beneficiaryAccountTitle":self.accountTitle!,"utilityConsumerNo":self.utilityConsumerNo!,"amountPaid":self.payableAmountTextField.text!,"beneficiaryName":self.nickNameTextField.text!,"beneficiaryMobile":self.mobileNumberTextField.text!,"beneficiaryEmail":self.emailTextField.text!,"otp":self.otpTextField.text!,"addBeneficiary":self.addBeneValue,"utilityBillCompanyId":self.utilityBillCompanyId!] as [String : Any]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<FundsTransferApiResponse>) in


            self.hideActivityIndicator()

            self.ubpSuccessObj = response.result.value
            if response.response?.statusCode == 200 {

                if self.ubpSuccessObj?.responsecode == 2 || self.ubpSuccessObj?.responsecode == 1 {
               
                    
                    
                    self.navigateToDetailsVC()
                }
                else {
                    if let message = self.ubpSuccessObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.ubpSuccessObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
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
    
        let parameters = ["accountNo":(self.utilityConsumerNo)!,"imei": DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","transactionType" : "UBP" ,"cnic":userCnic!]
    
    let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
    
    print(result.apiAttribute1)
    print(result.apiAttribute2)
    
    let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
    
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
    
    print(params)
    print(compelteUrl)
    
 
    NetworkManager.sharedInstance.enableCertificatePinning()
    
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<TransactionResponse>) in
        
      
        self.hideActivityIndicator()
        
        self.responseobj = response.result.value
        
        if response.response?.statusCode == 200 {
            if self.responseobj?.responsecode == 2 || self.responseobj?.responsecode == 1 {
                blurView.isHidden = false
                
                outerview.dropShadow1()
                setvalue()
                tableview.delegate = self
                tableview.dataSource = self
                tableview.reloadData()

                
//                self.showDefaultAlert(title: "", message: self.responseobj!.messages!)
                
            }
            else {
                if let message = self.responseobj?.messages {
                    self.showDefaultAlert(title: "", message: message)
//                    UtilManager.showAlertMessage(message: (responseobj?.messages)!, viewController: self)
                }
            }
        }
        else {
            if let message = self.responseobj?.messages {
                self.showDefaultAlert(title: "", message: message)
//                UtilManager.showAlertMessage(message: (responseobj?.messages)!, viewController: self)
            }
//                print(response.result.value)
//                print(response.response?.statusCode)
            
        }
    }
}
    func loadtrasanctionbill()
    {
        var tempobj = transactionlistbill()
        
        tempobj.amount = (responseobj?.data?[0].amount)!
        tempobj.transactionDate = (responseobj?.data?[0].transactionDate)!
        myarr.append(tempobj)
    }
}

extension UtilityBillPaymentConfirmationVC
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return responseobj?.data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableview.dequeueReusableCell(withIdentifier: "BillTrasactionCEll") as! BillTrasactionCEll
        
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
class transactionlistbill
{
    var transactionDate = ""
    var amount = 0
}
