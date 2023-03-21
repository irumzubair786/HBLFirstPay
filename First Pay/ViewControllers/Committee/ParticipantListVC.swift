//
//  ParticipantListVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 08/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class ParticipantListVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var participantListTableView: UITableView!
//    var partListObj : ParticipantListModel?
    var participantobj : ParticipantModelUpdate?
    var comitemodelobj : CommitteeListModel?
    var resGenObj : GenericResponse?
    var commId : String?
    var committeeMemberCount : Int?
   
    @IBOutlet var btn_StartCommittee: UIButton!
    @IBOutlet var btn_AddParticipant: UIButton!
    
    var status : String?
    var editAllowed : String?
    var instalmentAmount : String?
    
//    var participantDataList = [Members]()
    
        override func viewDidLoad() {
        super.viewDidLoad()
            participantListTableView.delegate = self
            participantListTableView.dataSource = self
            btn_StartCommittee.isHidden = true
            btn_AddParticipant.isHidden = true
           
        self.getParticipantCall()
           
            
//        if let editAllow = self.editAllowed{
//            if editAllow == "N"{
//                self.btn_StartCommittee.isHidden = false
//                self.btn_AddParticipant.isHidden = true
//
//
//
//            }
//            else{
//                                self.btn_StartCommittee.isHidden = true
//                                self.btn_AddParticipant.isHidden = false
//                if let status = self.status{
//                    if status == "I"{
//                        self.btn_StartCommittee.isHidden = true
//                        self.btn_AddParticipant.isHidden = true
//                    }
//                    else{
//                        self.btn_StartCommittee.isHidden = false
//                        self.btn_AddParticipant.isHidden = false
//                    }
//                }
//            }
//
//
//        }
        
        
        
        //  self.getParticipantCall()
        //        self.btn_StartCommittee.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getParticipantCall()
    
        
        
    }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.participantobj?.dataobj?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "ParticipantTableViewCell") as! ParticipantTableViewCell
        aCell.selectionStyle = .none
        
        let aCommittee = self.participantobj?.dataobj![indexPath.row]
        
        aCell.lblFirstTitle.text = aCommittee?.participantAccountTitle
        aCell.lblSecondTitle.text = aCommittee?.participantAccountNo
        aCell.lblDrawSequence.text = "Draw Sequence : \(aCommittee?.drawSequence ?? 00)"
        if let status = aCommittee?.requestStatus{
            if status == "A"{
                aCell.lblRequestStatus.text = "Status : Accepted"
            }
            if status == "P"{
                aCell.lblRequestStatus.text = "Status : Pending"
            }
            if status == "R"{
                aCell.lblRequestStatus.text = "Status : Rejected"
            }
            if status == "D"{
                aCell.lblRequestStatus.text = "Status : Deleted"
            }
        }
        if let received = aCommittee?.committeeReceived{
            if received == "Y"{
                aCell.lblReceived.text = "Recieved : Yes"
            }
            else if received == "N"{
                aCell.lblReceived.text = "Recieved : No"
            }
        }
        if let ini = aCommittee?.initiator{
            if ini == "Y"{
                aCell.lblIniator.text = "Initiator"
            }
            else {
                aCell.lblIniator.text = "Participant"
            }
        }
        if let amount = self.instalmentAmount{
            aCell.lblInstalmentAmount.text = "Instalment Amount : \(amount)"
        }
        if let editAllow = self.editAllowed{
            if editAllow == "N"{
                self.btn_StartCommittee.isHidden = true
                self.btn_AddParticipant.isHidden = true
                aCell.btn_EditCommittee.isHidden = true
                aCell.btn_RemoveCommittee.isHidden = true
            }
            if aCell.lblRequestStatus.text == "Status : Accepted"
            {
                self.btn_StartCommittee.isHidden = false
                self.btn_AddParticipant.isHidden = false
                aCell.btn_EditCommittee.isHidden = false
                aCell.btn_RemoveCommittee.isHidden = false
            }
            
                                
                if let status = self.status{
                    if status == "I"{
                        self.btn_StartCommittee.isHidden = true
                        self.btn_AddParticipant.isHidden = true
                        aCell.btn_EditCommittee.isHidden = true
                        aCell.btn_RemoveCommittee.isHidden = true
                    }
                    if aCell.lblRequestStatus.text == "Status : Accepted"
                    {
                        self.btn_StartCommittee.isHidden = false
                        self.btn_AddParticipant.isHidden = false
                        aCell.btn_EditCommittee.isHidden = false
                        aCell.btn_RemoveCommittee.isHidden = false
                    }
                    
//                    else
//                    {
//                        self.btn_StartCommittee.isHidden = false
//                        self.btn_AddParticipant.isHidden = false
//                        aCell.btn_EditCommittee.isHidden = false
//                        aCell.btn_RemoveCommittee.isHidden = false
//                    }
                }
            
        }
        
        if aCommittee?.initiator == "Y"{
            aCell.btn_RemoveCommittee.isHidden = true
        }
        else{
            aCell.btn_RemoveCommittee.isHidden = false
        }
        
        aCell.editCommitteeBlock = {
            
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Edit", message: "Enter Draw Sequence", preferredStyle: .alert)

            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "\(aCommittee?.drawSequence ?? 0)"
                            }

            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                print(textField?.text!)
                print("\(self.committeeMemberCount ?? -1)")
               
               if ((textField?.text)! <= "\(self.committeeMemberCount ?? -1)")
               {
                print(textField?.text!)

                self.editCommitteeCall(walletNo: aCommittee?.participantAccountNo, walletTittle: (aCommittee?.participantAccountTitle)!, seq: (textField?.text)! )
                
                textField?.keyboardType = .numberPad
                print("Text field: \(textField!.text)")
               }
               else if (((textField?.text)! >  "\(self.committeeMemberCount ?? -1)"))
                {
                    UtilManager.showAlertMessage(message: "Draw Sequence should not be greator then total committee members", viewController: self)
                }
                 
               
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
                self.dismiss(animated: true, completion:nil)
            }))

            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
            
            
            NSLog ("You selected row: %@ \(indexPath)")
        }
        
        aCell.removeCommitteeBlock = {
            
            self.removeCommitteeCall(walletNo: aCommittee?.participantAccountNo, walletTittle: (aCommittee?.participantAccountTitle)!, seq: "\(aCommittee?.drawSequence ?? 0)")
            NSLog ("You selected row: %@ \(indexPath)")
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
//        let aCommittee = self.partListObj?.participantData![indexPath.row]
        
        
        
    }
    
    
    // MARK: - Actions Methods
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let verPartVC = self.storyboard!.instantiateViewController(withIdentifier: "VerifyParticipantVC") as! VerifyParticipantVC
        verPartVC.commId = self.commId
        verPartVC.committeeMemberCount = self.committeeMemberCount
        self.navigationController!.pushViewController(verPartVC, animated: true)
    }
    @IBAction func startCommitteePressed(_ sender: Any) {
        
        if self.participantobj?.dataobj?.count != self.committeeMemberCount {
            self.showDefaultAlert(title: "Error", message: "Please Add More Participants")
            return
        }
//        for aParticipant in self.participantobj?.dataobj.{
//            if aParticipant.requestStatus == "P"{
//                print(aParticipant.requestStatus)
//                self.showDefaultAlert(title: "Error", message: "Not All Have Accepted")
//                return
//            }
//        }
        self.startCommitteeCall()
    }
    
    // MARK: - API CALL
    
    private func getParticipantCall() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "getCommitteeParticipants"
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":self.commId!]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<ParticipantModelUpdate>) in
            
            self.hideActivityIndicator()
            
            self.participantobj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.participantobj?.responsecode == 2 || self.participantobj?.responsecode == 1 {
                    self.participantListTableView.reloadData()
                    
                    if let participants = self.participantobj?.dataobj{
                        self.participantobj?.dataobj = participants
                    }
                    
                    if self.participantobj?.dataobj?.count == self.committeeMemberCount {
//                        self.btn_AddParticipant.isUserInteractionEnabled = false
                    }
//                    if self.participantobj?.dataobj?[0].
                    else {
                        self.btn_AddParticipant.isUserInteractionEnabled = true
                    }
                    
                }
                else {
                    if let message = self.participantobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.participantobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
    // MARK: - API CALL
    
    private func startCommitteeCall() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "startCommittee"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":self.commId!]
        
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
            
            self.resGenObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.resGenObj?.responsecode == 2 || self.resGenObj?.responsecode == 1 {
                    if let message = self.resGenObj?.messages{
                        self.showDefaultAlert(title: "Success", message: message)
                    }
                }
                else {
                    if let message = self.resGenObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.resGenObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
    private func editCommitteeCall(walletNo:String?, walletTittle:String, seq:String) {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "updateParticipant"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":self.commId!,"walletNo":walletNo!,"walletTitle":walletTittle,"drawSeq":seq,"updateFlag":"U"]
        
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
            
            self.resGenObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.resGenObj?.responsecode == 2 || self.resGenObj?.responsecode == 1 {
                    if let message = self.resGenObj?.messages{
                        self.showDefaultAlert(title: "Success", message: message)
                    }
                    self.getParticipantCall()
                }
                else {
                    if let message = self.resGenObj?.messages{
                        
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.resGenObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
    private func removeCommitteeCall(walletNo:String?, walletTittle:String, seq:String) {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "updateParticipant"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":self.commId!,"walletNo":walletNo!,"walletTitle":walletTittle,"drawSeq":seq,"updateFlag":"R"]
        
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
            
            self.resGenObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.resGenObj?.responsecode == 2 || self.resGenObj?.responsecode == 1 {
                    if let message = self.resGenObj?.messages{
                        self.showDefaultAlert(title: "Success", message: message)
                    }
                    self.getParticipantCall()
                }
                else {
                    if let message = self.resGenObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.resGenObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                print(response.result.value ?? 0)
                print(response.response?.statusCode ?? 0)
            }
        }
    }
    
}

