//
//  UbilityBillPaymentListVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 17/01/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS

class UbilityBillPaymentListVC: BaseClassVC, UITextFieldDelegate {
    
    private let contactPicker = CNContactPickerViewController()
 
    @IBOutlet weak var lblSeelctCompany: UILabel!
    @IBOutlet weak var lblConsumerNo: UILabel!
    @IBOutlet weak var buttonContacts: UIButton!
    @IBOutlet weak var MainTitle: UILabel!
    var fundsInitiateObj : FundInitiateModel?
    var transactionApiResponseObj : FTApiResponse?
    var isFromDonations:Bool = false
    var reasonsObj : GetReasonsModel?
    var reasonsList = [ReasonsData]()
    var arrReasonsList : [String]?
    @IBOutlet var dropDownAccounts: UIDropDown!
    var billCompanyListObj : UtilityBillCompaniesModel?
    var arrCompaniesList : [String]?
    var sourceCompany: String?
    var consumerNumber : String?
    var companyID : String?
    var mainTitle : String?
    var parentCompanyID : Int?
    var comapniesList = [SingleCompanyList]()
    @IBOutlet weak var viewBottomButtons: UIView!
    @IBOutlet weak var viewSelectAccount: UIView!
    @IBOutlet weak var consumerNumberTextField: UITextField!
    var billPaymentInquiryObj: BillAPiResponse?
    var companyCode: Int?
    var utilityBillCompany: String?
    var isFromQuickPay:Bool = false
    var isFromHome:Bool = false
    var isFromGov:Bool = false
    @IBOutlet var lblMainTitle : UILabel!
    var companiesTitle : String?
    var billtransactionOBj : BillAPiResponse?
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    func ChangeLanguage()
    {
        MainTitle.text = "Utility Bill Payment".addLocalizableString(languageCode: languageCode)
        lblConsumerNo.text = "Consumer Number".addLocalizableString(languageCode: languageCode)
        
        lblSeelctCompany.text = "Select Company".addLocalizableString(languageCode: languageCode)
        btnSubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal
        )
        btnCancel.setTitle("Cancel".addLocalizableString(languageCode: languageCode), for: .normal)
        consumerNumberTextField.placeholder = "Enter Consumer Number".addLocalizableString(languageCode: languageCode)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        consumerNumberTextField.delegate = self
        if self.isFromQuickPay == true{
            self.consumerNumberTextField.isUserInteractionEnabled = false
            self.updateUI()
        }
        if self.isFromHome == true{
            self.getCompanies()
        }
        if self.isFromGov == true{
            self.dropDownAccounts.isHidden = true
            self.viewSelectAccount.isHidden = true
        }
      
        self.hideKeyboardWhenTappedAround()
        
        if let titleText = companiesTitle{
            self.lblMainTitle.text = titleText
        }
        if companyID != "MBP"{
            self.buttonContacts.isHidden = true
        }
       
//        print(companyID)
//        print(mainTitle)
//        print(consumerNumber)
//        print(companyCode)
//        print(isFromQuickPay)


    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.viewBottomButtons.frame.origin.y) + (self.viewBottomButtons.frame.size.height) + 50)
    }
    
    
    // MARK: - Utility Methods
    
    
    private func updateUI(){
        
        
        if let companyId = self.mainTitle{
            methodDropDownAccounts(Companies: [companyId])
        }
        if let cosumerNo = consumerNumber {
             self.consumerNumberTextField.text = cosumerNo
        }
        if let mainTitle = self.companiesTitle {
            self.lblMainTitle.text = mainTitle
        }
        
    }
    
    private func navigateToDetailsVC(code:String){
        
        if let imdComp = self.billtransactionOBj?.data?.utilityCompanyId{
            
            
        if imdComp == "CC01BILL" || imdComp == "IN01BILL" || imdComp == "TP01BILL" || imdComp == "CAREEM01"{
            
            let utilityBillPayOneBillConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentOneBillVC") as! UtilityBillPaymentOneBillVC
            
            if isFromQuickPay {
                utilityBillPayOneBillConfirmVC.companyName = self.mainTitle
            }
            else {
                utilityBillPayOneBillConfirmVC.companyName = self.sourceCompany
            }
            utilityBillPayOneBillConfirmVC.accountTitle = self.billtransactionOBj?.data?.subscriberName
            utilityBillPayOneBillConfirmVC.dueDate = self.billtransactionOBj?.data?.paymentDueDate
            utilityBillPayOneBillConfirmVC.totalAmountl = self.billtransactionOBj?.data?.totalAmountPayableWithinDueDate
            utilityBillPayOneBillConfirmVC.paidAmount = self.billtransactionOBj?.data?.actualDueAmount
//            utilityBillPayOneBillConfirmVC.remainingAmount = self.billPaymentInquiryObj?.data?.remainingAmount
            utilityBillPayOneBillConfirmVC.amountAfterDD = self.billtransactionOBj?.data?.totalAmountPayableAfterDueDate
//            utilityBillPayOneBillConfirmVC.remAmountAftrDD = self.billPaymentInquiryObj?.data?.remAmountAftrDD
            utilityBillPayOneBillConfirmVC.status = self.billtransactionOBj?.data?.billStatus
            utilityBillPayOneBillConfirmVC.companyName = self.sourceCompany
            utilityBillPayOneBillConfirmVC.utilityBillCompany = self.billtransactionOBj?.data?.utilityCompanyId
            utilityBillPayOneBillConfirmVC.otpReq = self.billtransactionOBj?.data?.oTPREQ
            utilityBillPayOneBillConfirmVC.utilityConsumerNo = self.consumerNumberTextField.text!
            utilityBillPayOneBillConfirmVC.utilityCompanyID = self.billtransactionOBj?.data?.utilityCompanyId
            utilityBillPayOneBillConfirmVC.utilityBillCompanyId = "\(self.companyCode ?? 0)"
//            if(self.transactionApiResponseObj?.data?.lastTransactions) != nil
//
//            {
//                utilityBillPayOneBillConfirmVC.lsttrsc = transactionApiResponseObj?.data?.lastTransactions
//            }
               
            print(utilityBillPayOneBillConfirmVC.accountTitle)
             print("duedate",utilityBillPayOneBillConfirmVC.dueDate)
             print(utilityBillPayOneBillConfirmVC.totalAmountl)
             print(utilityBillPayOneBillConfirmVC.paidAmount)
             print(utilityBillPayOneBillConfirmVC.remainingAmount)
             print(utilityBillPayOneBillConfirmVC.amountAfterDD)
             print(utilityBillPayOneBillConfirmVC.remAmountAftrDD)
             print(utilityBillPayOneBillConfirmVC.status)
             print(utilityBillPayOneBillConfirmVC.companyName)
             print(utilityBillPayOneBillConfirmVC.utilityBillCompany)
             print(utilityBillPayOneBillConfirmVC.otpReq)
            print(utilityBillPayOneBillConfirmVC.utilityConsumerNo)
             print(utilityBillPayOneBillConfirmVC.utilityCompanyID)
            print(utilityBillPayOneBillConfirmVC.utilityBillCompanyId)
            
            
            self.navigationController!.pushViewController(utilityBillPayOneBillConfirmVC, animated: true)
        }
        else{
            
            let utilityBillPayConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "UtilityBillPaymentConfirmationVC") as! UtilityBillPaymentConfirmationVC
            
            utilityBillPayConfirmVC.accountTitle = self.billtransactionOBj?.data?.subscriberName?.trimmingCharacters(in: .whitespacesAndNewlines)
            utilityBillPayConfirmVC.dueDate = self.billtransactionOBj?.data?.paymentDueDate
            print("duedate", self.billtransactionOBj?.data?.paymentDueDate)
            utilityBillPayConfirmVC.totalAmountl = self.billtransactionOBj?.data?.totalAmountPayableWithinDueDate
            utilityBillPayConfirmVC.paidAmount = self.billtransactionOBj?.data?.actualDueAmount
//            utilityBillPayConfirmVC.remainingAmount = self.billPaymentInquiryObj?.data?.remainingAmount
            utilityBillPayConfirmVC.amountAfterDD = self.billtransactionOBj?.data?.totalAmountPayableAfterDueDate
//            utilityBillPayConfirmVC.remAmountAftrDD = self.billPaymentInquiryObj?.data?.remAmountAftrDD
            utilityBillPayConfirmVC.status = self.billtransactionOBj?.data?.billStatus
            utilityBillPayConfirmVC.companyName = self.sourceCompany
            utilityBillPayConfirmVC.utilityBillCompany = self.billtransactionOBj?.data?.utilityCompanyId
            utilityBillPayConfirmVC.otpReq = self.billtransactionOBj?.data?.oTPREQ
            utilityBillPayConfirmVC.utilityConsumerNo = self.consumerNumberTextField.text!
            utilityBillPayConfirmVC.utilityBillCompanyId = self.companyCode
            

//            if(self.fundsInitiateObj?.lastTransactions) != nil
//            {
//                
//            utilityBillPayConfirmVC.lsttrsc = fundsInitiateObj?.lastTransactions
//            }

                
        
//            utilityBillPayConfirmVC.trasactionamount = fundsInitiateObj?.lastTransactions?[0].amount
//            utilityBillPayConfirmVC.lsttrsc =
            
            
//             print(utilityBillPayConfirmVC.accountTitle)
//             print(utilityBillPayConfirmVC.dueDate)
//             print(utilityBillPayConfirmVC.totalAmountl)
//             print(utilityBillPayConfirmVC.paidAmount)
//             print(utilityBillPayConfirmVC.remainingAmount) // No
//             print(utilityBillPayConfirmVC.amountAfterDD)
//             print(utilityBillPayConfirmVC.remAmountAftrDD) // No
//             print(utilityBillPayConfirmVC.status)
//             print(utilityBillPayConfirmVC.companyName)
//             print(utilityBillPayConfirmVC.utilityBillCompany)
//             print(utilityBillPayConfirmVC.otpReq)
//             print(utilityBillPayConfirmVC.utilityConsumerNo)
//             print(utilityBillPayConfirmVC.utilityBillCompanyId)
            
            
            
            
            
            self.navigationController!.pushViewController(utilityBillPayConfirmVC, animated: true)
            
        }
    }
        
    }
   
    
    @IBAction func getContactsPressed(_ sender: Any) {
            
            contactPicker.delegate = self
            self.present(contactPicker, animated: true, completion: nil)
        }
    
    
    
    //MARK: - DropDown
    
    private func methodDropDownAccounts(Companies:[String]) {
        
        print("\(companyID)")
        
//        if Companies.contains("CAREEM"){
//            self.dropDownAccounts.tableHeight = 70.0
//        }
//        else{
//            self.dropDownAccounts.tableHeight = 200.0
//        }
        
        if Companies.count > 0 {
            self.dropDownAccounts.tableHeight = CGFloat(Companies.count * 50)
        }
        else{
            self.dropDownAccounts.tableHeight = 20.0
        }
        
        if isFromQuickPay {
            self.dropDownAccounts.placeholder = Companies[0]
        }
        else if Companies.contains("CAREEM"){
            self.dropDownAccounts.placeholder = Companies[0]
            self.sourceCompany = "CAREEM"
            self.dropDownAccounts.isUserInteractionEnabled = false
        }
        else {
             self.dropDownAccounts.placeholder = "Select Company"
        }
//        self.dropDownAccounts.placeholder = "Select Company"
        self.dropDownAccounts.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        self.dropDownAccounts.options = Companies
        self.dropDownAccounts.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.sourceCompany = option
        
        })
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if companyID == "MBP"{
            
            if textField == consumerNumberTextField{
                return newLength <= 11
            }
        }
        else if companyID == "IESCO"{
            if textField == consumerNumberTextField
            {
                return newLength <= 11
            }
            return newLength <= 18
        }
        return newLength <= 18
    }
    
    // MARK: - Action Method
    
    @IBAction func paynowPressed(_ sender: Any) {
        
        let title = self.sourceCompany
        for aCompany in self.comapniesList{
            if aCompany.name == title{
                print(aCompany.name)
                print(aCompany.ubpCompaniesId)
                print(aCompany.code)
                
                self.companyCode = aCompany.ubpCompaniesId
                self.utilityBillCompany = aCompany.code
            }
        }
        
        if isFromQuickPay {
            self.getBillInquiry(utilityBillCompany: self.companyID!)
        }
        else{
            if self.utilityBillCompany == nil{
                self.showToast(title: "Please select company")
                return
            }
            if consumerNumberTextField.text?.count == 0 {
                self.showToast(title: "Please enter consumer number")
                return
            }
            self.getBillInquiry(utilityBillCompany: self.utilityBillCompany!)
            
        }
        
        if self.isFromGov == true {
//            self.getBillInquiry(utilityBillCompany: (self.parentCompanyID))
        }
        
        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: - API CALL
    
    private func getCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return 
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getUbpCompaniesAgainstParentId/\(self.parentCompanyID ?? 0)"
       
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
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
    
    private func getBillInquiry(utilityBillCompany:String?) {
        
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
        
  //      let compelteUrl = GlobalConstants.BASE_URL + "billInquiry"
        let compelteUrl = GlobalConstants.BASE_URL + "v2/billInquiry"
        
        
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"utilityBillCompany":utilityBillCompany!,"utilityConsumerNo":self.consumerNumberTextField.text!,"accountType": DataManager.instance.accountType!]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<BillAPiResponse>) in

            
            self.hideActivityIndicator()
            
            self.billtransactionOBj = response.result.value
            
            
            if response.response?.statusCode == 200 {
             
                if self.billtransactionOBj?.responsecode == 2 || self.billtransactionOBj?.responsecode == 1 {
                  
                    self.navigateToDetailsVC(code: utilityBillCompany!)
                }
                else {
                    if let message = self.billtransactionOBj?.messages{
//                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.billtransactionOBj?.messages{
                    self.showDefaultAlert(title: "Alert", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
}


extension UbilityBillPaymentListVC: CNContactPickerDelegate {

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
