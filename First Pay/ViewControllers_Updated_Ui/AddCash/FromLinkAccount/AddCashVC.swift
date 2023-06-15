//
//  AddCashVC.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS

class AddCashVC: BaseClassVC, UITextFieldDelegate {
    var reasonsObj : GetReasonsModel?
    var transactionApiResponseObj : FTApiResponse?
    var LinkedAccountsObj : getLinkedAccountModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        getLinkAccounts()
        textFieldAmount.delegate = self
        buttonContinue.isUserInteractionEnabled = false
        buttonBack.setTitle("", for: .normal)
        self.textFieldAmount.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
   var minimumValue = "1"
    var maximumValue = "25000"
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var labelAccountTitle: UILabel!
    @IBOutlet weak var labelBankName: UILabel!
    @IBOutlet weak var labelAccountNo: UILabel!
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCashConfirmationVc") as! AddCashConfirmationVc
        vc.accontNo = self.LinkedAccountsObj?.data?[0].cbsAccountNo
        vc.accounttilte = self.LinkedAccountsObj?.data?[0].cbsAccountTitle
        vc.bankName = self.LinkedAccountsObj?.data?[0].branchName
        vc.FirstPayNo = self.LinkedAccountsObj?.data?[0].mobileNo
        vc.TotalAmount = self.textFieldAmount.text!
        self.navigationController?.pushViewController(vc, animated: true
        )

        
    }
    @IBAction func textFieldAmount(_ sender: UITextField) {
//
//        if textFieldAmount?.text?.count != 0
//        {
//            img_Next.image = UIImage(named: "]greenarrow")
//            buttonContinue.isUserInteractionEnabled = true
//
//        }
//        else
//        {
//            img_Next.image = UIImage(named: "grayArrow")
//            buttonContinue.isUserInteractionEnabled = false
//        }
        
    }
    @objc func changeTextInTextField() {
        if (textFieldAmount?.text! ?? "") ?? "" < minimumValue
        {
            let image = UIImage(named:"grayArrow")
            img_Next.image = image
            img_Next.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
            labelAlert.textColor = UIColor(hexValue: 0xFF3932)
            textFieldAmount.textColor = UIColor(hexValue: 0xFF3932)
        }
       else if (textFieldAmount?.text! ?? "") ?? "" > (maximumValue)
        {
            let image = UIImage(named:"grayArrow")
            img_Next.image = image
            img_Next.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
            labelAlert.textColor = UIColor(hexValue: 0xFF3932)
            textFieldAmount.textColor = UIColor(hexValue: 0xFF3932)
        }
        else
        {
            
            let image = UIImage(named:"]greenarrow")
            img_Next.image = image
            img_Next.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true
            labelAlert.textColor = UIColor.orange
            textFieldAmount.textColor = UIColor.gray
        }

        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textFieldAmount?.text! ?? "") ?? "" < minimumValue
        {
            let image = UIImage(named:"grayArrow")
            img_Next.image = image
            img_Next.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
            labelAlert.textColor = UIColor(hexValue: 0xFF3932)
            textFieldAmount.textColor = UIColor(hexValue: 0xFF3932)
        }
        if (textFieldAmount?.text! ?? "") ?? "" > (maximumValue)
        {
            let image = UIImage(named:"grayArrow")
            img_Next.image = image
            img_Next.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
            labelAlert.textColor = UIColor(hexValue: 0xFF3932)
            textFieldAmount.textColor = UIColor(hexValue: 0xFF3932)
        }
        else
        {
            let image = UIImage(named:"]greenarrow")
            img_Next.image = image
            img_Next.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true
            labelAlert.textColor = UIColor.orange
            textFieldAmount.textColor = UIColor.gray
        }
    

}
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength:Int = (textField.text?.count)! + string.count - range.length
        if textField == textFieldAmount
        {
            
            let newText = (textFieldAmount.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if newText.count == 1 && newText.first == "0" {
                let image = UIImage(named:"grayArrow")
                img_Next.image = image
                img_Next.isUserInteractionEnabled = false
                buttonContinue.isUserInteractionEnabled = false
                labelAlert.textColor = UIColor(hexValue: 0xFF3932)
                textFieldAmount.textColor = UIColor(hexValue: 0xFF3932)
                return false
            }
            if textField == textFieldAmount{
                return newLength <= 6
            }
            
            return true
        }
        return true
        
    }
    @IBOutlet weak var labelAlert: UILabel!
    @IBOutlet weak var img_Next: UIImageView!
    private func getLinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getLinkAccount"
        
        
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!]
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<getLinkedAccountModel>) in
            
            
            self.hideActivityIndicator()
            
            self.LinkedAccountsObj = response.result.value
            if response.response?.statusCode == 200 {
            
                if self.LinkedAccountsObj?.responsecode == 2 || self.LinkedAccountsObj?.responsecode == 1 {
//                    if self.LinkedAccountsObj?.data?.count ?? 0 > 0{
//
//
//                }
//                    GlobalData.userAcc = self.LinkedAccountsObj?.data?[0].cbsAccountNo
//                    GlobalData.userAcc =  GlobalData.userAcc?.replacingOccurrences(of: " ", with: "")
                    labelAccountTitle.text = LinkedAccountsObj?.data?[0].cbsAccountTitle
                    labelAccountNo.text = LinkedAccountsObj?.data?[0].cbsAccountNo
                    
                    labelBankName.text = LinkedAccountsObj?.data?[0].branchName
                    
                    
                }
                else {
                    self.showAlert(title: "", message: (self.LinkedAccountsObj?.messages)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    
    private func initiateAddCashFT() {
        
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
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/initiateAddCashFT"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","imei":DataManager.instance.imei!,"cnic":userCnic!,"accountNo":DataManager.instance.accountNo!,"amount":self.textFieldAmount.text!] as [String : Any]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
        print(params)
        print(compelteUrl)
//        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FTApiResponse>) in
            
            //         Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FundInitiateModel>) in
          
            self.hideActivityIndicator()
            self.transactionApiResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                        if self.transactionApiResponseObj?.responsecode == 2 || self.transactionApiResponseObj?.responsecode == 1 {
                           
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCashConfirmationVc") as! AddCashConfirmationVc
//                            GlobalData.userAcc = self.LinkedAccountsObj?.data?[0].cbsAccountNo
//                            GlobalData.userAcc =  GlobalData.userAcc?.replacingOccurrences(of: " ", with: "")
                            vc.accontNo = self.LinkedAccountsObj?.data?[0].cbsAccountNo
                            vc.accounttilte = self.LinkedAccountsObj?.data?[0].cbsAccountTitle
                            vc.bankName = self.LinkedAccountsObj?.data?[0].branchName
                            vc.FirstPayNo = self.LinkedAccountsObj?.data?[0].mobileNo
                            vc.TotalAmount = self.textFieldAmount.text!
                            self.navigationController?.pushViewController(vc, animated: true
                            )
                            
                            
                            
                }
                else {
                    if let message = self.transactionApiResponseObj?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                    }
                     
                }
            }
            else {
                if let message = self.transactionApiResponseObj?.messages{
                    self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    

}
