//
//  MSPopupview.swift
//  First Pay
//
//  Created by Arsalan Amjad on 13/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class MSPopupview: BaseClassVC {
    var nlDisbursementId = ""
    var mylonobj  : getDetailsForManualSettlement?
    var objotp : sendOtpForManualSettlementModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Manual Settlement".addLocalizableString(languageCode: languageCode)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnApply.setTitle("Apply".addLocalizableString(languageCode: languageCode), for: .normal)
        print("nlDisbursementId is ", nlDisbursementId)
        DataManager.instance.nano_loanDisbursementId = nlDisbursementId
        getLoansDetailForManualSettlement()
        
    }
    @IBOutlet weak var lblparticpant: UILabel!
    
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblmain: UILabel!
    @IBOutlet weak var blurview: UIVisualEffectView!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var lblcharges: UILabel!
    @IBOutlet weak var lblmarkup: UILabel!
//    http://bbuat.fmfb.pk/irisrest/sendOtpForManualSettlement
    @IBAction func apply(_ sender: UIButton) {
        self.sendOtpForManualSettlement()
  
    }
    @IBAction func cancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    private func getLoansDetailForManualSettlement() {

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
//
        let compelteUrl = GlobalConstants.BASE_URL + "getDetailsForManualSettlement"

        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!, "channelId": DataManager.instance.channelID, "nlDisbursementId": nlDisbursementId] as [String : Any]
       
        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))

        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]


        print(params)
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<getDetailsForManualSettlement>) in
            self.hideActivityIndicator()

            self.mylonobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.mylonobj?.responsecode == 2 || self.mylonobj?.responsecode == 1 {
                    UpDateUI()
                    print("api run successfully")
                    
                    }
                    
              
                
                else {
                    if let message = self.mylonobj?.messages{
                        self.showAlert(title: (self.mylonobj?.messages)! , message: message, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                }
                }
            }

        
            else {
                if let message = self.mylonobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                    self.navigationController?.popViewController(animated: true)
                       

            }
}
    }
    }
 
    
    
//    sendotp
 
    private func sendOtpForManualSettlement() {

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
//http://bbuat.fmfb.pk/irisrest/sendOtpForManualSettlement
        let compelteUrl = GlobalConstants.BASE_URL + "sendOtpForManualSettlement"

        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!, "channelId": DataManager.instance.channelID,"nlDisbursementId" : nlDisbursementId ] as [String : Any]

        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))

        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]


        print(params)
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<sendOtpForManualSettlementModel>) in
            self.hideActivityIndicator()

            self.objotp = response.result.value
            if response.response?.statusCode == 200 {
                if self.objotp?.responsecode == 2 || self.objotp?.responsecode == 1 {
                   
                    print("api run successfully")
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "MSStatementVC") as! MSStatementVC
                    vc.nldisbursementid = nlDisbursementId
                    self.navigationController!.pushViewController(vc, animated: true)
                    
                    }
                    
              
                
                else {
                    if let message = self.objotp?.messages{
                        
                        
                        if let message = self.objotp?.messages{
                            self.showAlert(title: (self.objotp?.messages)! , message: message, completion: {
                                self.navigationController?.popViewController(animated: true)
                            })
                    }
                }

        }
            }
            else {
                if let message = self.objotp?.messages{
                    self.showDefaultAlert(title: "", message: message)
                    self.navigationController?.popViewController(animated: true)
                       

            }
}
    }
    }
 
  func UpDateUI()
  {
//    if (self.objotp?.messages ==)
      DataManager.instance.PrincipalAmount = mylonobj?.datamanualsettlement?.principalAmount
    lblparticpant.text = "PKR:\(mylonobj?.datamanualsettlement?.principalAmount ?? 0)"
    lblmarkup.text = "PKR:\(mylonobj?.datamanualsettlement?.markupAmount ?? 0)"
    lblcharges.text = "PKR:\(mylonobj?.datamanualsettlement?.chargesAmount ?? -1)"
    lbldescription.text = "\(mylonobj?.datamanualsettlement?.statusDescr ?? "")"
    
  }

}
