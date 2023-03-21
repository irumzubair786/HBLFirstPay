//
//  PrePaidTopUpConfirmationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 11/12/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class PrePaidTopUpConfirmationVC: BaseClassVC, UITextFieldDelegate{
   
    var myarr : [transactionlist] = []
    var oTPREQ: String?
    var utilityBillCompany : String?
    var utilityConsumerNo : String?
    var amountPaid : String?
    var companyName : String?
    var utilityBillCompanyId : Int?
    var trasactionamount : Int?
    var reasonsObj : GetReasonsModel?
    var reasonsList = [ReasonsData]()
    var arrReasonsList : [String]?
    var transactionApiResponseObj : TopUpApiResponse?
    var responsetra : FTApiResponse?

    var successmodelobj : FundsTransferApiResponse?
    var fundsInitiateObj : FundInitiateModel?
    var responseobj : TransactionResponse?

   
    @IBOutlet weak var outerview: UIView!
    @IBOutlet weak var accountnolbl: UILabel!
    @IBOutlet weak var phonenolbl: UILabel!
    @IBOutlet weak var tablleview: UITableView!
    @IBOutlet weak var blurview: UIVisualEffectView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var otpTextField: UITextField!
    
    @IBOutlet weak var lblCompanyNameValue: UILabel!
    @IBOutlet weak var lblMobileNumberValue: UILabel!
    @IBOutlet weak var lblTransferAmountValue: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var btn_AddBene: UIButton!
    var addBeneficiary:Bool?
    var addBeneValue : String = "N"
    var otpReq: String?
    var svotpreq: String?
    @IBOutlet var viewBottomButtonsUpperConstraint: NSLayoutConstraint!
    @IBOutlet var viewBottomButtonsDownConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewBottomButtons: UIView!
    @IBOutlet weak var viewAddBeneficiary: UIView!
    
//    var fundsTransSuccessObj: FundsTransferSuccessModel?
   
    var trasaction : String?
    @IBOutlet weak var lblEnterOtp: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        blurview.isHidden = true
        
//        tablleview.rowHeight = 80
        if self.otpReq == "N"{
            self.otpTextField.isHidden = true
            self.lblEnterOtp.isHidden = true
        }
        else{
            self.otpTextField.isHidden = false
            self.lblEnterOtp.isHidden = false
        }
        
        self.updateUI()
        
        addBeneficiary = true
        btn_AddBene.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        self.viewBottomButtonsDownConstraint.priority = UILayoutPriority(rawValue: 998)
        self.viewBottomButtonsUpperConstraint.priority = UILayoutPriority(rawValue: 999)
        self.viewAddBeneficiary.isHidden = true
        
        // Do any additional setup after loading the view.
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
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        if let company = self.companyName{
            self.lblCompanyNameValue.text = company
            self.nickNameTextField.text = company
        }
        if let mobileNo = self.utilityConsumerNo{
            self.lblMobileNumberValue.text = mobileNo
        }
        if let tAmount = self.amountPaid{
            self.lblTransferAmountValue.text = tAmount
        }
        
    }
    @IBAction func otpcall(_ sender: UIButton) {
        OTVCall()
        
    }
    
    
    private func navigateToSuccessVC(){
           
           let prepaidSuccessVC = self.storyboard!.instantiateViewController(withIdentifier: "PrepaidTopUpSuccessfulVC") as! PrepaidTopUpSuccessfulVC
       
           prepaidSuccessVC.companyName = self.companyName
           prepaidSuccessVC.mobileNumber = self.utilityConsumerNo
           prepaidSuccessVC.transferAmount = self.amountPaid
        prepaidSuccessVC.transTime = self.successmodelobj?.data?.transDate
        prepaidSuccessVC.otpReq = fundsInitiateObj?.oTPREQ
        prepaidSuccessVC.transRefNumber = self.successmodelobj?.data?.authIdResponse
//
           self.navigationController!.pushViewController(prepaidSuccessVC, animated: true)
     
    
    }
    // MARK: - UITextfield Delegate Methods
             
             func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                 
                 let newLength = (textField.text?.count)! + string.count - range.length
                 
                 if textField == mobileTextField{
                     return newLength <= 11
                 }
                 else {
                     return newLength <= 16
                 }

             }

    @IBAction func lasttrasactionaction(_ sender: UIButton) {
        self.Lasttransactions()
        
        
    }
    
    @IBAction func okaction(_ sender: UIButton) {
        blurview.isHidden = true
        
    }
    
    
    // MARK: - Action Methods
      @IBAction func payNowPressed(_ sender: Any) {
        
        if self.oTPREQ == "Y"{
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

         self.payTopUp()
      }
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
    
    override func viewWillAppear(_ animated: Bool) {
        tablleview.reloadData()
    }
    
    // MARK: - API CALL
     func getdata()
     {
        phonenolbl.text = DataManager.instance.mobile_number
        accountnolbl.text = DataManager.instance.accountNo
     }
    private func payTopUp() {
        
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
        
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","utilityBillCompany":self.utilityBillCompany!,"beneficiaryAccountTitle":self.nickNameTextField.text!,"utilityConsumerNo":self.utilityConsumerNo!,"accountType" : DataManager.instance.accountType!,"amountPaid":self.amountPaid!,"beneficiaryName":self.nickNameTextField.text!,"beneficiaryMobile":self.mobileTextField.text!,"beneficiaryEmail":self.emailTextField.text!,"otp":self.otpTextField.text!,"addBeneficiary":self.addBeneValue,"utilityBillCompanyId":self.utilityBillCompanyId!] as [String : Any]
      
     
        
        
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
            
             self.successmodelobj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.successmodelobj?.responsecode == 2 || self.successmodelobj?.responsecode == 1 {
                    
                    self.navigateToSuccessVC()
                   
//                    self.tablleview?.reloadData()
                }
                else {
                    if let message = self.successmodelobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                        self.navigateToSuccessVC()
                    }
                }
            }
            else {
                if let message = self.successmodelobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
//    --------------
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
      
      let parameters = ["accountNo":"\(DataManager.instance.accountNo!)","imei": DataManager.instance.imei,"channelId":"\(DataManager.instance.channelID)","transactionType" : "IBFT" ,"cnic":userCnic]
      
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
                getdata()
                tablleview.delegate = self
                tablleview.dataSource = self
                tablleview.reloadData()
  //                self.showDefaultAlert(title: "", message: self.responseobj!.messages!)
                  
              }
              else {
                  if let message = self.responseobj?.messages {
                    UtilManager.showAlertMessage(message: (responseobj?.messages)!, viewController: self)
//                      self.showAlert(title: "", message: message, completion: nil)
                  }
              }
          }
          else {
              if let message = self.responseobj?.messages {
                UtilManager.showAlertMessage(message: (responseobj?.messages)!, viewController: self)
//                  self.showAlert(title: "", message: message, completion: nil)
              }
  //                print(response.result.value)
  //                print(response.response?.statusCode)
              
          }
      }
  }
    func loadtrasanctiondata()
    {
        var tempobj = transactionlist()
        
        tempobj.amount = (responseobj?.data?[0].amount)!
        tempobj.transactionDate = (responseobj?.data?[0].transactionDate)!
        myarr.append(tempobj)
    }
    
}


extension PrePaidTopUpConfirmationVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
    return responseobj?.data?.count ?? 0


        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tablleview.dequeueReusableCell(withIdentifier: "PreTopUpCell") as!   PreTopUpCell

        let aRequest =  self.responseobj?.data?[indexPath.row]

        aCell.datelbl.text = aRequest?.transactionDate ?? ""
        let a =  (Int((aRequest?.amount!)!))
   
        aCell.curencylbl.text =    "\("PKR.")\(a)"
        aCell.viewcell.dropShadow1()
        return aCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//}
}
class transactionlist
{
    var transactionDate = ""
    var amount = 0
}
