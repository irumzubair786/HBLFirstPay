//
//  DisputeTransactionVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 19/04/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class DisputeTransactionVC: BaseClassVC {
    
    @IBOutlet var dropDownDisputes: UIDropDown!
    @IBOutlet weak var commentsTextField: UITextField!
    var selectedDispute: String?
    var disputeTypesObj : GetDisputeTypesModel?
    var genResObj : GenericResponse?
    var disputesList = [SingleDispute]()
    var arrDisputesList : [String]?
    var disputeCode : Int?
    var transRefnum : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        self.getDisputes()
        print("\(transRefnum)")
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var lbldisputeType: UILabel!
    @IBOutlet weak var lblmainTitle: UILabel!
    
    
    func ChangeLanguage()
    
    {
        
        
        lblmainTitle.text = "Dispute Transaction".addLocalizableString(languageCode: languageCode)
        lbldisputeType.text = "Dispute Type".addLocalizableString(languageCode: languageCode)
        lblComments.text = "Comments".addLocalizableString(languageCode: languageCode)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnSubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
//        
    }
    //MARK: - DropDown
    
    private func methodDropDownDisputes(Disputes:[String]) {
        
        self.dropDownDisputes.placeholder = "Select Dispute"
        self.dropDownDisputes.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        self.dropDownDisputes.options = Disputes
        self.dropDownDisputes.tableHeight = 200.0
        self.dropDownDisputes.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.selectedDispute = option
            
            let title = self.selectedDispute
            for aDispute in self.disputesList {
                if aDispute.disputeTypeDescr == title {
                    self.disputeCode = aDispute.disputeTypeId
                    
                }
            }
        })
    }
    
    // MARK: - Action Methods
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        if self.commentsTextField .text?.count == 0 {
            self.showToast(title: "Please enter comments")
            return
        }
        if self.disputeCode == nil{
            self.showToast(title: "Please select Dispute Type")
            return
        }
        
        self.disputeTransaction()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        print("done")
        self.navigationController!.popViewController(animated: true)
    }
    
    // MARK: - API CALL
    
    private func getDisputes() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getDisputeTypes"
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetDisputeTypesModel>) in
            
            
            self.hideActivityIndicator()
            
            self.disputeTypesObj = response.result.value
            
            if response.response?.statusCode == 200 {
                
                if self.disputeTypesObj?.responsecode == 2 || self.disputeTypesObj?.responsecode == 1 {
                    if let disputes = self.disputeTypesObj?.disputeTypes {
                        self.disputesList = disputes
                    }
                    self.arrDisputesList = self.disputeTypesObj?.stringDisputesList
                    self.methodDropDownDisputes(Disputes: (self.arrDisputesList)!)
                    
                }
                else {
                    if let message = self.disputeTypesObj?.messages{
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    private func disputeTransaction() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "disputeTransaction"
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"comments":self.commentsTextField.text!,"transRefNum":self.transRefnum!,"disputeType":("\(self.disputeCode!)")] as [String : Any]
        
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
            
            self.genResObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    self.showAlert(title: "Success", message: self.genResObj!.messages!, completion: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }
                else {
                    if let message = self.genResObj?.messages{
                        self.showDefaultAlert(title: "", message: "\(message)")
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
            else {
                if let message = self.genResObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
}
