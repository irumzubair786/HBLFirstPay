//
//  PrepaidTopUpVC.swift

//
//  Created by Syed Uzair Ahmed on 11/12/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
// 

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS

class PrepaidTopUpVC: BaseClassVC , UITextFieldDelegate{
    var fundsInitiateObj : FundInitiateModel?
    var arrReasonsList : [String]?
    var reasonsObj : GetReasonsModel?
    
    @IBOutlet var dropDownAccounts: UIDropDown!
    @IBOutlet weak var consumerNumberTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    var mainTitle : String?
    var companyID : String?
    var arrCompaniesList : [String]?
    var billCompanyListObj : UtilityBillCompaniesModel?
    var comapniesList = [SingleCompanyList]()
    var sourceCompany: String?
    var companyCode: Int?
    var billPaymentInquiryObj: UtilityBillPaymentUserDetailsModel?
    var isFromHome:Bool = false
    var isFromQuickPay:Bool = false
    var consumerNumber : String?
    var parentCompanyID : Int?
    var transactionApiResponseObj : FTApiResponse?
    var fundsTransSuccessObj: TopUpApiResponse?
    var lastTransactionsArray = [LastTransactionsResponse]()
    var utilityBillCompany: String?
    var utilityBillCompanyName: String?
    var oTPREQ: String?
    private let contactPicker = CNContactPickerViewController()
    var otpReq: String?

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblselectCompany: UILabel!
    
    @IBOutlet weak var btnCancl: UIButton!
    @IBOutlet weak var lblEnterAmount: UILabel!
    @IBOutlet weak var lblMOBILENO: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Converlanguage()
        if isFromQuickPay{
            self.consumerNumberTextField.isUserInteractionEnabled = false
            self.updateUI()
        }
        
        
        
        func Converlanguage()
        {
            lblMainTitle.text = "Prepaid TOPUP".addLocalizableString(languageCode: languageCode)
            lblselectCompany.text = "Select Company".addLocalizableString(languageCode: languageCode)
            lblMOBILENO.text = "Mobile Number".addLocalizableString(languageCode: languageCode)
            consumerNumberTextField.placeholder = "Enter Consumer Number".addLocalizableString(languageCode: languageCode)
            amountTextField.placeholder = "Enter Amount".addLocalizableString(languageCode: languageCode)
            btnCancl.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
            lblEnterAmount.text = "Enter Amount".addLocalizableString(languageCode: languageCode)
            btnSubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
            
        }
        self.getCompanies()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Utility Methods
    
    private func updateUI(){
        if let beneCompany = self.mainTitle{
            methodDropDownAccounts(Companies: [beneCompany])
        }
        if let receiver = self.consumerNumber{
            self.consumerNumberTextField.text = receiver
        }
        if let company = self.mainTitle{
            self.sourceCompany = company
        }
    }
//    var mytamp : [load_data] = []
//    func loaddata(){
//        mytamp.removeAll()
//        for each in fundsInitiateObj!.lastTransactions!
//        {
//            let temp = load_data()
//            temp.date = each.transactionDate ?? ""
//            temp.amount = each.amount ?? -1
//            mytamp.append(temp)
////
//        }
//    }
   
    private func navigateToConfirmationVC(){
       
        let prePaidConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "PrePaidTopUpConfirmationVC") as! PrePaidTopUpConfirmationVC
        
        if let utilityBillCom = self.utilityBillCompany{
            prePaidConfirmVC.utilityBillCompany = utilityBillCom
        }
        if let utilityConNum = self.consumerNumberTextField.text{
            prePaidConfirmVC.utilityConsumerNo = utilityConNum
        }
        if let amount = self.amountTextField.text{
            prePaidConfirmVC.amountPaid = amount
        }
        if let companyName = self.utilityBillCompanyName{
            prePaidConfirmVC.companyName = companyName
        }
//        if let otpRequired = self.oTPREQ{
//            prePaidConfirmVC.oTPREQ = otpRequired
//        }
        prePaidConfirmVC.otpReq = self.fundsTransSuccessObj?.data?.oTPREQ
        if let uBillId = self.companyCode{
            prePaidConfirmVC.utilityBillCompanyId = uBillId
        }
//        if (self.fundsTransSuccessObj?.data?.lastTransactions) != nil
//        {
////
//            prePaidConfirmVC.lsttrsc = fundsTransSuccessObj?.data?.lastTransactions
//        
//            
//        }
        

      self.navigationController!.pushViewController(prePaidConfirmVC, animated: true)
    }
    
    //MARK: - UITextField Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == consumerNumberTextField{
            return newLength <= 11
        }
        else {
            return newLength <= 16
        }
    }
    
    //MARK: - DropDown
        
        private func methodDropDownAccounts(Companies:[String]) {
            
  //          if isFromQuickPay {
  //              self.dropDownAccounts.placeholder = Companies[0]
  //          }
  //          else {
  //              self.dropDownAccounts.placeholder = "Select Company"
  //          }
            self.dropDownAccounts.placeholder = "Select Company".addLocalizableString(languageCode: languageCode)
            self.dropDownAccounts.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
            self.dropDownAccounts.options = Companies
            self.dropDownAccounts.tableHeight = 200.0
            self.dropDownAccounts.didSelect(completion: {
                (option , index) in
                print("You Just select: \(option) at index: \(index)")
                self.sourceCompany = option
                
            })
        }
    
        // MARK: - Action Method
        
        @IBAction func paynowPressed(_ sender: Any) {
            
            let title = self.sourceCompany
            for aCompany in self.comapniesList {
                if aCompany.name == title {
                    //ibftFundConfirmVC.singleBank = aBank
                    print(aCompany.name!)
                    print(aCompany.code!)
                    self.companyCode = aCompany.ubpCompaniesId!
                    self.utilityBillCompany = aCompany.code
                    self.utilityBillCompanyName = aCompany.name
                }
            }
            if self.companyCode == nil{
                self.showDefaultAlert(title: "Alert", message: "Kindly select company")
                return
            }
            if consumerNumberTextField.text == nil || self.consumerNumberTextField.text == ""{
                self.showDefaultAlert(title: "Alert", message: "Kindly enter mobile number")
                return
            }
            if self.amountTextField.text == nil || self.amountTextField.text == ""{
                self.showDefaultAlert(title: "Alert", message: "Kindly enter amount")
                return
            }
            if Double(amountTextField.text!)! < 100 || Double(amountTextField.text!)! > 1500 || self.amountTextField.text == nil{
                self.showDefaultAlert(title: "Alert", message: "Kindly enter amount between 100-1500")
                return
            }
    //        if let balanceValue = DataManager.instance.currentBalance {
    //            if (amountTextField.text)! > String(Float(balanceValue)!) {
    //                self.showDefaultAlert(title: "Alert", message: "Amount Exceed")
    //                return
    //            }
    //        }
//            if isFromQuickPay {
//                self.getBillInquiry(code: self.companyCode!)
//            }
       //     self.getBillInquiry(code: self.companyCode!)
            self.initiateTopUp()
            
            
        }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func getContactsPressed(_ sender: Any) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    // MARK: - API CALL
    
    private func getCompanies() {
       
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getUbpCompaniesAgainstParentId/\(self.parentCompanyID ?? 0)"
       // let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.clientSecretUbps)"]
        let header = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<UtilityBillCompaniesModel>) in
            
            
            self.hideActivityIndicator()
            
            self.billCompanyListObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.billCompanyListObj?.responsecode == 2 || self.billCompanyListObj?.responsecode == 1 {
                    if let companies = self.billCompanyListObj?.companies {
                        self.comapniesList = companies
                    }
                    self.arrCompaniesList = self.billCompanyListObj?.stringCompaniesList
                    self.methodDropDownAccounts(Companies: (self.arrCompaniesList)!)
                    
                }
                else {
                    if let message = self.billCompanyListObj?.messages{
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    private func initiateTopUp() {
        
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
        
        
//        let compelteUrl = GlobalConstants.BASE_URL + "topUp"
        let compelteUrl = GlobalConstants.BASE_URL + "v2/topUp"
        
       
        
        let parameters = ["lat":"\(DataManager.instance.Latitude)","lng":"\(DataManager.instance.Longitude)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"utilityBillCompany":utilityBillCompany!,"utilityConsumerNo":self.consumerNumberTextField.text!, "accountType": DataManager.instance.accountType!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
                NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<TopUpApiResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.fundsTransSuccessObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.fundsTransSuccessObj?.responsecode == 2 || self.fundsTransSuccessObj?.responsecode == 1 {
                    self.navigateToConfirmationVC()
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
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
}

extension PrepaidTopUpVC: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count

        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }

        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)

        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)

            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            alert -> Void in

            })
            alertController.addAction(cancelAction)

            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func setNumberFromContact(contactNumber: String) {

        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER

        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        
        

        
        let phoneUtil = NBPhoneNumberUtil()

          do {
            
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(contactNumber, defaultRegion: "PK")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .NATIONAL)

            print("Formatted String : \(formattedString)")
            self.consumerNumberTextField.text = replaceSpaceWithEmptyString(aStr: formattedString)
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}
