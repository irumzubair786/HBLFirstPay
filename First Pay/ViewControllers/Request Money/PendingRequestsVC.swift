//
//  PendingRequestsVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 16/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class PendingRequestsVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var lblmainTitle: UILabel!
    @IBOutlet var pendingRequestTableView: UITableView!
    var pendingRequestsObj:PendingRequestsModel?
    var resGenericObj:GenericResponse?
    @IBOutlet var dropDownOptions: UIDropDown!
    var arrApproved = [PendingData]()
    var arrRejected = [PendingData]()
    var arrPending = [PendingData]()
    var indexOfDropDown : String?
    var status : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmainTitle.text = "Pending Request".addLocalizableString(languageCode: languageCode)
        // Do any additional setup after loading the view.
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestMoneyDetails()
        self.methodDropDownOptions()
    }
    var arrurdu = ["منظورشدہ","مسترد","پینڈنگ"]
    
    //MARK: - DropDown
    
    private func methodDropDownOptions() {
        
        
        self.dropDownOptions.tableHeight = 150.0
        self.dropDownOptions.placeholder = "ALL".addLocalizableString(languageCode: languageCode)
        self.dropDownOptions.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        self.dropDownOptions.options = ["Approved","Rejected","Pending"]
        self.dropDownOptions.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            
            if index == 0 {
                self.indexOfDropDown = "0"
                self.pendingRequestTableView.reloadData()
            }
            else if index == 1{
                self.indexOfDropDown = "1"
                self.pendingRequestTableView.reloadData()
            }
            else {
                self.indexOfDropDown = "2"
                self.pendingRequestTableView.reloadData()
            }
            
        })
    }
    
    // MARK: - Utlity Methods
    
    
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if indexOfDropDown == "0"{
            return arrApproved.count
        }
        else if indexOfDropDown == "1"{
            return arrRejected.count
        }
        else if indexOfDropDown == "2"{
            return arrPending.count
        }
        else {
            if let count = self.pendingRequestsObj?.pendingData?.count{
                return count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "PendingRequestsTableViewCell") as! PendingRequestsTableViewCell
        aCell.selectionStyle = .none
        
        
        if indexOfDropDown == "0"{
            let aRequest = self.arrApproved[indexPath.row]
            
            aCell.lblFrom.text = aRequest.accountTitle
            aCell.lblAmount.text =  "PKR. \(aRequest.amount ?? 0)"
            aCell.lblReason.text = aRequest.comments
            aCell.lblDateAndTime.text = aRequest.requestDate
            aCell.lblStatus.text = aRequest.statusDescr
        }
        else if indexOfDropDown == "1"{
            let aRequest = self.arrRejected[indexPath.row]
            
            aCell.lblFrom.text = aRequest.accountTitle
            aCell.lblAmount.text =  "PKR. \(aRequest.amount ?? 0)"
            aCell.lblReason.text = aRequest.comments
            aCell.lblDateAndTime.text = aRequest.requestDate
            aCell.lblStatus.text = aRequest.statusDescr
        }
        else if indexOfDropDown == "2"{
            let aRequest = self.arrPending[indexPath.row]
            
            aCell.lblFrom.text = aRequest.accountTitle
            aCell.lblAmount.text =  "PKR. \(aRequest.amount ?? 0)"
            aCell.lblReason.text = aRequest.comments
            aCell.lblDateAndTime.text = aRequest.requestDate
            aCell.lblStatus.text = aRequest.statusDescr
        }
        else{
            
            let aRequest = self.pendingRequestsObj?.pendingData![indexPath.row]
            aCell.lblFrom.text = aRequest?.accountTitle
            aCell.lblAmount.text =  "PKR. \(aRequest?.amount ?? 0)"
            aCell.lblReason.text = aRequest?.comments
            aCell.lblDateAndTime.text = aRequest?.requestDate
            aCell.lblStatus.text = aRequest?.statusDescr
            
        }
        
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        
        if indexOfDropDown == "0"{
            let aRequest = self.arrApproved[indexPath.row]
            
            if aRequest.status == "P"{
                
                let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Accept or Reject".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
                
                consentAlert.addAction(UIAlertAction(title: "Accept".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                    
                    let localFundVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundTransferVC") as! LocalFundTransferVC
                    localFundVC.beneficiaryAccount = aRequest.accountNo
                    localFundVC.requestedAmount = "\(aRequest.amount ?? 0)"
                    localFundVC.requesterMoneyId = "\(aRequest.requesterMoneyId ?? 0)"
                    localFundVC.isFromRequestMoney = true
                    self.navigationController!.pushViewController(localFundVC, animated: true)
                    
//                    self.status = "A"
//                    self.requestMoneyAcceptReject(requestID: (aRequest.requesterMoneyId)!, amount: "\(aRequest.amount ?? 0)", accountNo: (aRequest.accountNo)!)
                    
                    self.dismiss(animated: true, completion:nil)
                }))
                
                consentAlert.addAction(UIAlertAction(title: "Reject".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.status = "R"
                    self.requestMoneyAcceptReject(requestID: (aRequest.requesterMoneyId)!, amount: "\(aRequest.amount ?? 0)", accountNo: (aRequest.accountNo)!)
                    
                    self.dismiss(animated: true, completion:nil)
                }))
                
                present(consentAlert, animated: true, completion: nil)
                
            }
            else if aRequest.status == "A"{
                self.showDefaultAlert(title: "Message", message: "Already Approved")
                
            }
            else {
                
                self.showDefaultAlert(title: "Message", message: "Request Rejected")
            }
            
            
        }
        else if indexOfDropDown == "1"{
            let aRequest = self.arrRejected[indexPath.row]
            
            if aRequest.status == "P"{
                
                let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Accept or Reject".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
                
                consentAlert.addAction(UIAlertAction(title: "Accept".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                    
                    let localFundVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundTransferVC") as! LocalFundTransferVC
                    localFundVC.beneficiaryAccount = aRequest.accountNo
                    localFundVC.requestedAmount = "\(aRequest.amount ?? 0)"
                    localFundVC.requesterMoneyId = "\(aRequest.requesterMoneyId ?? 0)"
                    localFundVC.isFromRequestMoney = true
                    self.navigationController!.pushViewController(localFundVC, animated: true)
                    
//                    self.status = "A"
//                    self.requestMoneyAcceptReject(requestID: (aRequest.requesterMoneyId)!, amount: "\(aRequest.amount ?? 0)", accountNo: (aRequest.accountNo)!)
                    
                    self.dismiss(animated: true, completion:nil)
                }))
                
                consentAlert.addAction(UIAlertAction(title: "Reject".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.status = "R"
                    self.requestMoneyAcceptReject(requestID: (aRequest.requesterMoneyId)!, amount: "\(aRequest.amount ?? 0)", accountNo: (aRequest.accountNo)!)
                    
                    self.dismiss(animated: true, completion:nil)
                }))
                
                present(consentAlert, animated: true, completion: nil)
                
            }
            else if aRequest.status == "A"{
                self.showDefaultAlert(title: "Message", message: "Already Approved")
                
            }
            else {
                
                self.showDefaultAlert(title: "Message", message: "Request Rejected")
            }
            
            
        }
        else if indexOfDropDown == "2"{
            let aRequest = self.arrPending[indexPath.row]
            
            if aRequest.status == "P"{
                
                let consentAlert = UIAlertController(title: "Alert".addLocalizableString(languageCode: languageCode), message: "Do you want to Accept or Reject", preferredStyle: UIAlertControllerStyle.alert)
                
                consentAlert.addAction(UIAlertAction(title: "Accept".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                    
                    let localFundVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundTransferVC") as! LocalFundTransferVC
                    localFundVC.beneficiaryAccount = aRequest.accountNo
                    localFundVC.requestedAmount = "\(aRequest.amount ?? 0)"
                    localFundVC.requesterMoneyId = "\(aRequest.requesterMoneyId ?? 0)"
                    localFundVC.isFromRequestMoney = true
                    self.navigationController!.pushViewController(localFundVC, animated: true)
                    
//                    self.status = "A"
//                    self.requestMoneyAcceptReject(requestID: (aRequest.requesterMoneyId)!, amount: "\(aRequest.amount ?? 0)", accountNo: (aRequest.accountNo)!)
                    
                    self.dismiss(animated: true, completion:nil)
                }))
                
                consentAlert.addAction(UIAlertAction(title: "Reject".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.status = "R"
                    self.requestMoneyAcceptReject(requestID: (aRequest.requesterMoneyId)!, amount: "\(aRequest.amount ?? 0)", accountNo: (aRequest.accountNo)!)
                    
                    self.dismiss(animated: true, completion:nil)
                }))
                
                present(consentAlert, animated: true, completion: nil)
                
            }
            else if aRequest.status == "A"{
                self.showDefaultAlert(title: "Message", message: "Already Approved")
                
            }
            else {
                
                self.showDefaultAlert(title: "Message", message: "Request Rejected")
            }
            
            
        }
        else{
            
            let aRequest = self.pendingRequestsObj?.pendingData![indexPath.row]
            
            if aRequest?.status == "P"{
                
                let consentAlert = UIAlertController(title: "Alert".addLocalizableString(languageCode: languageCode), message: "Do you want to Accept or Reject", preferredStyle: UIAlertControllerStyle.alert)
                
                consentAlert.addAction(UIAlertAction(title: "Accept".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                    
                    let localFundVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundTransferVC") as! LocalFundTransferVC
                    localFundVC.beneficiaryAccount = aRequest?.accountNo
                    localFundVC.requestedAmount = "\(aRequest?.amount ?? 0)"
                    localFundVC.requesterMoneyId = "\(aRequest?.requesterMoneyId ?? 0)"
                    localFundVC.isFromRequestMoney = true
                    self.navigationController!.pushViewController(localFundVC, animated: true)
                    
//                    self.status = "A"
//                    self.requestMoneyAcceptReject(requestID: (aRequest?.requesterMoneyId)!, amount: "\(aRequest?.amount ?? 0)", accountNo: (aRequest?.accountNo)!)
                    
                    self.dismiss(animated: true, completion:nil)
                }))
                
                consentAlert.addAction(UIAlertAction(title: "Reject".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
                    
                    self.status = "R"
                    self.requestMoneyAcceptReject(requestID: (aRequest?.requesterMoneyId)!, amount: "\(aRequest?.amount ?? 0)", accountNo: (aRequest?.accountNo)!)
                    
                    self.dismiss(animated: true, completion:nil)
                }))
                
                consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
                    
                    self.dismiss(animated: true, completion:nil)
                }))
                
                present(consentAlert, animated: true, completion: nil)
                
            }
            else if aRequest?.status == "A"{
                self.showDefaultAlert(title: "Message", message: "Already Approved")
                
            }
            else {
                
                self.showDefaultAlert(title: "Message", message: "Request Rejected")
            }
            
            
        }
        
        
        //      let aRequest = self.pendingRequestsObj?.pendingData![indexPath.row]
        
        //        if aRequest?.status == "P"{
        //
        //            let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Accept or Reject", preferredStyle: UIAlertControllerStyle.alert)
        //
        //            consentAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
        //
        //                self.status = "A"
        //                self.requestMoneyAcceptReject(requestID: (aRequest?.requesterMoneyId)!, amount: "\(aRequest?.amount ?? 0)", accountNo: (aRequest?.accountNo)!)
        //
        //                self.dismiss(animated: true, completion:nil)
        //            }))
        //
        //            consentAlert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
        //
        //                self.status = "R"
        //                self.requestMoneyAcceptReject(requestID: (aRequest?.requesterMoneyId)!, amount: "\(aRequest?.amount ?? 0)", accountNo: (aRequest?.accountNo)!)
        //
        //                self.dismiss(animated: true, completion:nil)
        //            }))
        //
        //            present(consentAlert, animated: true, completion: nil)
        //
        //        }
        //        else if aRequest?.status == "A"{
        //            self.showDefaultAlert(title: "Message", message: "Already Approved")
        //
        //        }
        //        else {
        //
        //            self.showDefaultAlert(title: "Message", message: "Request Rejected")
        //        }
        
        //        for aRequest in (self.pendingRequestsObj!.pendingData)!{
        //
        //            if aRequest.status == "P"{
        //
        //                let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Accept or Reject", preferredStyle: UIAlertControllerStyle.alert)
        //
        //                consentAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
        //
        //                    self.requestMoneyAcceptReject(requestID: (aRequest.requesterMoneyId)!, status: "A")
        //                    self.dismiss(animated: true, completion:nil)
        //                }))
        //
        //                consentAlert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
        //
        //                    self.requestMoneyAcceptReject(requestID: (aRequest.requesterMoneyId)!, status: "R")
        //                    self.dismiss(animated: true, completion:nil)
        //                }))
        //
        //                present(consentAlert, animated: true, completion: nil)
        //
        //            }
        //        }
    }
    
    
    // MARK: - API call
    
    func requestMoneyDetails() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getRequestMoneyDetail"
        
        let params = ["":""] as [String : Any]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<PendingRequestsModel>) in
            
            self.hideActivityIndicator()
            
            self.pendingRequestsObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.pendingRequestsObj?.responsecode == 2 || self.pendingRequestsObj?.responsecode == 1 {
                    
                    for aRequest in (self.pendingRequestsObj!.pendingData)!{
                        
                        if aRequest.status == "P" {
                            self.arrPending.append(aRequest)
                        }
                        if aRequest.status == "A" {
                            self.arrApproved.append(aRequest)
                        }
                        if aRequest.status == "R" {
                            self.arrRejected.append(aRequest)
                        }
                    }
                    self.pendingRequestTableView.reloadData()
                }
                else {
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    func requestMoneyAcceptReject( requestID:Int , amount:String, accountNo:String) {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "requestMoneyApproveReject"
        
        let parameters =  ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"requestId":"\(requestID)","status":self.status!] as [String : Any]
        
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
            
            self.resGenericObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.resGenericObj?.responsecode == 2 || self.resGenericObj?.responsecode == 1 {
                    
                    if self.status == "A"{
                        
                        let localFundVC = self.storyboard!.instantiateViewController(withIdentifier: "LocalFundTransferVC") as! LocalFundTransferVC
                        localFundVC.beneficiaryAccount = accountNo
                        localFundVC.requestedAmount = amount
                        localFundVC.isFromRequestMoney = true
                        self.navigationController!.pushViewController(localFundVC, animated: true)
                        
                    }
                    else{
                        
                        self.showAlert(title: "Message", message: "Rejected Sucessfully", completion: {
                            
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                    }
                }
                else {
                    self.showDefaultAlert(title: "", message: self.resGenericObj!.messages!)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
}
