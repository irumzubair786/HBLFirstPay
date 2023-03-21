//
//  SendMoneyIbftMainVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 27/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import RNCryptor
class SendMoneyIbftMainVC: BaseClassVC {
    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
    var homeObj : LoginActionModel?
      var genResObj : GenericResponse?
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangelanguageUrdu()
        print("encrption is ", DataManager.encryptionResult)
//        DispatchQueue.main.async {
//            self.decrypt(encryptedText: DataManager.levelDescr, password: self.encryptionkey)
//            
//
//        }
        getdatafromapi()
        checkValue ()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblhome: UILabel!
      @IBOutlet weak var lblContactus: UILabel!
      @IBOutlet weak var lblBookme: UILabel!
      @IBOutlet weak var lblInviteFriend: UILabel!
    
    func ChangelanguageUrdu()
    {
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        
        lblToBankaccount.text = "To Bank Accounts".addLocalizableString(languageCode: languageCode)
        lblInterBankFundsTransfer.text = "Inter Bank Funds Transfer".addLocalizableString(languageCode: languageCode)
        lblToWalletAccounts.text = "To Wallet Accounts".addLocalizableString(languageCode: languageCode)
    }
    
    
    @IBOutlet weak var lblInterBankFundsTransfer: UILabel!
    @IBOutlet weak var lblToWalletAccounts: UILabel!
    @IBOutlet weak var lblToBankaccount: UILabel!
    // MARK: - Action Methods
     
        @IBAction func addBenePressed(_ sender: Any) {
             self.getTransactionConsent()
            
        }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func invitefriend(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func golootlo(_ sender: UIButton) {
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactus(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func tickets(_ sender: UIButton) {
       let  vc = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
       self.navigationController!.pushViewController(vc, animated: true)
    }
    

    // MARK: - POP UP
      
//      -------------decrypt function------------
//    var levelDescrAfterDecrypt = ""
//    func decrypt(encryptedText: String, password: String) -> String{
//           do{
//               let data: Data = Data(base64Encoded: encryptedText)!
//               let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
//               let decryptedString = String(data: decryptedData, encoding: .utf8)
//               print("decryptedString",decryptedString)
//            levelDescrAfterDecrypt = decryptedString!
//               return decryptedString ?? ""
//
//           }
//           catch{
//               return "Failed"
//           }
//
//
//       }
    
    
//    -----------ene------------
      private func popUpConsent(){
             
             let consentAlert = UIAlertController(title: "Alert", message: "Do you want to activate IBFT Services", preferredStyle: UIAlertControllerStyle.alert)
             
             consentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in

                 let OTPVerifyVC = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                 OTPVerifyVC.ForTransactionConsent = true
                 self.navigationController!.pushViewController(OTPVerifyVC, animated: true)
                 print("Handle Ok logic here")
             }))
             
             consentAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                 print("Handle Cancel Logic here")
                 self.navigationController?.popViewController(animated: true)
             }))
             
             present(consentAlert, animated: true, completion: nil)
         }
     
      // MARK: - API CALL
     
     private func getTransactionConsent() {

         if !NetworkConnectivity.isConnectedToInternet(){
             self.showToast(title: "No Internet Available")
             return
         }

         showActivityIndicator()

         let compelteUrl = GlobalConstants.BASE_URL + "getConsents"
         
         let parameters = ["transaction":"IBFT","channel":"MOBAPP","channelId":"\(DataManager.instance.channelID)"]
         
         
         print(parameters)
         
         let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
         
         print(result.apiAttribute1)
         print(result.apiAttribute2)
         
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)","accountType" : DataManager.instance.accountType!]
         
         let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
         
         print(params)
         print(compelteUrl)
         print(header)

         NetworkManager.sharedInstance.enableCertificatePinning()
         
         NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in


             self.hideActivityIndicator()

             if response.response?.statusCode == 200 {
                 self.genResObj = response.result.value
                 if self.genResObj?.responsecode == 0 {
                     self.getTransactionConsentOTP()
                 }
                 else{
                     
                     let addBeneVC = self.storyboard!.instantiateViewController(withIdentifier: "AddBeneVC") as! AddBeneVC
                     addBeneVC.isFromAddBene = true
                     self.navigationController!.pushViewController(addBeneVC, animated: true)
                 }
             }
             else {
                 
                 if let message = self.genResObj?.messages{
                     self.showDefaultAlert(title: "Message", message: message )
                 }
//                 print(response.result.value)
//                 print(response.response?.statusCode)

                 if let messageErrorTrans = self.genResObj?.messages{
                     self.showDefaultAlert(title: "", message: messageErrorTrans)
                 }
             }
         }
     }

    
    func checkValue ()
       {
           if DataManager.levelDescr == "LEVEL 1"
           {
               
               DataManager.instance.accountType = "20"
               print("Level 1 type is ", DataManager.instance.accountType)
               //Gokoof ho gia sir :*
               //wait
           }
           if DataManager.levelDescr == "HOME REMITTANCE"
           {
               DataManager.instance.accountType = "30"
               print("Home Remi type is ", DataManager.instance.accountType)
           }
       }
     
     private func getTransactionConsentOTP() {
         
         if !NetworkConnectivity.isConnectedToInternet(){
             self.showToast(title: "No Internet Available")
             return
         }
         
         showActivityIndicator()
         
         let compelteUrl = GlobalConstants.BASE_URL + "consentOtp"
         
         
         let parameters = ["transaction":"IBFT","channel":"MOBAPP","channelId":"\(DataManager.instance.channelID)","status": "Y",]
         
         let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
         
         print(result.apiAttribute1)
         print(result.apiAttribute2)
         
         let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
         
         let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
         
         print(params)
         print(compelteUrl)
         print(header)
         
         NetworkManager.sharedInstance.enableCertificatePinning()
         
         NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
             
             self.hideActivityIndicator()
               
             self.genResObj = response.result.value
             if response.response?.statusCode == 200 {
                 
                 if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
              //       if self.genResObj?.responsecode == 0 {
                         self.popUpConsent()
                    // }
                 }
                 else {
                   
                     if let message = self.genResObj?.messages{
                         self.showDefaultAlert(title: "", message: message)
                     }
                 }
             }
             else {
                 if let message = self.genResObj?.messages{
                     self.showDefaultAlert(title: "", message: message)
                 }
//                 print(response.result.value)
//                 print(response.response?.statusCode)
             }
         }
     }
    func getdatafromapi()
    {
    
        if counter == 0
        {

            DataManager.instance.accountType = "20"
            counter = counter+1
            print(DataManager.instance.accountType)
            
        }
        else if counter > 0
        {
            DataManager.instance.accountType = "30"
            counter = counter-1
            print(DataManager.instance.accountType)
        
        }
    }

}
