//
//  PostPaidVC.swift
//  First Pay
//
//  Created by Irum Butt on 23/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS
class PostPaidVC: BaseClassVC, UITextFieldDelegate {
    private let contactPicker = CNContactPickerViewController()
    var parentCompanyID : Int?
    var companyID : String?
    var billCompanyObj : BillPaymentCompanies?
    var filteredCompanies = [SingleCompany]()
    var arrCompaniesList : [String]?
    
    var comapniesList = [SingleCompanyList]()
    override func viewDidLoad() {
        tfMobileNo.isUserInteractionEnabled = true
        super.viewDidLoad()
        print("postpaid class on")
        contactPicker.delegate = self
        getBillPaymentCompanies()
        updateUi()
        tfMobileNo.delegate = self
        textFieldOperator.delegate = self
        buttonContactList.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        
        imgnextarrow.addGestureRecognizer(tapGestureRecognizerr)
        tfMobileNo.placeholder = "Enter Number "
        // Do any additional setup after loading the view.
        self.tfMobileNo.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector:#selector(showSelectedDataPostpaid), name: Notification.Name("showSelectedDataPostpaid"),object: nil)
    
    
    NotificationCenter.default.addObserver(self, selector:#selector(removeFieldsPostpaid), name: Notification.Name("removeFieldsPostpaid"),object: nil)
}
    
    

@objc func removeFieldsPostpaid() {
    tfMobileNo.text = ""
    textFieldOperator.text = ""
    changeTextInTextField()
}
    @objc func showSelectedDataPostpaid() {
        textFieldOperator.text = GlobalData.Selected_operator
        if textFieldOperator.text?.count != 0 &&  tfMobileNo.text?.count == 11{
       
            let image = UIImage(named:"]greenarrow")
            imgnextarrow.image = image
            imgnextarrow.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true
        }
        else {
            let image = UIImage(named:"grayArrow")
            imgnextarrow.image = image
            imgnextarrow.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
        }
        
//        if tfMobileNo.text?.count == 11
//        {
//            textFieldOperator.text = GlobalData.Selected_operator
//            let image = UIImage(named:"]greenarrow")
//            imgnextarrow.image = image
//            imgnextarrow.isUserInteractionEnabled = true
//            buttonContinue.isUserInteractionEnabled = true
//        }
//        else
//        {
//            let image = UIImage(named:"grayArrow")
//            imgnextarrow.image = image
//            imgnextarrow.isUserInteractionEnabled = false
//            buttonContinue.isUserInteractionEnabled = false
//
//        }
    }
    func submitButtonEnable() {
        if tfMobileNo.text?.count == 11
        {
            if textFieldOperator.text == "" {
                return
            }
            let image = UIImage(named:"]greenarrow")
            imgnextarrow.image = image
            imgnextarrow.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true
        }
        else
        {
            let image = UIImage(named:"grayArrow")
            imgnextarrow.image = image
            imgnextarrow.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
            
        }
    }
    func updateUi() {
        companyID = billCompanyObj?.companies?[0].code
        parentCompanyID = billCompanyObj?.companies?[0].ubpCompaniesId
        print("u selected postpaid id", companyID)
        print("u selected postpaid code ", parentCompanyID)
        
        
        if self.billCompanyObj?.companies?[0].code ?? "" == "MBP" {
            GlobalData.topup = "Postpaid"
            
        }
        print("Postpaid",  GlobalData.topup)
    }
    @IBAction func textFieldOperator(_ sender: UITextField) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OpreatorSelectionVc") as! OpreatorSelectionVc
        if parentCompanyID == nil
        {
            vc.parentCompanyID = billCompanyObj?.companies?[1].ubpCompaniesId
        }
        else
        {
            vc.parentCompanyID = parentCompanyID
        }
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
//        if TfmobileNumber.text?.count != 0
//        {
//            textFieldOperator.text = GlobalData.Selected_operator
//            let image = UIImage(named:"]greenarrow")
//            imgnextarrow.image = image
//            imgnextarrow.isUserInteractionEnabled = true
//            buttonContinue.isUserInteractionEnabled = true
//        }
//        else
//        {
//            let image = UIImage(named:"grayArrow")
//            imgnextarrow.image = image
//            imgnextarrow.isUserInteractionEnabled = false
//            buttonContinue.isUserInteractionEnabled = false
//        }
        
    }
    
   
    @objc func changeTextInTextField() {
        if tfMobileNo.text?.count  != 11
        {
            let image = UIImage(named:"grayArrow")
            imgnextarrow.image = image
            imgnextarrow.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
        }
        if tfMobileNo.text?.count  == 11 && textFieldOperator.text?.count != 0
        {
            textFieldOperator.text = GlobalData.Selected_operator
            let image = UIImage(named:"]greenarrow")
            imgnextarrow.image = image
            imgnextarrow.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true
        }
        
        
        print("end editing")
    }
    @IBAction func TfmobileNumber(_ sender: UITextField) {
//        if tfMobileNo.text! == "" {
//            return()
//        }
        if parentCompanyID == nil
        {
            topUpParentCompanyID = billCompanyObj?.companies?[1].ubpCompaniesId ?? 0
        }
        else
        {
            topUpParentCompanyID = parentCompanyID ?? 0
        }
        
        GlobalData.topup = "Postpaid"
        NotificationCenter.default.post(name: Notification.Name("showSelectedDataPostpaid"), object: nil)
    }
    
    @IBOutlet weak var textFieldOperator: UITextField!
    @IBOutlet weak var imgnextarrow: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var buttonContactList: UIButton!
    
    @IBOutlet weak var tfMobileNo: UITextField!
    @IBOutlet weak var buttonDropDown: UIButton!
    @IBAction func buttonDropDown(_ sender: UIButton) {
//        if tfMobileNo.text! == "" {
//            return()
//        }
        if parentCompanyID == nil
        {
            topUpParentCompanyID = billCompanyObj?.companies?[1].ubpCompaniesId ?? 0
        }
        else
        {
            topUpParentCompanyID = parentCompanyID ?? 0
        }
        GlobalData.topup = "Postpaid"
        NotificationCenter.default.post(name: Notification.Name("operationSelectionPrepaid"), object: nil)
        
    }
    @IBAction func buttonContactList(_ sender: UIButton) {
       
        self.present(contactPicker, animated: true, completion: nil)
        
    }
    @IBAction func buttonContinue(_ sender: UIButton) {
        GlobalData.topup = "Postpaid"
        
        getBillInquiry(utilityBillCompany: GlobalData.Select_operator_code)
        //                let vc = storyboard?.instantiateViewController(withIdentifier: "TransferAmountVc") as! TransferAmountVc
        //                vc.phoneNumber = TfmobileNumber.text!
        //                self.navigationController?.pushViewController(vc, animated: true)
        //        GlobalData.topup = "Postpaid"
        //        NotificationCenter.default.post(name: Notification.Name("operationSelectionPostpaid"), object: nil)
        
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        GlobalData.topup = "Postpaid"
        
        getBillInquiry(utilityBillCompany: GlobalData.Select_operator_code)
        //                let vc =
        //               self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - API CALL
    
    private func getBillPaymentCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
//        showActivityIndicator()
        self.showActivityIndicator2()

        let compelteUrl = GlobalConstants.BASE_URL +          "Transactions/v1/getParentTopUpCompanies"
        //getcompanyfromparentid
        //biillinquiry
        let header = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<BillPaymentCompanies>) in
            self.hideActivityIndicator2()
//            self.hideActivityIndicator()
            self.billCompanyObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.billCompanyObj?.responsecode == 2 || self.billCompanyObj?.responsecode == 1 {
                    
                    GlobalData.topup = "Postpaid"
                    self.companyID = self.billCompanyObj?.companies?[0].code
                    self.parentCompanyID = self.billCompanyObj?.companies?[0].ubpCompaniesId
                    print("u selected prepaid id", self.companyID)
                    print("u selected prepaidcode ", self.parentCompanyID)
                    
                    //
                    
                }
                else {
                    self.showAlertCustomPopup(title: "",message: self.billCompanyObj?.messages, iconName: .iconError)
                }
            }
            else {
                self.showAlertCustomPopup(title: "",message: self.billCompanyObj?.messages, iconName: .iconError)
                //                print(response.result.value)
                //                print(response.response?.statusCode)
                
                
            }
        }
    }
    var billtransactionOBj : BillAPiResponse?
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
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/billInquiry"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"utilityBillCompany": GlobalData.Select_operator_code,"utilityConsumerNo":self.tfMobileNo.text!,"accountType": DataManager.instance.accountType!]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        //        print(result.apiAttribute1)
        //        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
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
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "POSTPAIDCONFIRMATIONVC") as! POSTPAIDCONFIRMATIONVC
                    vc.phoneNumber = self.tfMobileNo.text!
                    vc.DueDate = self.billtransactionOBj?.data?.paymentDueDate!
                    vc.status = self.billtransactionOBj?.data?.billStatus
                    //                    vc.DueDate = DueDate ?? ""
                    //                    vc.status = status ?? ""
                    let Amount = self.billtransactionOBj?.data?.actualDueAmount
                   if  GlobalData.Select_operator_code == "TELNOR02"
                    {
                         if Amount != nil
                         {
                             vc.amount = Amount
                         }
                         else
                         {
                             vc.amount = "0"
                           
                         }
                   }
                
                 else
                    {
                     vc.amount = Amount
                 }
                   
                    self.present(vc, animated: true)
                    //                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                else {
                    if let message = self.billtransactionOBj?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                    }
                }
            }
            else {
                if let message = self.billtransactionOBj?.messages{
                    self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                }
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == tfMobileNo
        {
            return newLength <= 11
        }
        return newLength <= 11
    }
}
extension PostPaidVC: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count
        //  let name = "\(contact.givenName + contact.familyName)"
        let name = "\(contact.givenName) \(contact.familyName)"
        
        
        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }
        
        if phoneNumberCount > 0 {
//            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)
            self.tfMobileNo.text = contact.phoneNumbers[0].value.stringValue.getIntegerValue()
       var tempMobileNo =  self.tfMobileNo.text?.replacingOccurrences(of: "+92", with: "0")
            var a = tempMobileNo?.substring(to: 2)
            if a == "92"
            {
                tempMobileNo =  tempMobileNo?.replacingOccurrences(of: a!, with: "0")
            }
            
            tempMobileNo =  tempMobileNo?.replacingOccurrences(of: "+92", with: "0")
            self.tfMobileNo.text = tempMobileNo
            self.submitButtonEnable()
        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)
            
            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                    alert -> Void in
//                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
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
            self.tfMobileNo.text = replaceSpaceWithEmptyString(aStr: formattedString)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}
