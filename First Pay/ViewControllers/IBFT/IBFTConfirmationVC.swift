//
//  IBFTConfirmationVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 26/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class IBFTConfirmationVC: BaseClassVC{
    
   var mainTitle = ""
    var myarr : [transaction] = []
    var reasonsObj : GetReasonsModel?
    var reasonsList = [ReasonsData]()
    var responseobj : TransactionResponse?
    var arrReasonsList : [String]?
//    var fundsInitiateObj : FundInitiateModel?
    @IBOutlet weak var lblSourceAccount: UILabel!
    @IBOutlet weak var lblSourceAccountTitle: UILabel!
    @IBOutlet weak var lblBeneficaryAccount: UILabel!
    @IBOutlet weak var lblBeneficaryBankName: UILabel!
    @IBOutlet weak var lblAccountTitle: UILabel!
    @IBOutlet weak var lblTransAmount: UILabel!
    @IBOutlet weak var lblEnterOtp: UILabel!
    @IBOutlet weak var blurview: UIVisualEffectView!
    @IBOutlet weak var outerview: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var phoneno: UILabel!
    @IBOutlet weak var accountno: UILabel!
    var sourceAccount:String?
    var beneficaryAccount:String?
    var beneficaryBankName:String?
    var transferAmount:String?
    var accountTitle: String?
    var transPurposeCode: String?
    var transPurpose: String?
    var otpReq: String?
    var accountImd : String?
    var beneIban : String?
    var accounttypes : String?
    var lsttrsc : [lasttransactionupdated]?
    var trasctionamount : Int?
   
    @IBOutlet weak var lblMainTitle: UILabel!
    
    @IBOutlet weak var btnpay: UIButton!
    @IBOutlet weak var btnlsttr: UIButton!
    var fundsTransSuccessObj: FundsTransferApiResponse?
    
    @IBOutlet weak var btncancel: UIButton!
    @IBOutlet  var otpTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLangugae()
        tableview.rowHeight = 100
        blurview.isHidden = true
    
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
       

        // Do any additional setup after loading the view.
    }
    func ChangeLangugae()
    {
//        lblMainTitle.text = "IBFT Confirmation".addLocalizableString(languageCode: languageCode)
        btnlsttr.setTitle("Last Transaction".addLocalizableString(languageCode: languageCode), for: .normal)
        btncancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnpay.setTitle("PAY".addLocalizableString(languageCode: languageCode), for: .normal)
        
    }
    // MARK: - Utility Methods
    
    private func clearAll(){
        
        self.lblSourceAccount.text = ""
        self.lblBeneficaryAccount.text = ""
        self.lblAccountTitle.text = ""
        self.lblTransAmount.text = ""
        
    }
    
    private func updateUI(){
        if isFromDonations == true{
            lblMainTitle.text = mainTitle
        }
        else
        {
            lblMainTitle.text = "IBFT Confirmation".addLocalizableString(languageCode: languageCode)
        }
        if let account = sourceAccount{
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
        }
        if let beneBankName = beneficaryBankName{
            self.lblBeneficaryBankName.text = beneBankName
        }
    }
    
    // MARK: - Action Methods
    
    
    @IBAction func lasttranscations(_ sender: UIButton) {
        self.Lasttransactions()
       
        
        
    }
    
    
    @IBAction func okactions(_ sender: UIButton) {
        blurview.isHidden = true
        self.blurview.alpha = 0
        
    }
    func assignvalue()
    {
        phoneno.text = DataManager.instance.accountNo
        
        
    }

    
    @IBAction func payNowPressed(_ sender: Any) {
        if self.otpReq == "Y"{
                   if otpTextField.text?.count == 0 {
                       self.showToast(title: "Please Enter OTP")
                       return
                   }
               }
        self.initiateIBFundTrasnfer()
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }

    private func navigateToDetailsVC(){
        let ibftSuccessDetailsVC = self.storyboard!.instantiateViewController(withIdentifier: "IBFTSuccessVC") as! IBFTSuccessVC

        ibftSuccessDetailsVC.sourceAccount = DataManager.instance.accountNo
        ibftSuccessDetailsVC.beneficaryAccount = self.beneficaryAccount
        ibftSuccessDetailsVC.beneficaryAccountTitle = self.accountTitle!
        ibftSuccessDetailsVC.transferAmount = self.transferAmount
        ibftSuccessDetailsVC.TransRefNumber =  self.fundsTransSuccessObj?.data?.authIdResponse
        ibftSuccessDetailsVC.beneficaryBank = self.beneficaryBankName
        ibftSuccessDetailsVC.purposeTrans = self.transPurpose
        if isFromDonations == true
        {
            ibftSuccessDetailsVC.mainTitle = "Donations".addLocalizableString(languageCode: languageCode)
        }
       
        ibftSuccessDetailsVC.TransTime =  self.fundsTransSuccessObj?.data?.transDate
        self.navigationController!.pushViewController(ibftSuccessDetailsVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    // MARK: - API CALL
    
    private func initiateIBFundTrasnfer() {

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


//        let compelteUrl = GlobalConstants.BASE_URL + "fundsTransferIbft"
        let compelteUrl = GlobalConstants.BASE_URL + "v2/fundsTransferIbft"

//
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"accountNo":self.beneficaryAccount!,"accountIMD":self.accountImd!,"amount":self.transferAmount!,"transPurpose":self.transPurposeCode!,"accountTitle":self.accountTitle!,"benificiaryIBAN":beneIban!,"otp":self.otpTextField.text!,"accountType":DataManager.instance.accountType!]
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
                        self.showDefaultAlert(title: "", message: "\(message) \(self.fundsTransSuccessObj?.data?.responseCode ?? 90)  \(self.fundsTransSuccessObj?.data?.responseDescr ?? "") ")
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
//  --------------
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
    
        let parameters = ["accountNo":"\(DataManager.instance.accountNo!)","imei": DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","transactionType" : "IBFT" ,"cnic":userCnic!]
    
    let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
    
    print(result.apiAttribute1)
    print(result.apiAttribute2)
    
    let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//    let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
    
    print(params)
    print(compelteUrl)
    print(parameters)
    
    NetworkManager.sharedInstance.enableCertificatePinning()
    
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<TransactionResponse>) in
        
        
        self.hideActivityIndicator()
        
        self.responseobj = response.result.value
        
        if response.response?.statusCode == 200 {
            if self.responseobj?.responsecode == 2 || self.responseobj?.responsecode == 1 {
                blurview.isHidden = false
                outerview.dropShadow1()
                self.assignvalue()
                tableview.delegate = self
                tableview.dataSource = self
                tableview.reloadData()
                
                //                self.showDefaultAlert(title: "", message: self.responseobj!.messages!)
                
            }
            else {
                
                if let message = self.responseobj?.messages {
                    UtilManager.showAlertMessage(message: (responseobj?.messages)!, viewController: self)
                    
//                    self.showAlert(title: "", message: message, completion: nil)
                }
            }
        }
        else {
            if let message = self.responseobj?.messages {
                UtilManager.showAlertMessage(message: (responseobj?.messages)!, viewController: self)
                
//                self.showAlert(title: "", message: message, completion: nil)
            }
//                print(response.result.value)
//                print(response.response?.statusCode)
            
        }
    }
}
    func loadtrasanctiondata()
    {
        var tempobj = transaction()
        
        tempobj.amount = (responseobj?.data?[0].amount)!
        tempobj.transactionDate = (responseobj?.data?[0].transactionDate)!
        myarr.append(tempobj)
    }

}
extension IBFTConfirmationVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseobj?.data?.count ?? 0
        
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableview.dequeueReusableCell(withIdentifier: "IBFTTransctionCEll") as! IBFTTransctionCEll
        let aRequest = self.responseobj?.data?[indexPath.row]
       
        aCell.datelbl.text = aRequest?.transactionDate ?? ""
        let a =  (Int((aRequest?.amount!)!))
        aCell.rupeelbl.text =    "\("PKR.")\(a)"
        aCell.innerview.dropShadow1()

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
class transaction
{
    var transactionDate = ""
    var amount = 0
}
