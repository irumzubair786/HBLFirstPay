//
//  EditCommitteeExtendedVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 29/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class EditCommitteeExtendedVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!
    @IBOutlet weak var lblInviteFriend: UILabel!
    
    @IBOutlet var participantListTableView: UITableView!
    var partListObj : ParticipantListModel?
    //   var resGenObj : GenericResponse?
    var genericResponseObj : GenericResponse?
    var participantDataList = [Members]()

    var membersList = [String]()
    
    var commId : String?
    var committeeMemberCount : Int?
    var status : String?
    var editAllowed : String?
    var instalmentAmount : String?
    //    var commId : String?
    var installmentAmount : String?
    var committeeMemebers : String?
    var startDate : String?
    var selectedMembers : String?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBottomStartButton: UIView!
    
    @IBOutlet  var instalAmountTextField: UITextField!
    @IBOutlet  var startTextField: UITextField!
    
    @IBOutlet var btn_StartCommittee: UIButton!
    @IBOutlet var btn_AddParticipant: UIButton!
    
    @IBOutlet var dropDownMembers: UIDropDown!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        
        
        if let editAllow = self.editAllowed{
            if editAllow == "N"{
                self.btn_StartCommittee.isHidden = true
                self.btn_AddParticipant.isHidden = true
            }
            else{
                //                self.btn_StartCommittee.isHidden = false
                //                self.btn_AddParticipant.isHidden = false
                if let status = self.status{
                    if status == "I"{
                        self.btn_StartCommittee.isHidden = true
                        self.btn_AddParticipant.isHidden = true
                    }
                    else{
                        self.btn_StartCommittee.isHidden = false
                        self.btn_AddParticipant.isHidden = false
                    }
                }
            }
        }
        
        for n in 3...12 {
            print(n)
            self.membersList.append("\(n)")
        }
   
        self.methodDropDownMembers(Members: membersList)
        
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getParticipantCall()
    }
    
    override func viewWillLayoutSubviews() {
          super.viewWillLayoutSubviews()
          
          scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.viewBottomStartButton.frame.origin.y) + (self.viewBottomStartButton.frame.size.height) + 50)
          
      }
    
    //MARK: - DropDown
    
    private func methodDropDownMembers(Members:[String]) {
        
        self.dropDownMembers.placeholder = self.committeeMemebers
        self.selectedMembers = self.committeeMemebers
        //   self.dropDownMembers.placeholder = "Select Members"
        self.dropDownMembers.tableHeight = 250.0
        self.dropDownMembers.options = Members
        self.dropDownMembers.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.dropDownMembers.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.selectedMembers = option
            
        })
    }
    //MARK: - Utility Methods
    
    func navigateToCommitteeListVC(){
        
        let comList = self.storyboard!.instantiateViewController(withIdentifier: "CommitteeListVC") as! CommitteeListVC
        self.navigationController!.pushViewController(comList, animated: true)
        
    }
    
    func updateUI(){
        
        if let amount = self.installmentAmount {
            self.instalAmountTextField.text = amount
        }
        if let date = self.startDate {
            self.startTextField.text = date
        }
    }
    
    //MARK: - DatePicker Methods
    
    
    @IBAction func textFieldStartDateEditing(sender: UITextField) {
        
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        datePickerObj.minimumDate = datePickerObj.date
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.string(from: datePickerObj.date)
        self.startTextField.text = newDate
        
        
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        startTextField.text = dateFormatter.string(from: sender.date)
        //   DataManager.instance.cnicIssueDate =  sender.date as NSDate
        DataManager.instance.startDateCommittee =  startTextField.text
        
    }
    
    // MARK: - Actions Methods
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        var participantData : Int = 0
     //   var listCount : Int = 0
        if let membersCount = self.selectedMembers{
            participantData = Int(membersCount)!
            print(participantData)
        }
//        if let count = self.partListObj?.participantData?.count{
//            listCount = count
//        }
        
        if self.selectedMembers == nil{
            self.showToast(title: "Please Select Members")
            return
        }
        if instalAmountTextField.text?.count == 0 {
            self.showToast(title: "Please Enter Instalment Amount")
            return
        }
        if startTextField.text?.count == 0 {
            self.showToast(title: "Please Enter Start Date")
            return
        }
//        print(self.partListObj?.participantData!.totalParticipants ?? -1)
//        if participantData < (self.partListObj?.participantData!.totalParticipants ?? -1){
//            self.showDefaultAlert(title: "", message: "Please Add Member")
//            self.btn_AddParticipant.isUserInteractionEnabled = true
//            return
//        }
//        if participantData > (self.partListObj?.participantData!.totalParticipants ?? -1){
//            self.showDefaultAlert(title: "", message: "Please Delete Member")
//            self.btn_AddParticipant.isUserInteractionEnabled = false
//            return
//        }
        
        self.updateCommitteeCall()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
           
           let verPartVC = self.storyboard!.instantiateViewController(withIdentifier: "VerifyParticipantVC") as! VerifyParticipantVC
           verPartVC.commId = self.commId
           verPartVC.committeeMemberCount = self.committeeMemberCount
           self.navigationController!.pushViewController(verPartVC, animated: true)
       }
       @IBAction func startCommitteePressed(_ sender: Any) {
           
           if self.partListObj?.participantData?.totalParticipants != self.committeeMemberCount {
               self.showDefaultAlert(title: "Error", message: "Please Add More Participants")
               return
           }
           for aParticipant in self.participantDataList{
               if aParticipant.requestStatus == "P"{
                   print(aParticipant.requestStatus)
                   self.showDefaultAlert(title: "Error", message: "Not All Have Accepted")
                   return
               }
           }
           self.startCommitteeCall()
       }
    
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.partListObj?.participantData?.members?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "ParticipantTableViewCell") as! ParticipantTableViewCell
        aCell.selectionStyle = .none
        
        let aCommittee = self.partListObj?.participantData!.members?[indexPath.row]
                                                                            
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
            else{
                //                self.btn_StartCommittee.isHidden = false
                //                self.btn_AddParticipant.isHidden = false
                if let status = self.status{
                    if status == "I"{
                        self.btn_StartCommittee.isHidden = true
                        self.btn_AddParticipant.isHidden = true
                        aCell.btn_EditCommittee.isHidden = true
                        aCell.btn_RemoveCommittee.isHidden = true
                    }
                    else{
                        self.btn_StartCommittee.isHidden = false
                        self.btn_AddParticipant.isHidden = false
                        aCell.btn_EditCommittee.isHidden = false
                        aCell.btn_RemoveCommittee.isHidden = false
                    }
                }
            }
        }
        
        if aCommittee?.initiator == "Y"{
            aCell.btn_RemoveCommittee.isHidden = true
        }
        else{
            aCell.btn_RemoveCommittee.isHidden = false
        }
        if aCommittee?.requestStatus == "D"{
            aCell.btn_EditCommittee.isHidden = true
            aCell.btn_RemoveCommittee.isHidden = true
        }
        
        aCell.editCommitteeBlock = {
            
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Edit", message: "Enter Draw Sequence", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
              
                
                if (aCommittee?.drawSequence)! > (self.partListObj?.participantData?.totalParticipants)!
                {
                    UtilManager.showAlertMessage(message: "Draw sequence cant be greator then total participant", viewController: self)
                }
                else
                {
                    textField.text = "\(aCommittee?.drawSequence ?? 0)"
            }
            }
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                self.editCommitteeCall(walletNo: aCommittee?.participantAccountNo, walletTittle: (aCommittee?.participantAccountTitle)!, seq: (textField?.text)!)
                textField?.keyboardType = .numberPad
                print("Text field: \(textField!.text)")
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
    
    
    // MARK: - API CALL
    
    private func updateCommitteeCall() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "updateCommittee"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":self.commId!,"installmentAmount":self.instalAmountTextField.text!,"committeeMemebers":self.selectedMembers!,"startDate":self.startTextField.text!]
        
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
            
            self.genericResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                    self.showAlert(title: "Success", message: (self.genericResponseObj?.messages)!, completion: {
                        self.navigateToCommitteeListVC()
                    })
                }
                else {
                    if let message = self.genericResponseObj?.messages{
                        self.showDefaultAlert(title: "Error", message: message)
                    }
                }
            }
            else {
                if let message = self.genericResponseObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
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
           
           NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<ParticipantListModel>) in
               
               
               self.hideActivityIndicator()
               
               self.partListObj = response.result.value
               
               if response.response?.statusCode == 200 {
                   if self.partListObj?.responsecode == 2 || self.partListObj?.responsecode == 1 {
                       
                    self.participantListTableView.reloadData()
                       
                    if let participants = self.partListObj?.participantData?.members {
                           self.participantDataList = participants
                       }
                       
                    if self.partListObj?.participantData?.totalParticipants == self.committeeMemberCount {
                           self.btn_AddParticipant.isUserInteractionEnabled = false
                       }
                       else {
                           self.btn_AddParticipant.isUserInteractionEnabled = true
                       }
                       
                   }
                   else {
                       if let message = self.partListObj?.messages{
                           self.showDefaultAlert(title: "", message: message)
                       }
                   }
               }
               else {
                   if let message = self.partListObj?.messages{
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
               
               self.genericResponseObj = response.result.value
               
               if response.response?.statusCode == 200 {
                   if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                       if let message = self.genericResponseObj?.messages{
                           self.showDefaultAlert(title: "Success", message: message)
                       }
                   }
                   else {
                       if let message = self.genericResponseObj?.messages{
                           self.showDefaultAlert(title: "", message: message)
                       }
                   }
               }
               else {
                   if let message = self.genericResponseObj?.messages{
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
               
               self.genericResponseObj = response.result.value
               
               if response.response?.statusCode == 200 {
                   if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                       if let message = self.genericResponseObj?.messages{
                           self.showDefaultAlert(title: "Success", message: message)
                       }
                       self.getParticipantCall()
                   }
                   else {
                       if let message = self.genericResponseObj?.messages{
                           self.showDefaultAlert(title: "", message: message)
                       }
                   }
               }
               else {
                   if let message = self.genericResponseObj?.messages{
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
               
               self.genericResponseObj = response.result.value
               
               if response.response?.statusCode == 200 {
                   if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                       if let message = self.genericResponseObj?.messages{
                           self.showDefaultAlert(title: "Success", message: message)
                       }
                       self.getParticipantCall()
                   }
                   else {
                       if let message = self.genericResponseObj?.messages{
                           self.showDefaultAlert(title: "", message: message)
                       }
                   }
               }
               else {
                   if let message = self.genericResponseObj?.messages{
                       self.showDefaultAlert(title: "", message: message)
                   }
//                   print(response.result.value)
//                   print(response.response?.statusCode)
               }
           }
       }
    
}
