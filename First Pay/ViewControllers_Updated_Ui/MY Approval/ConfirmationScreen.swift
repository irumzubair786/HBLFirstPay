//
//  ConfirmationScreen.swift
//  First Pay
//
//  Created by Irum Zubair on 08/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class ConfirmationScreen: BaseClassVC {
    var TotalAmount : String?
    var fundsTransSuccessObj: FundsTransferApiResponse?
    var transactionApiResponseObj : FTApiResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonLine.setTitle("", for: .normal)
        buttonBack.setTitle("", for: .normal)
        updateUI()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        img_next_arrow.isUserInteractionEnabled = true
        img_next_arrow.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    @IBOutlet weak var amountTF: UITextField!
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var lblTransactionFee: UILabel!
    @IBOutlet weak var lblFromAccountNo: UILabel!
    @IBOutlet weak var lblLogoName: UILabel!
    @IBOutlet weak var img_next_arrow: UIImageView!
    @IBOutlet weak var lblTotalTransactionFee: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var buttonLine: UIButton!
    @IBOutlet weak var lblAccountNo: UILabel!
    
    
    @IBAction func buttonContinue(_ sender: Any) {
        
        fundsTransferLocal()
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {
        fundsTransferLocal()

    }
    
    
    func updateUI()
    {
        amountTF.text = TotalAmount!
        lblTransactionFee.text = "Rs. 0.00"
        lblFromAccountNo.text = DataManager.instance.accountNo!
        lblTotalTransactionFee.text = TotalAmount!
        lblAccountNo.text = accountNo!
        lblLogoName.text = "FirstPay wallet"
        lblName.text = accountName!
        
        
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
        let compelteUrl = GlobalConstants.BASE_URL + "\(transactionV1or2)/fundsTransferLocal"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"narration":"","cnic":userCnic!,"accountNo":accountNo!,"amount":Amount!,"transPurpose":GlobalData.moneyTransferReasocCode,"accountTitle":accountName!,"beneficiaryName":"","beneficiaryMobile":
                            "","beneficiaryEmail":"","addBeneficiary":"N","otp": "","requestMoneyId":requesterMoneyId!,"accountType":DataManager.instance.accountType!] as [String : Any]
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
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
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
    }
    
    func movetonext()
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RequestMoneyTransactionSuccessFullVC") as! RequestMoneyTransactionSuccessFullVC
        vc.amount = (TotalAmount!)
        vc.TransactionId = fundsTransSuccessObj?.data?.authIdResponse
        vc.TransactionDate = fundsTransSuccessObj?.data?.transDate
        vc.Benenumber = accountNo!
        vc.AccountNo =  DataManager.instance.accountNo!
       
        vc.Toaccounttitle = accountName!
        self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }

}
