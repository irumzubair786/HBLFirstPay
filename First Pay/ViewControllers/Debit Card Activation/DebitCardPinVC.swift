//
//  DebitCardPinVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 26/10/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class DebitCardPinVC: BaseClassVC {
    
    @IBOutlet  var enterNewPinTextField: UITextField!
    @IBOutlet  var confirmNewPinTextField: UITextField!
    var accountDebitCardId : String?
    
    var genResponse : GenericResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblMainTitle.text  = "Activate Debit Card".addLocalizableString(languageCode: languageCode)
        print(self.accountDebitCardId)
        enterNewPinTextField.placeholder = "Enter New Pin".addLocalizableString(languageCode: languageCode)
        confirmNewPinTextField.placeholder = "Confirm new Pin".addLocalizableString(languageCode: languageCode)
        btnnext.setTitle("NEXT".addLocalizableString(languageCode: languageCode), for: .normal)
    }
    
    
    @IBOutlet weak var btnnext: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    // MARK: - Action Methods
    
    @IBAction func setPinPressed(_ sender: Any) {
        
        if enterNewPinTextField.text?.count == 0 {
            self.showToast(title: "Please Enter Pin")
            return
        }
        if confirmNewPinTextField.text?.count == 0 {
            self.showToast(title: "Please Enter confirm Pin")
            return
        }
        if enterNewPinTextField.text != confirmNewPinTextField.text! {
            self.showDefaultAlert(title: "Error", message: "Pin and Confirm Pin not match")
            return
        }
        
        self.setPinCall()

    }
    
    // MARK: - Api Call
    
    private func setPinCall() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "createDCPin"
        
        let parameters : Parameters = ["cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"accountDebitCardId":self.accountDebitCardId!,"pin":self.enterNewPinTextField.text!,"confirmPin":self.confirmNewPinTextField.text!]
        
        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            
            self.genResponse = response.result.value
            print(self.genResponse)
        
            if response.response?.statusCode == 200 {
                
                if self.genResponse?.responsecode == 2 || self.genResponse?.responsecode == 1 {
                    if let message = self.genResponse?.messages{
                        self.showAlert(title: "", message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
                else {
                    if let message = self.genResponse?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genResponse?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    



}
