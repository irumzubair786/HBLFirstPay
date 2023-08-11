//
//  MobileTopUpVC.swift
//  First Pay
//
//  Created by Irum Butt on 04/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS
class MobileTopUpVC: BaseClassVC, UITextFieldDelegate {
    private let contactPicker = CNContactPickerViewController()
    var flag :Bool = false
    var parentCompanyID : Int?
    var companyID : String?
    var billCompanyObj : BillPaymentCompanies?
    var filteredCompanies = [SingleCompany]()
    var arrCompaniesList : [String]?
    var comapniesList = [SingleCompanyList]()
    var sourceCompany: String?
    var companyCode: Int?
    var DueDate : String?
    var status: String?
    
    
    override func viewDidLoad() {
        
        //        Tf_mobileNumber.text = "03404601050"
        super.viewDidLoad()
        getBillPaymentCompanies()
        
        imgPostpaid.isHidden = true
        Tf_mobileNumber.delegate = self
        btnContinue.isUserInteractionEnabled = false
        btnContactList.setTitle("", for: .normal)
        btndropdown.setTitle("", for: .normal)
        img_next_arrow.isUserInteractionEnabled = false
        Tf_mobileNumber.delegate  = self
        selectOperator.delegate = self
        btnPrepaid.setTitleColor(.black, for: .normal)
        btnPostpaid.setTitleColor(.black, for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        
        img_next_arrow.addGestureRecognizer(tapGestureRecognizerr)
        Tf_mobileNumber.placeholder = "Enter Number of Recipient"
        // Do any additional setup after loading the view.
        self.Tf_mobileNumber.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector:#selector(showSelectedDataPrePaid), name: Notification.Name("showSelectedDataPrePaid"),object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(removeFieldsPrepaid), name: Notification.Name("removeFieldsPrepaid"),object: nil)
    }
    
    @objc func removeFieldsPrepaid() {
        Tf_mobileNumber.text = ""
        selectOperator.text = ""
        changeTextInTextField()
    }
    @objc func showSelectedDataPrePaid() {
        selectOperator.text = GlobalData.Selected_operator
        if selectOperator.text?.count != 0 &&  Tf_mobileNumber.text?.count == 11{
            //            selectOperator.text = GlobalData.Selected_operator
            let image = UIImage(named:"]greenarrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = true
            btnContinue.isUserInteractionEnabled = true
        }
        else {
            let image = UIImage(named:"grayArrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = false
            btnContinue.isUserInteractionEnabled = false
        }
    }
    
    func submitButtonEnable() {
        if Tf_mobileNumber.text?.count == 11 {
            if selectOperator.text == "" {
                return
            }
            let image = UIImage(named:"]greenarrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = true
            btnContinue.isUserInteractionEnabled = true
        }
        else {
            let image = UIImage(named:"grayArrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = false
            btnContinue.isUserInteractionEnabled = false
        }
    }
    
    @objc func changeTextInTextField() {
        if Tf_mobileNumber.text?.count != 11
        {
            let image = UIImage(named:"grayArrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = false
            btnContinue.isUserInteractionEnabled = false
        }
        if Tf_mobileNumber.text?.count == 11 && selectOperator.text?.count != 0
        {
            let image = UIImage(named:"]greenarrow")
            img_next_arrow.image = image
            img_next_arrow.isUserInteractionEnabled = true
            btnContinue.isUserInteractionEnabled = true
        }
        
        print("end editing")
    }
    
    
    @IBOutlet weak var btnPostpaid: UIButton!
    @IBOutlet weak var btnPrepaid: UIButton!
    @IBOutlet weak var imgPostpaid: UIImageView!
    @IBOutlet weak var imgPrepaid: UIImageView!
    @IBOutlet weak var Tf_mobileNumber: UITextField!
    @IBOutlet weak var btnContactList: UIButton!
    @IBOutlet weak var btndropdown: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var img_next_arrow: UIImageView!
    
    @IBOutlet weak var selectOperator: UITextField!
    @IBAction func Action_next(_ sender: Any) {
        //        if GlobalData.topup == "Postpaid"
        //        {
        //
        //                getBillInquiry(utilityBillCompany: GlobalData.Select_operator_code)
        //        }
        //        else
        //        {
        let vc = UIStoryboard.init(name: "TopUp", bundle: nil).instantiateViewController(withIdentifier: "TransferAmountVc") as! TransferAmountVc
        vc.phoneNumber = Tf_mobileNumber.text!
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        //        }
        ////
        //        if GlobalData.topup == "Postpaid"
        //        {
        //            if  GlobalData.Select_operator_id == 43
        //            {
        //                getBillInquiry(utilityBillCompany: GlobalData.Select_operator_code)
        //            }
        //           else
        //            {
        //               let vc = storyboard?.instantiateViewController(withIdentifier: "TransferAmountVc") as! TransferAmountVc
        //               vc.phoneNumber = Tf_mobileNumber.text!
        //               self.present(vc, animated: true)
        ////               self.navigationController?.pushViewController(vc, animated: true)
        //           }
        //        }
        //        else
        //        {
        //         getBillInquiry(utilityBillCompany: GlobalData.Select_operator_code)
        ////
        //        }
        
    }
    
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        if GlobalData.topup == "Postpaid"
        //        {
        //
        //                getBillInquiry(utilityBillCompany: GlobalData.Select_operator_code)
        //        }
        //        else
        //        {
        let vc = UIStoryboard.init(name: "TopUp", bundle: nil).instantiateViewController(withIdentifier: "TransferAmountVc") as! TransferAmountVc
        vc.phoneNumber = Tf_mobileNumber.text!
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        //        }
        
    }
    
    
    
    //
    //        if GlobalData.topup == "Postpaid"
    //        {
    ////            if  GlobalData.Select_operator_id == 43
    ////            {
    //                getBillInquiry(utilityBillCompany: GlobalData.Select_operator_code)
    ////            }
    //
    //           else
    //            {
    //
    //               let vc = UIStoryboard.init(name: "TopUp", bundle: nil).instantiateViewController(withIdentifier: "TransferAmountVc") as! TransferAmountVc
    //               vc.phoneNumber = Tf_mobileNumber.text!
    //               vc.modalPresentationStyle = .overFullScreen
    //               present(vc, animated: true)
    //
    ////               self.navigationController?.pushViewController(vc, animated: true)
    //           }
    //        }
    //        else
    //        {
    //            getBillInquiry(utilityBillCompany: GlobalData.Select_operator_code)
    //
    //        }
    //
    //
    ////        self.present(vc, animated: true)
    //    }
    //
    @IBAction func Action_Operator(_ sender: UIButton) {
        //        if Tf_mobileNumber.text! == "" || Tf_mobileNumber.text?.count ?? 0 < 11 {
        //
        //            if Tf_mobileNumber.text?.count ?? 0 < 11 {
        //
        //            }
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
        GlobalData.topup = "P R E P A I D"
        NotificationCenter.default.post(name: Notification.Name("operationSelectionPrepaid"), object: nil)
        
        
        //<<<<<<< HEAD
        ////        let vc = storyboard?.instantiateViewController(withIdentifier: "OpreatorSelectionVc") as! OpreatorSelectionVc
        ////        if parentCompanyID == nil
        ////        {
        ////            vc.parentCompanyID = billCompanyObj?.companies?[1].ubpCompaniesId
        ////        }
        ////        else
        ////        {
        ////            vc.parentCompanyID = parentCompanyID
        ////        }
        ////        vc.returnData? = {
        ////
        ////        }
        ////        self.present(vc, animated: false)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //        if Tf_mobileNumber.text?.count != 0 && selectOperator.text?.count !=  0
        //        {
        //            selectOperator.text = GlobalData.Selected_operator
        //            let image = UIImage(named:"]greenarrow")
        //            img_next_arrow.image = image
        //            img_next_arrow.isUserInteractionEnabled = true
        //            btnContinue.isUserInteractionEnabled = true
        //        }
        //        else
        //        {
        //            let image = UIImage(named:"grayArrow")
        //            img_next_arrow.image = image
        //            img_next_arrow.isUserInteractionEnabled = false
        //            btnContinue.isUserInteractionEnabled = false
        //        }
        
    }
    
    @IBAction func Action_back(_ sender: UIButton) {
        self.dismiss(animated: true)
        
        //        let  myDict = [ "name": "DashBoardVC"]
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "post"), object: nil, userInfo: myDict)
    }
    
    @IBAction func ShowContactList(_ sender: UIButton) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    @IBAction func ActionPrepaid(_ sender: UIButton) {
        Tf_mobileNumber.placeholder =  "Enter Number of Recipient"
        UIView.transition(with: self.view, duration: 0.3, options: .transitionFlipFromRight, animations: {
            
        }, completion: nil)
        selectOperator.text = ""
        Tf_mobileNumber.text = ""
        imgPostpaid.isHidden = true
        imgPrepaid.isHidden = false
        companyID = billCompanyObj?.companies?[1].code
        parentCompanyID = billCompanyObj?.companies?[1].ubpCompaniesId
        print("u selected prepaid id", companyID)
        print("u selected prepaidcode ", parentCompanyID)
        if (self.billCompanyObj?.companies?[1].code)! != "MBP"
        {
            GlobalData.topup = "P R E P A I D"
        }
        
        print("Prepaid",  GlobalData.topup)
        
        
        
        ////                    self.companyID = self.billCompanyObj?.companies?[0].code
        ////                    self.parentCompanyID = self.billCompanyObj?.companies?[0].ubpCompaniesId
        ////                    print("u selected prepaid id", self.companyID)
        ////                    print("u selected prepaidcode ", self.parentCompanyID)
        
    }
    
    @IBAction func Action_postpaid(_ sender: UIButton) {
        Tf_mobileNumber.placeholder = "Enter Number"
        UIView.transition(with: self.view, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            
        }, completion: nil)
        selectOperator.text = ""
        Tf_mobileNumber.text = ""
        imgPostpaid.isHidden = false
        imgPrepaid.isHidden = true
        companyID = billCompanyObj?.companies?[0].code
        parentCompanyID = billCompanyObj?.companies?[0].ubpCompaniesId
        print("u selected postpaid id", companyID)
        print("u selected postpaid code ", parentCompanyID)
        
        
        if (self.billCompanyObj?.companies?[0].code)! == "MBP"
        {
            GlobalData.topup = "P O S T P A I D"
            
        }
        print("Postpaid",  GlobalData.topup)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == Tf_mobileNumber
        {
            return newLength <= 11
        }
        return newLength <= 11
    }
    
    
    // MARK: - API CALL
    
    private func getBillPaymentCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL +          "Transactions/v2/getParentTopUpCompanies"
        //getcompanyfromparentid
        //biillinquiry
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).response {
            //            (response: DataResponse<BillPaymentCompanies>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            //            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            do{
                let json = try JSONSerialization.jsonObject(with: response.data!, options: [.fragmentsAllowed])
                
                self.billCompanyObj = Mapper<BillPaymentCompanies>().map(JSONObject: json)
            }
            catch let error{
                print("\n\n===========Error===========")
                print("Error Code: \(error._code)")
                print("Error Messsage: \(error.localizedDescription)")
                if let str = String(data: data, encoding: String.Encoding.utf8){
                    print("Print Server data:- " + str)
                }
                debugPrint(error)
                print("===========================\n\n")
                
                debugPrint(error)
            }
            
            //            self.billCompanyObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.billCompanyObj?.responsecode == 2 || self.billCompanyObj?.responsecode == 1 {
                    
                    //                    GlobalData.topup = "Prepaid"
                    ////                    self.companyID = self.billCompanyObj?.companies?[0].code
                    ////                    self.parentCompanyID = self.billCompanyObj?.companies?[0].ubpCompaniesId
                    ////                    print("u selected prepaid id", self.companyID)
                    ////                    print("u selected prepaidcode ", self.parentCompanyID)
                    
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
        //        v2
//        change here
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v2/billInquiry"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"utilityBillCompany": GlobalData.Select_operator_code,"utilityConsumerNo":self.Tf_mobileNumber.text!,"accountType": DataManager.instance.accountType!]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        //        print(result.apiAttribute1)
        //        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //            (response: DataResponse<BillAPiResponse>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.billtransactionOBj = Mapper<BillAPiResponse>().map(JSONObject: json)
            
            //            self.billtransactionOBj = response.result.value
            if response.response?.statusCode == 200 {
                if self.billtransactionOBj?.responsecode == 2 || self.billtransactionOBj?.responsecode == 1 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "POSTPAIDCONFIRMATIONVC") as! POSTPAIDCONFIRMATIONVC
                    vc.phoneNumber = self.Tf_mobileNumber.text!
                    vc.DueDate = self.billtransactionOBj?.data?.paymentDueDate!
                    vc.status = self.billtransactionOBj?.data?.billStatus
                    //                    vc.DueDate = DueDate ?? ""
                    //                    vc.status = status ?? ""
                    vc.amount = (self.billtransactionOBj?.data?.actualDueAmount)
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
    
    
    
    
    
}
extension MobileTopUpVC: CNContactPickerDelegate {
    
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
            self.Tf_mobileNumber.text = contact.phoneNumbers[0].value.stringValue.getIntegerValue()
            var tempMobileNo =  self.Tf_mobileNumber.text?.replacingOccurrences(of: "+92", with: "0")
            var a = tempMobileNo?.substring(to: 2)
            if a == "92"
            {
                tempMobileNo =  tempMobileNo?.replacingOccurrences(of: a!, with: "0")
            }
            
            tempMobileNo =  tempMobileNo?.replacingOccurrences(of: "+92", with: "0")
            self.Tf_mobileNumber.text = tempMobileNo
            submitButtonEnable()
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
            self.Tf_mobileNumber.text = replaceSpaceWithEmptyString(aStr: formattedString)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}
