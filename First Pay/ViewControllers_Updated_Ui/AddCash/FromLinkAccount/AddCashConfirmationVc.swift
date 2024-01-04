//
//  AddCashConfirmationVc.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
var isfromPullFund :Bool = false
class AddCashConfirmationVc: BaseClassVC {
    var accounttilte : String?
    var accontNo : String?
    var bankName :String?
    var TotalAmount : Float?
    var FirstPayNo : String?
    var transactionApiResponseObj : FTApiResponse?
    var convertTotalAmountToString: String?
    var otpRequired : String?
    var numberFormatter = NumberFormatter()
    
    @IBOutlet weak var buttonContinue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUi()
        numberFormatter.numberStyle = .decimal
        buttonViewLine.setTitle("", for: .normal)
        buttonBack.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        img_next.isUserInteractionEnabled = true
        img_next.addGestureRecognizer(tapGestureRecognizerr)
        // Do any additional setup after loading the view.
        buttonContinue.circle()
    }
   
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
     
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        FBEvents.logEvent(title: .Transactions_active)
        FaceBookEvents.logEvent(title: .Transactions_active)
        if   otpRequired == "Y"
        {
            OTP()
        }
       else
        {
        self.initiateAddCashFT()
       }
      

    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        FBEvents.logEvent(title: .Transactions_active)
        FaceBookEvents.logEvent(title: .Transactions_active)
        if   otpRequired == "Y"
        {
            OTP()
        }
       else
        {
        self.initiateAddCashFT()
       }
    }
    
    @IBOutlet weak var img_next: UIImageView!
    @IBOutlet weak var amounttextfield: UITextField!
    @IBOutlet weak var labelFirstPayNo: UILabel!
    @IBOutlet weak var labelTotalTransationAmount: UILabel!
    @IBOutlet weak var labelTransactionFee: UILabel!
    @IBOutlet weak var buttonViewLine: UIButton!
    @IBOutlet weak var labelAccountTitle: UILabel!
    @IBOutlet weak var labelBankName: UILabel!
    @IBOutlet weak var labelAccountNo: UILabel!
     func UpdateUi()
    {
       
        
        labelTransactionFee.text = "Rs. 0.00"
        labelAccountTitle.text = accounttilte
        labelAccountNo.text = accontNo
        labelBankName.text = bankName
        labelFirstPayNo.text = FirstPayNo
        labelTotalTransationAmount.text = "Rs. \(TotalAmount ?? 0)"
       
        amounttextfield.text = "\(TotalAmount ?? 0)"
        convertTotalAmountToString = String(TotalAmount!)
        print("Converted Amount", convertTotalAmountToString)
        C0nvertValue()
    }
    func C0nvertValue()
    {
        if let formattedString = self.numberFormatter.string(from: NSNumber(value: self.TotalAmount!)) {
            print(formattedString)
            self.convertTotalAmountToString = formattedString

            print("formattedString", formattedString)
            // This will print "3.14"
        }
    }
    func OTP() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getOtpOrOtv"
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["mobileNo":DataManager.instance.accountNo! ,"otpType":GlobalOTPTypes.LOAD_BALANCE_PULL ,"channelId":"\(DataManager.instance.channelID )", "cnic" : userCnic!, "otpSendType" : "OTP" ]
        

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        //        print(result.apiAttribute1)
        //        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "")"]

//        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.AuthToken)"]
        //
        print(parameters)
        print(compelteUrl)
        print("Headers: \(header)")
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //            (response: DataResponse<GenericResponse>) in
            
            //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<VerifyOTP>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            print(response.result)
            print(response.response)
            print(response.request)

            //            let tempGenRespBaseObj = try? JSONDecoder().decode(GenericResponse.self, from: response.data!)
            //            print(tempGenRespBaseObj)
            
            do{
                let json = try JSONSerialization.jsonObject(with: response.data!, options: [.fragmentsAllowed])
                
                
                self.genRespBaseObj = Mapper<GenericResponse>().map(JSONObject: json)
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
            //            self.genRespBaseObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genRespBaseObj?.responsecode == 2 || self.genRespBaseObj?.responsecode == 1 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LinkBankAccountOTPVerificationVc") as! LinkBankAccountOTPVerificationVc
                    
//                    vc.TotalAmount = "\(self.TotalAmount!)"
                  
                    vc.TotalAmount = self.convertTotalAmountToString
                    vc.userAccountNo = self.transactionApiResponseObj?.data?.accountNo
                    isfromPullFund = true
                    self.navigationController?.pushViewController(vc, animated: true
                    )
//                    self.VerifyOTPForTransaction()
                    
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
//
        let compelteUrl = GlobalConstants.BASE_URL + "\(transactionV1or2)/initiateAddCashFT"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","imei":DataManager.instance.imei!,"cnic":userCnic!,"accountNo":DataManager.instance.accountNo!,"amount":convertTotalAmountToString!,"channelId":"\(DataManager.instance.channelID)" ] as [String : Any]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
        print(params)
        print(compelteUrl)
//        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<FTApiResponse>) in
            
            //         Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response { (response: DataResponse<FundInitiateModel>) in
          
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
  
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.transactionApiResponseObj = Mapper<FTApiResponse>().map(JSONObject: json)
                //            self.transactionApiResponseObj = response.result.value
                if response.response?.statusCode == 200 {
                    
                    if self.transactionApiResponseObj?.responsecode == 2 || self.transactionApiResponseObj?.responsecode == 1 {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LinkBankAccountOTPVerificationVc") as! LinkBankAccountOTPVerificationVc
//                        vc.TotalAmount = "\(self.TotalAmount!)"
                        vc.TotalAmount = self.convertTotalAmountToString
                        vc.userAccountNo = self.transactionApiResponseObj?.data?.accountNo
                        isfromPullFund = true
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
}

