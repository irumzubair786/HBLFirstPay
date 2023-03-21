//
//  VerifyParticipantVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 14/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class VerifyParticipantVC: BaseClassVC , UITextFieldDelegate{
    
    
    
    @IBOutlet  var walletNumberTextField: UITextField!
    @IBOutlet  var drawSequenceTextField: UITextField!
    var commId : String?
    var committeeMemberCount : Int?
    var checkCommitteeMemberCount: Int?
    
    var titleFetchObj : TitleFetchCommitteeModel?
    var genRObj : GenericResponse?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet var btn_Submit: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_Submit.isUserInteractionEnabled = false
        
    }
    
    
    // MARK: - UITextfield Delegate Methods
       
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
           let newLength = (textField.text?.count)! + string.count - range.length
           
           if textField == walletNumberTextField{
               return newLength <= 11
           }
           else {
               return newLength <= 16
           }
       }
    
    
    
    // MARK: - Actions Methods
    
    @IBAction func verifyPressed(_ sender: Any) {
        
      if walletNumberTextField.text?.count == 0 {
          self.showToast(title: "Please Enter Wallet Number")
          return
      }
        
        self.verifyParticipantCall()
        
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        self.checkCommitteeMemberCount = Int(self.drawSequenceTextField.text!)
        
        if walletNumberTextField.text?.count == 0 {
            self.showToast(title: "Please Enter Wallet Number")
            return
        }
        if drawSequenceTextField.text?.count == 0 {
            self.showToast(title: "Please Enter Draw Sequence")
            return
        }
        if self.committeeMemberCount! < self.checkCommitteeMemberCount! {
            self.showToast(title: "Draw Sequence Cannot Be Greater Than Members Count")
            return
        }
        
        self.addParticipantCall()
        
        
    }

    // MARK: - API CALL
    
    private func verifyParticipantCall() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "titleFetchParticipants"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":self.commId!,"walletNo":self.walletNumberTextField.text!]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<TitleFetchCommitteeModel>) in
            
            
            self.hideActivityIndicator()
            
            self.titleFetchObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.titleFetchObj?.responsecode == 2 || self.titleFetchObj?.responsecode == 1 {
                    
                    if let name = self.titleFetchObj?.WalletTitle{
                        self.lblName.text = name
                        self.btn_Submit.isUserInteractionEnabled = true
                    }
                }
                else {
                    if let message = self.titleFetchObj?.messages{
                        self.showDefaultAlert(title: "Error", message: message)
                    }
                }
            }
            else {
                if let message = self.titleFetchObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
  
    private func addParticipantCall() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "addParticipant"
        

        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":self.commId!,"walletNo":self.titleFetchObj?.WalletNumber!,"walletTitle":self.titleFetchObj?.WalletTitle!,"drawSeq":self.drawSequenceTextField.text!]
        
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
            
            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
                
                self.hideActivityIndicator()
                
                self.genRObj = response.result.value
                
                if response.response?.statusCode == 200 {
                    
                    if self.genRObj?.responsecode == 2 || self.genRObj?.responsecode == 1 {
                        self.showAlert(title: "Success", message: (self.genRObj?.messages)!, completion: {
                            self.navigationController!.popViewController(animated: true)
                        })
                    }
                    else {
                        if let message = self.genRObj?.messages{
                            self.showDefaultAlert(title: "Error", message: message)
                        }
                    }
                }
                else {
                    if let message = self.genRObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
//                    print(response.result.value)
//                    print(response.response?.statusCode)
                }
            }
 
    }
}
