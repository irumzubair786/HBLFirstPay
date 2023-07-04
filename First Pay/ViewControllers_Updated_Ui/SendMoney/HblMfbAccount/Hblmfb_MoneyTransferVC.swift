//
//  Hblmfb_MoneyTransferVC.swift
//  First Pay
//
//  Created by Irum Butt on 10/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import KYDrawerController
import Alamofire
import ObjectMapper
import MapKit
import ContactsUI
import libPhoneNumber_iOS
import SwiftKeychainWrapper
import SDWebImage
class Hblmfb_MoneyTransferVC: BaseClassVC, UITextFieldDelegate {
  
    var fundsTransSuccessObj: FundsTransferApiResponse?
    var transactionApiResponseObj : FTApiResponse?
    var amount: String?
    var number: String?
    var ToaccountTitle : String?
    var bankname : String?
    var OTPREQ : String?
    var harcodePurpose :String?
    var harcodePurposeCode :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GlobalData.money_Reason",  number)
        back.setTitle("", for: .normal)
//        btn_Next.isUserInteractionEnabled = false
        otpTextField.delegate = self
        btndropdown.setTitle("", for: .normal)
        amountTextField.delegate = self
        lblAlertAmount.textColor = .gray
        linebtn.setTitle("", for: .normal)
        buttonDropDown.setTitle("", for: .normal)
        PurposeTf.text = harcodePurpose
        updateUI()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        img_next_arrow.isUserInteractionEnabled = true
        img_next_arrow.addGestureRecognizer(tapGestureRecognizer)
        
        otpTextField.isHidden = true
        
//        otpView.isHidden = true
        
    
//        lblAlertAmount.isHidden = true
       
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var img_next_arrow: UIImageView!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblAccName: UILabel!
    var minvalu  = 1
    var maxvalu = 10000
    @IBOutlet weak var lblAlertAmount: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var lblMobno: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblReason: UILabel!
   
    @IBOutlet weak var buttonDropDown: UIButton!
    
    @IBOutlet weak var linebtn: UIButton!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var btndropdown: UIButton!
    @IBOutlet weak var bankLogo: UIImageView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var sourceAccountno: UILabel!
    @IBOutlet weak var PurposeTf: UITextField!
    @IBOutlet weak var btn_Next: UIButton!
    @IBAction func Action_back(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
    var comabalanceLimit : String?
    func CommaSepration()
    {
        var number = Double(self.amount!)
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        comabalanceLimit = (formatter.string(from: NSNumber(value: number!)))!
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {

        if isfromBanktoBank == true || isfromOtherLocalBank == true
        {
           
            
            ResendOTP()
//            FundTransferIBFT()
        }
        else
        {
            fundsTransferLocal()
        }
        
    }
    func updateUI()
    {
       
        if GlobalData.moneyTransferReasocCode  == ""
        {
//            GlobalData.moneyTransferReasocCode = "0350"
//            GlobalData.money_Reason = "Miscellaneous Payments"
//            PurposeTf.text = "Miscellaneous Payments"
        }

        CommaSepration()
        if OTPREQ == "N"
        {
            otpTextField.isHidden = true
        }
        
            amountTextField.text = "Rs \(comabalanceLimit!)"
            totalAmount.text = "Rs \(comabalanceLimit!)"
            if  isfromFirstPayWallet == true{
                    lblMobno.text = number!
                    lblname.text = ToaccountTitle!
                sourceAccountno.text = DataManager.instance.accountNo!
                    totalAmount.text = amount!
    //                PurposeTf.text = ""
                lblAccName.text = "FirstPay Wallet"
                bankLogo.image = UIImage(named: "First Pay")
    //            otpView.isHidden = false
            }
            else  if isfromHblMbfAccount == true{
               
                if   GlobalData.moneyTransferReasocCode == ""
                {
                    GlobalData.moneyTransferReasocCode = "0350"
                    GlobalData.money_Reason = "Miscellaneous Payments"
                    PurposeTf.text = "Miscellaneous Payments"

                }
                otpTextField.isHidden = true
                lblMobno.text = number
                lblname.text = ToaccountTitle!
                sourceAccountno.text = DataManager.instance.accountNo!
                lblAccName.text = "HBL MfB Account"
                bankLogo.image = UIImage(named: "HBL Logo")

            }
            else if isfromBanktoBank == true{
                
                
                 if   GlobalData.moneyTransferReasocCode == ""
                 {
                     GlobalData.moneyTransferReasocCode = "0350"
                     GlobalData.money_Reason = "Miscellaneous Payments"
                     PurposeTf.text = "Miscellaneous Payments"

                 }
                lblMobno.text = number!
                lblname.text = ToaccountTitle!
                sourceAccountno.text = DataManager.instance.accountNo!
                totalAmount.text = amount!
    //            PurposeTf.text = GlobalData.money_Reason
        
                lblAccName.text = bankname!
    //            otpView.isHidden = true
                var concateString = "\(GlobalConstants.BASE_URL)\(GlobalData.selected_bank_logo ?? "")"
                let url = URL(string:concateString)
                bankLogo.sd_setImage(with: url)
                
               
              
            }
            else{
                
                 if  GlobalData.moneyTransferReasocCode == ""
                 {
                     GlobalData.moneyTransferReasocCode = "0350"
                     GlobalData.money_Reason = "Miscellaneous Payments"
                     PurposeTf.text = "Miscellaneous Payments"

                 }
                lblMobno.text = number
                lblname.text = ToaccountTitle
                sourceAccountno.text = DataManager.instance.accountNo!
                totalAmount.text = amount
    //            PurposeTf.text = GlobalData.money_Reason
                
                lblAccName.text = bankname
    //            otpView.isHidden = true
                var concateString = "\(GlobalConstants.BASE_URL)\(GlobalData.selected_bank_logo ?? "")"
                let url = URL(string:concateString)
                bankLogo.sd_setImage(with: url)
               
            }
        }
    override func viewWillAppear(_ animated: Bool) {
        if isFromReason == true{
            PurposeTf.text = GlobalData.money_Reason
            if OTPREQ == "N"
            {
                img_next_arrow.image = UIImage(named: "]greenarrow")
             
                btn_Next.isUserInteractionEnabled = true
              
            }
        }
        else{
            
            GlobalData.moneyTransferReasocCode = "0350"
            GlobalData.money_Reason = "Miscellaneous Payments"
            PurposeTf.text = "Miscellaneous Payments"
        }
//        else {
//            PurposeTf.text = ""
//        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == otpTextField
        {
            otpTextField.isUserInteractionEnabled = true
            return newLength <= 4
           
    }
    
        return newLength <= 4
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
            if otpTextField.text?.count == 4
            {
                
                img_next_arrow.image = UIImage(named: "]greenarrow")
             
                btn_Next.isUserInteractionEnabled = true
            }
            else
            {
    //            let image = UIImage(named:"grayArrow")
                img_next_arrow.image = UIImage(named: "grayArrow")
                btn_Next.isUserInteractionEnabled = false
            }
        
        
        
        
    }
 
    @IBOutlet weak var reasonbtn: UIButton!
    @IBAction func ReasonDropdown(_ sender: UIButton) {
         
       let vc = storyboard?.instantiateViewController(withIdentifier: "MoneyTransfer_ReasonVC") as! MoneyTransfer_ReasonVC
//        isfromFirstPayWallet = true
//        isfromHblMbfAccount = false
        self.navigationController?.pushViewController(vc, animated: false)
    
    }
   
    @IBAction func TF_PURPOSE(_ sender: UITextField) {
      let vc = storyboard?.instantiateViewController(withIdentifier: "MoneyTransfer_ReasonVC") as! MoneyTransfer_ReasonVC
//        isfromFirstPayWallet = true
//        isfromHblMbfAccount = false
       self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func Action_Next(_ sender: UIButton) {
        if isfromBanktoBank == true || isfromOtherLocalBank == true
        {
            ResendOTP()
            
//            FundTransferIBFT()
        }
        else
        {
            fundsTransferLocal()
        }
       
    }
    
    private func clearAll(){
        
//        self.lblSourceAccount.text = ""
//        self.lblBeneficaryAccount.text = ""
//        self.lblAccountTitle.text = ""
//        self.lblTransAmount.text = ""
        //        self.lblFee.text = ""
        //        self.lblFed.text = ""
        
    }
    private func fundsTransferLocal() {
        
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
//        if addBeneValue == "N"{
//            self.nickNameTextField.text = ""
//        }
//
        
        showActivityIndicator()
        
        
//        let compelteUrl = GlobalConstants.BASE_URL + "fundsTransferLocal"
//        v2
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/fundsTransferLocal"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"narration":"","cnic":userCnic!,"accountNo":number!,"amount":amount!,"transPurpose":GlobalData.moneyTransferReasocCode,"accountTitle":ToaccountTitle!,"beneficiaryName":"","beneficiaryMobile":
            "","beneficiaryEmail":"","addBeneficiary":"N","otp":otpTextField.text ?? "","requestMoneyId":requestMoneyId!,"accountType":DataManager.instance.accountType!] as [String : Any]
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<FundsTransferApiResponse>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.fundsTransSuccessObj = Mapper<FundsTransferApiResponse>().map(JSONObject: json)
//            self.fundsTransSuccessObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.fundsTransSuccessObj?.responsecode == 2 || self.fundsTransSuccessObj?.responsecode == 1 {
                    self.movetonext()
                }
                else {
                    if let message = self.fundsTransSuccessObj?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .FailedTransaction)
//                        self.showToast(title: message)
                        
                    }
                }
            }
            else {
                if let message = self.fundsTransSuccessObj?.messages{
                    self.showAlertCustomPopup(title: "", message: message, iconName: .FailedTransaction)
                }
//                print(response.result.value)
//
                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    func  VerifyOTPForTransaction()
    {
        if isfromBanktoBank == true
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "OTPVerificationTransactionVC") as! OTPVerificationTransactionVC
            vc.number = number!
            vc.ToaccountTitle = ToaccountTitle!
            isfromBanktoBank = true
            isfromOtherLocalBank = false
            vc.amount = amount!
             self.navigationController?.pushViewController(vc, animated: false)
        }
        else
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "OTPVerificationTransactionVC") as! OTPVerificationTransactionVC
            isfromBanktoBank = false
            isfromOtherLocalBank = true
            vc.number = number!
            vc.ToaccountTitle = ToaccountTitle!
            vc.amount = amount!
             self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    
    
    
    func movetonext()
    {
//        if otpTextField?.text?.count != 0
//        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Hblmfb_MoneyTransfer_SuccessfullVC") as! Hblmfb_MoneyTransfer_SuccessfullVC
            vc.amount = Double(amount!)
            vc.TransactionId = fundsTransSuccessObj?.data?.authIdResponse
            vc.TransactionDate = fundsTransSuccessObj?.data?.transDate
       if  isfromFirstPayWallet == true
        {
           vc.number = self.number!
        }
        else
        {
            var merge = "\(ToaccountTitle!)\(number!)"
            print("other wallet bank name", merge)
            vc.number = merge

        }
        vc.Toaccounttitle = ToaccountTitle
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
   
    func ResendOTP() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()

        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v2/getOtpOrOtv"
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["mobileNo":"","otpType":GlobalOTPTypes.OTP_IBFT ?? "","channelId":"\(DataManager.instance.channelID ?? "")", "cnic" : userCnic!, "otpSendType" : "OTP" ?? ""]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        //        print(result.apiAttribute1)
        //        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.AuthToken ?? "nil")"]
        //
                print(parameters)
                print(compelteUrl)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<GenericResponse>) in

            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<VerifyOTP>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.genRespBaseObj = Mapper<GenericResponse>().map(JSONObject: json)
            
//            self.genRespBaseObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genRespBaseObj?.responsecode == 2 || self.genRespBaseObj?.responsecode == 1 {
                   
                    self.VerifyOTPForTransaction()
                    
                }
                else {
                    if let message = self.genRespBaseObj?.messages {
                        self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                        
                    }
                }
            }
            else {
                if let message = self.genRespBaseObj?.messages {
                    self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                }
                //                print(response.result.value)
                //                print(response.response?.statusCode)
                
            }
        }
    }
    
 
    
}
