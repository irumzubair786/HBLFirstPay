//
//  UtilityBillPaymentOneBillVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 22/01/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class UtilityBillPaymentOneBillVC: BaseClassVC , UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
   
    
    @IBOutlet weak var outerview: UIView!
    var myarr : [transactionlistOnebill] = []
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblDueDateTitle: UILabel!
    @IBOutlet weak var lblEnterOtp: UILabel!
    @IBOutlet  var otpTextField: UITextField!
    
    @IBOutlet weak var lblphoneno: UILabel!
    
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
    var utilityCompanyID : String?
    var utilityBillCompanyId : String?
  
    var responseobj : TransactionResponse?
    var sourceAccount:String?
    var beneficaryAccount:String?
    var accountTitle: String?
    var comments: String?
    var otpReq: String?
    
    var genResObj : GenericResponse?
    var ubpSuccessObj : FundsTransferApiResponse?
    
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
    @IBOutlet  var payableAmountTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBeneficiary = true
        btnok.isHidden = true
        blurview.isHidden = true
        payableAmountTextField.delegate = self
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
        self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
        self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
        self.viewAddBeneficiary.isHidden = true
        
        if let imdComp = self.utilityCompanyID {
            if imdComp == "CC01BILL" || imdComp == "TP01BILL" || imdComp == "CAREEM01"{
                self.payableAmountTextField.isUserInteractionEnabled = true
            }
            else{
                self.payableAmountTextField.isUserInteractionEnabled = false
            }
            
        }
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.viewBottomButtons.frame.origin.y) + (self.viewBottomButtons.frame.size.height) + 50)
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
    
    // MARK: - Utility Methods
    
    private func clearAll(){
        
        self.lblCompanyName.text = ""
        self.lblCustomerName.text = ""
        self.lblDueDate.text = ""
        
    }
    
    private func updateUI(){
        
        if let companyNameText = self.companyName{
            self.lblCompanyName.text = companyNameText
            self.nickNameTextField.text = companyNameText
        }
        if let accountTitleText = self.accountTitle{
            self.lblCustomerName.text = accountTitleText
        }
        
        
        if let imdComp = self.utilityCompanyID {
            if imdComp == "TP01BILL"{
                self.lblDueDateTitle.isHidden = true
                self.lblDueDate.isHidden = true
            }
        }
        
        if let imdComp = self.utilityCompanyID {
            if imdComp == "IN01BILL"{
                if let amountpay = self.paidAmount{
                    // self.lblPayableAmountValue.text = "PKR \(amountpay).00"
                    self.payableAmountTextField.text = amountpay
                }
                else{
                    self.payableAmountTextField.text = "Not Available"
                }
            }
            
            if imdComp == "CAREEM01"{
                
                self.lblDueDateTitle.text = "Account Number :"
                self.lblDueDate.text = self.utilityConsumerNo
            }
            else{
                if let date = self.dueDate{
                    self.lblDueDate.text = date
                }
            }
        }
        
    }
    
    @IBOutlet weak var tableview: UITableView!
    
    
    @IBOutlet weak var blurview: UIVisualEffectView!
    @IBAction func lasttransaction(_ sender: UIButton) {
        self.Lasttransactions()
    }
    
    
    @IBAction func otpcall(_ sender: UIButton) {
        OTVCall()
    }
    
    @IBAction func okaction(_ sender: UIButton) {
        blurview.isHidden = true
        btnok.isHidden = true
    }
    
    private func navigateToDetailsVC(){
        
        let billPaymentSuccessVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentSuccessfulVC") as! UtilityBillPaymentSuccessfulVC
        
        
        // transfer amount
        
        billPaymentSuccessVC.companyName = self.companyName
        billPaymentSuccessVC.customerName = self.accountTitle
        billPaymentSuccessVC.consumerNumber = self.utilityConsumerNo
        billPaymentSuccessVC.transferAmount = self.payableAmountTextField.text
        billPaymentSuccessVC.TransRefNumber = self.ubpSuccessObj?.data?.authIdResponse
        billPaymentSuccessVC.TransTime = self.ubpSuccessObj?.data?.transDate
        
        self.navigationController!.pushViewController(billPaymentSuccessVC, animated: true)
    }
    
    
    
    
    // MARK: - Action Methods
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
        
        
        self.inititatePayment()
    }
    
    @IBOutlet weak var btnok: UIButton!
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
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
    func setvalue()
    {
        lblphoneno.text = DataManager.instance.accountNo
//        accountnolbl.text = DataManager.instance.mobile_number
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
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "v2/billPayment"
        
        let parameters = ["lat":"\(DataManager.instance.Latitude)","lng":"\(DataManager.instance.Longitude)","cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","utilityBillCompany":self.utilityBillCompany!,"beneficiaryAccountTitle":self.accountTitle!,"utilityConsumerNo":self.utilityConsumerNo!,"amountPaid":self.payableAmountTextField.text!,"beneficiaryName":self.nickNameTextField.text!,"beneficiaryMobile":self.mobileNumberTextField.text!,"beneficiaryEmail":self.emailTextField.text!,"otp":self.otpTextField.text!,"addBeneficiary":self.addBeneValue,"utilityBillCompanyId":self.utilityBillCompanyId!, "accountType": DataManager.instance.accountType!]
        
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
    
        let parameters = ["accountNo":"\(self.utilityConsumerNo!)","imei": DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","transactionType" : "UBP" ,"cnic":userCnic!]
    
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
                blurview.isHidden = false
               
                outerview.dropShadow1()
                 setvalue()
                tableview.delegate = self
                tableview.dataSource = self
                tableview.reloadData()
                btnok.isHidden = false
                
//                self.showDefaultAlert(title: "", message: self.responseobj!.messages!)
                
            }
            else {
                if let message = self.responseobj?.messages {
                    showDefaultAlert(title: "", message: message)
//                    UtilManager.showAlertMessage(message: (responseobj?.messages)!, viewController: self)
                }
            }
        }
        else {
            if let message = self.responseobj?.messages {
                showDefaultAlert(title: "", message: message)
//                UtilManager.showAlertMessage(message: (responseobj?.messages)!, viewController: self)
            }
//                print(response.result.value)
//                print(response.response?.statusCode)
            
        }
    }
}
    func loadtrasanctionbill()
    {
        var tempobj = transactionlistOnebill()
        
        tempobj.amount = (responseobj?.data?[0].amount)!
        tempobj.transactionDate = (responseobj?.data?[0].transactionDate)!
        myarr.append(tempobj)
    }

}
extension UtilityBillPaymentOneBillVC
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseobj?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableview.dequeueReusableCell(withIdentifier: "Cell1BillVC") as! Cell1BillVC
        
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
class transactionlistOnebill
{
    var transactionDate = ""
    var amount = 0
}
