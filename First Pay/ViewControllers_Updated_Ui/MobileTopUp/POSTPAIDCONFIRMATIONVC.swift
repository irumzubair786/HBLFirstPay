//
//  POSTPAIDCONFIRMATIONVC.swift
//  First Pay
//
//  Created by Irum Butt on 18/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class POSTPAIDCONFIRMATIONVC: BaseClassVC ,UITextFieldDelegate{
    var phoneNumber  : String?
    var DueDate : String?
    var successmodelobj : FundsTransferApiResponse?
    var status: String?
    var minValue = 100
    var maxValue = 10000
    var amount :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        buttonContinue.isUserInteractionEnabled = false
        amounttextField.delegate = self
        buttonBack.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        buttonContinue.isUserInteractionEnabled = false
        imageNext.addGestureRecognizer(tapGestureRecognizerr)
        updateui()
        imageNext.isUserInteractionEnabled = false
        amounttextField.isUserInteractionEnabled = true
        self.amounttextField.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
//    private func textFieldShouldBeginEditing(_ textField: UITextField) {
//        if amounttextField.text == "0"
//        {
//            let image = UIImage(named:"grayArrow")
//            imageNext.image = image
//            imageNext.isUserInteractionEnabled = false
//            buttonContinue.isUserInteractionEnabled = false
//        }
//
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = amounttextField.text, !text.isEmpty {
            amounttextField.text = ""
            let image = UIImage(named:"grayArrow")
            imageNext.image = image
            imageNext.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
        }
    }
    
    @objc func changeTextInTextField() {
//        amounttextField.text = ""
        AmountSepartor()
        let array = amounttextField.text!.reduce(into: [Character]()) { result, letter in
            result.append(letter)
        }
        
        if array.contains(".") {
            labelAmount.text = comabalanceLimit
        }
        else {
//            \(Int(amounttextField.text!)?.twoDecimal() ?? "0")"
            labelAmount.text = comabalanceLimit
        }
        if amounttextField.text?.count ?? 0 > 0
        {
            if Int(amounttextField.text!) ?? 0  < Int((minValue) ?? 0) || Int(amounttextField.text!) ?? 0 > Int((maxValue) ?? 0)
            {
                
                let image = UIImage(named:"grayArrow")
                imageNext.image = image
                imageNext.isUserInteractionEnabled = false
                buttonContinue.isUserInteractionEnabled = false
                
            }
            else
            {
                let image = UIImage(named:"]greenarrow")
                imageNext.image = image
                imageNext.isUserInteractionEnabled = true
                buttonContinue.isUserInteractionEnabled = true
            }
            
        }
//        else if amounttextField.text! == "0"
//        {
//
//                let image = UIImage(named:"grayArrow")
//                imageNext.image = image
//                imageNext.isUserInteractionEnabled = false
//                buttonContinue.isUserInteractionEnabled = false
//        }
        else  if amounttextField.text?.count == 0
        {
            let image = UIImage(named:"grayArrow")
            imageNext.image = image
            imageNext.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var otptextField: UITextField!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelAlert: UILabel!
    @IBOutlet weak var amounttextField: UITextField!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var imglogo: UIImageView!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true
        )
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if otptextField.text?.count != 4
//        {
//            let image = UIImage(named:"grayArrow")
//            imageNext.image = image
//            imageNext.isUserInteractionEnabled = false
//            buttonContinue.isUserInteractionEnabled = false
//        }
//        else{
//            let image = UIImage(named:"]greenarrow")
//            imageNext.image = image
//            imageNext.isUserInteractionEnabled = true
//            buttonContinue.isUserInteractionEnabled = true
//        }
//    }
    @IBAction func otptextfield(_ sender: UITextField) {
//        if otptextField.text?.count != 4
//        {
//            let image = UIImage(named:"grayArrow")
//            imageNext.image = image
//            imageNext.isUserInteractionEnabled = false
//            buttonContinue.isUserInteractionEnabled = false
//        }
//        else{
//            let image = UIImage(named:"]greenarrow")
//            imageNext.image = image
//            imageNext.isUserInteractionEnabled = true
//            buttonContinue.isUserInteractionEnabled = true
//        }
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength:Int = (textField.text?.count)! + string.count - range.length
        
        if textField == otptextField{
            return newLength <= 4
            
            //  lbl1.textColor = UIColor.green
        }
        if textField == otptextField{
            return newLength <= 4
        }
        if textField == amounttextField
        {
            return newLength <= 5
        }
        if textField == amounttextField
        {
            let newText = (amounttextField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if newText.count == 1 && newText.first == "0" {
                let image = UIImage(named:"grayArrow")
                imageNext.image = image
                imageNext.isUserInteractionEnabled = false
                buttonContinue.isUserInteractionEnabled = false
                return false // Disallow entering zero as the first digit
            }
        }

         return true
 
        return newLength <= 9

    }

    @IBOutlet weak var imageNext: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBAction func buttonContinue(_ sender: UIButton) {
        if ((status == "U") || (status == "u") || ((status == "T") || (status == "t")))
        {
            initiateTopUp()
        }
      else if GlobalData.Select_operator_code == "TELNOR02"
        {
          initiateTopUp()
       }
        
        
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if ((status == "U") || (status == "u") || ((status == "T") || (status == "t")))
        {
            initiateTopUp()
        }
       
        else if GlobalData.Select_operator_code == "TELNOR02"
          {
            initiateTopUp()
         }
    }
    func updateui()
    {
        if let templog = GlobalData.selected_operator_logo {
            let url = URL(string:"\(GlobalConstants.BASE_URL)\(GlobalData.selected_operator_logo!)")
            imglogo.sd_setImage(with: url)
            labelMobileNumber.text = phoneNumber
            labelDate.text = DueDate
            //        let a = DueDate?.substring(to: 11)
            //        labelDate.text = a
            
            if status == "t" || status == "T" {
                labelStatus.text = "Partial Payment"
            }
            else if status == "b" || status == "B"
            {
                labelStatus.text = "Your Customer is Blocked.Please contact your service provider."
            }
            else
            {
                labelStatus.text = status
            }
//            labelAmount.text = amounttextField.text
            
            labelAmount.text =  "\(amount?.floatValue ?? 0)"
            amounttextField.text = "\(amount?.floatValue ?? 0)"
//            amounttextField.isUserInteractionEnabled = false
            let image = UIImage(named:"]greenarrow")
            imageNext.image = image
            imageNext.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true
            checkAmount()
            
        }
        
    }
    func checkAmount()
    {
        if GlobalData.Select_operator_code == "TELNOR02"
        {
//            amounttextField.isUserInteractionEnabled = true
            if amount == ("0.0")
            {
                let image = UIImage(named:"grayArrow")
                imageNext.image = image
                imageNext.isUserInteractionEnabled = false
                buttonContinue.isUserInteractionEnabled = false
            }
            else
            {
                let image = UIImage(named:"]greenarrow")
                imageNext.image = image
                imageNext.isUserInteractionEnabled = true
                buttonContinue.isUserInteractionEnabled = true
            }
            
            
        }
        
    }
    var comabalanceLimit : String?
    func  AmountSepartor() {
        if var number = Double(self.amounttextField.text!) {
            var formatter = NumberFormatter()
            formatter.numberStyle = .decimal
    //        formatter.maximumFractionDigits = 2
            formatter.locale = Locale(identifier: "en_US")
            comabalanceLimit = (formatter.string(from: NSNumber(value: number)))
        }
        else {
            comabalanceLimit = "0"
        }
//        var text = amounttextField.text?.getIntegerValue()
//        if text == "" {
//            return
//        }
//
//        let tempText = text?.components(separatedBy: ".").first as? String
//        if tempText == nil {
//            text = (amounttextField.text?.getIntegerValue())!
//        }
//        else {
//            text = tempText ?? ""
//        }
//        amounttextField.text = text
//
//
//
//
//
////        var text = amounttextField.text?.getIntegerValue()
////        var tempText = text?.components(separatedBy: ".").first as? String
//        if tempText == nil {
//            text = (amounttextField.text?.getIntegerValue())!
//        }
//        else {
//            text = tempText ?? ""
//        }
//        amounttextField.text = "\(Int(amounttextField.text!)?.twoDecimal() ?? "0")"
//
//        if amounttextField.text != "" {
//            text = amounttextField.text!.replacingOccurrences(of: "", with: "")
//
//        }
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
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/topUp"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","utilityBillCompany": GlobalData.Select_operator_code,"beneficiaryAccountTitle":"","utilityConsumerNo":phoneNumber!,"accountType" : DataManager.instance.accountType!,"amountPaid":labelAmount.text!,"beneficiaryName":"","beneficiaryMobile":"","beneficiaryEmail":"","otp":otptextField.text!,"addBeneficiary":"","utilityBillCompanyId": GlobalData.Select_operator_id!] as [String : Any]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(parameters)
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
            self.successmodelobj = Mapper<FundsTransferApiResponse>().map(JSONObject: json)
            
//            self.successmodelobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.successmodelobj?.responsecode == 2 || self.successmodelobj?.responsecode == 1 {
                    self.navigatezToConfirmationVC()
//                    self.tablleview?.reloadData()
                }
                else {
                    if let message = self.successmodelobj?.messages{
                        self.showAlertCustomPopup(title: "",message: message,iconName: .iconError)
//                        self.navigateToSuccessVC()
                    }
                }
            }
            else {
                if let message = self.successmodelobj?.messages{
                        self.showAlertCustomPopup(title: "",message: message,iconName: .iconError)
//                        self.navigateToSuccessVC()
                    }

                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }

    func navigatezToConfirmationVC()
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TransferAmountConfirmationVc") as! TransferAmountConfirmationVc
        vc.amount = "\(labelAmount.text!)"
        vc.phoneNumber = phoneNumber
        self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
