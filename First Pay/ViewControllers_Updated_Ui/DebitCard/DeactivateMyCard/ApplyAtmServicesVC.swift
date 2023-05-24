//
//  ApplyAtmServicesVC.swift
//  First Pay
//
//  Created by Irum Butt on 30/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
var Title : String?
class ApplyAtmServicesVC: BaseClassVC {
   
    var lastFourDigit : String?
    var channel : String?
    var cardId : String?
    var accountDebitcardId : Int?
    var status: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonApply.setTitle("", for: .normal)
        buttonCancel.setTitle("", for: .normal)
        
        if isfromATMON == true || isfromPOSON == true
        {
            popupView.isHidden = true
            ServiceView.isHidden = false
        }
        if isfromATMOFF == true || isfromPOSOFF == true
        {
            popupView.isHidden = false
            ServiceView.isHidden = true
        }
  
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imgPopup.isUserInteractionEnabled = true
        imgPopup.addGestureRecognizer(tapGestureRecognizer)
        print("cardid", cardId)
        print("channel",channel)
        print("accountDebitcardId", GlobalData.accountDebitCardId)
        print("lastFourDigit",lastFourDigit)
        print("status",status)
        labelTitle.text = serviceFlag
        
        
        
        // Do any additional setup after loading the view.
    }
    var otpserviceobj : OTPserviceModel?
    @IBOutlet weak var imgPopup: UIImageView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var ServiceView: UIView!
    @IBOutlet weak var buttonApply: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBAction func buttonApply(_ sender: UIButton) {
        Sendotpinterfaceenable()
    }
    @IBOutlet weak var buttonCancel: UIButton!
    @IBAction func buttonCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func movetoNext()
    {

        if isfromATMON == true || isfromPOSON == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivationDebitCardOTPVerificationVC") as! ActivationDebitCardOTPVerificationVC
           
            vc.lastFourDigit = lastFourDigit
            vc.channel  = channel
            vc.cardId = cardId
            vc.accountDebitcardId = GlobalData.accountDebitCardId
            vc.status = status
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeavtivateDebitCardMainVC") as! DeavtivateDebitCardMainVC
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
@objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {
    //
      if isfromATMON == true || isfromPOSON == true
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ActivationDebitCardOTPVerificationVC") as! ActivationDebitCardOTPVerificationVC
        vc.lastFourDigit = lastFourDigit
        vc.channel  = channel
        vc.cardId = cardId
        vc.accountDebitcardId = GlobalData.accountDebitCardId
        vc.status = status

        self.navigationController?.pushViewController(vc, animated: true)
    }
    else
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeavtivateDebitCardMainVC") as! DeavtivateDebitCardMainVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
    private func Sendotpinterfaceenable() {
   //
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
   
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/sendOtpForInterfaceEnable"
        
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","dcLastDigits": lastFourDigit!,"accountDebitCardId":GlobalData.accountDebitCardId!] as [String : Any]
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<OTPserviceModel>) in

               self.hideActivityIndicator()
               
               self.otpserviceobj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.otpserviceobj?.responsecode == 2 || self.otpserviceobj?.responsecode == 1 {
                                           movetoNext()
                    
                    
                }
                
                
                else {
                    if let message = self.otpserviceobj?.messages{
                        self.showAlertCustomPopup(title: "", message: message,iconName: .iconError)
                    }
                }
                
//                else {
//                    if let message = self.servicesOBj?.messages{
//                        self.showAlertCustomPopup(title: "", message: message,iconName: .iconError)
//                    }
//                    //                print(response.result.value)
//                    //                print(response.response?.statusCode)
//                }
            }
           }
       }
}
