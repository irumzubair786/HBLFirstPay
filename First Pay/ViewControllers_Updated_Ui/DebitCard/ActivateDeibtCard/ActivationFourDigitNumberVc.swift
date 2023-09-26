//
//  ActivationFourDigitNumberVc.swift
//  First Pay
//
//  Created by Irum Butt on 13/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
var DebitCardLast4digit : String?
class ActivationFourDigitNumberVc: BaseClassVC, UITextFieldDelegate {
    var getDebitDetailsObj : GetDebitCardModel?
    var lastFourDigit : String?
    var channel : String?
    var cardId : String?
    var accountDebitcardId : Int?
    var status: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        textfieldLast4digit.delegate = self
        buttonContinue.isUserInteractionEnabled = false
        imgNextArrow.isUserInteractionEnabled = false
        textfieldLast4digit.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imgNextArrow.isUserInteractionEnabled = true
        imgNextArrow.addGestureRecognizer(tapGestureRecognizer)
        if (isfromATMON == true ) || (isfromPOSOFF == true)
        {
            labelTitle.text = "ATM & POS ACCESSBILITY"
        }
        if (isfromPOSON == true ) || (isfromATMOFF == true)
        {
            labelTitle.text = "ATM & POS ACCESSBILITY"
        }
        self.textfieldLast4digit.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
        
        buttonContinue.circle()
    }
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelMainTitle: UILabel!
    
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer) {

        if isFromChangePin == true
        {
            
            isFromChangePin = true
            getDebitCardsCall()
        }
        
        if isfromReactivateCard == true{
            isFromDeactivate = false
            getDebitCardsCall()
        }
        if isFromDeactivate == true
        {
            isFromDeactivate = true
            getDebitCardsCall()
        }
        if isfromATMON == true || isfromPOSON == true{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ApplyAtmServicesVC") as! ApplyAtmServicesVC
            vc.cardId = cardId
            vc.channel = serviceFlag
            vc.accountDebitcardId =  GlobalData.accountDebitCardId
            vc.lastFourDigit = textfieldLast4digit.text!
            vc.status = status
            self.navigationController?.pushViewController(vc, animated: true)
        }
      else  if  isfromATMOFF == true || isfromPOSOFF == true
        {
          FBEvents.logEvent(title: .Debit_activateotp_attempt)

          let vc = storyboard?.instantiateViewController(withIdentifier: "ActivationDebitCardOTPVerificationVC") as! ActivationDebitCardOTPVerificationVC
          vc.cardId = cardId
          vc.channel = serviceFlag
          vc.accountDebitcardId =  GlobalData.accountDebitCardId
          vc.status = status
          vc.lastFourDigit = textfieldLast4digit.text!
          //          isfromDisableService = true
          self.navigationController?.pushViewController(vc, animated: true)
      }
        else{
            getDebitCardsCall()
        }
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true
        )
    }
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var imgNextArrow: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBAction func buttonContinue(_ sender: UIButton) {
        if isFromChangePin == true
        {
            isFromChangePin = true
            getDebitCardsCall()
        }
        else{
            isFromDeactivate = true
            getDebitCardsCall()
        }
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == textfieldLast4digit
        { textfieldLast4digit.isUserInteractionEnabled = true
            return newLength <= 4
       
    }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textfieldLast4digit.text?.count == 4
        {
            let image = UIImage(named:"]greenarrow")
            imgNextArrow.image = image
            buttonContinue.isUserInteractionEnabled = true
            imgNextArrow.isUserInteractionEnabled = true
            
        }
        else
        {
            let image = UIImage(named:"grayArrow")
            imgNextArrow.image = image
            buttonContinue.isUserInteractionEnabled = false
            imgNextArrow.isUserInteractionEnabled = false
        }
        
        DebitCardLast4digit = textfieldLast4digit.text!
    }
    @objc func changeTextInTextField() {
        
        if textfieldLast4digit.text?.count == 4
        {
            let image = UIImage(named:"]greenarrow")
            imgNextArrow.image = image
            buttonContinue.isUserInteractionEnabled = true
            imgNextArrow.isUserInteractionEnabled = true
        }
        else
        {
            let image = UIImage(named:"grayArrow")
            imgNextArrow.image = image
            buttonContinue.isUserInteractionEnabled = false
            imgNextArrow.isUserInteractionEnabled = false
        }
        DebitCardLast4digit = textfieldLast4digit.text!
    }
    
    @IBOutlet weak var textfieldLast4digit: UITextField!
    // MARK: - Api Call
    
    private func getDebitCardsCall() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
//        UtilManager.showProgress()
        self.showActivityIndicator()
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/debitCardVerification"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters =  ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"dcLastDigits":textfieldLast4digit.text!,"accountDebitCardId":GlobalData.accountDebitCardId!] as [String : Any]
//
        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
       
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<GetDebitCardModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.getDebitDetailsObj = Mapper<GetDebitCardModel>().map(JSONObject: json)
                
                //            self.getDebitDetailsObj = response.result.value
                print(self.getDebitDetailsObj ?? "")
                
                if response.response?.statusCode == 200 {
                    
                    if self.getDebitDetailsObj?.responsecode == 2 || self.getDebitDetailsObj?.responsecode == 1 {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivationDebitCardOTPVerificationVC") as!  ActivationDebitCardOTPVerificationVC
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    else {
                        if let message = self.getDebitDetailsObj?.messages{
                            self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                        }
                    }
                }
                else {
                    if let message = self.getDebitDetailsObj?.messages{
                        self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                        
                        //                    self.showDefaultAlert(title: "", message: message)
                    }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                }
            }
        }
    }
}
