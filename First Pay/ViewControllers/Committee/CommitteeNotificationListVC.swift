//
//  CommitteeNotificationListVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 14/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class CommitteeNotificationListVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var notificationListTableView: UITableView!
    var comNotiListObj : CommNotificationListModel?
    var genericObj : GenericResponse?
    
    @IBOutlet weak var lblmain: UILabel!
    
    var notiID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Notification List".addLocalizableString(languageCode: languageCode)
        self.getNotificationListCall()
        
    }
    
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.comNotiListObj?.notificationData?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "CommitteeTableViewCell") as! CommitteeTableViewCell
        aCell.selectionStyle = .none
        
        
        let aNotification = self.comNotiListObj?.notificationData![indexPath.row]
        aCell.backview.dropShadow1()
        aCell.lblFirstTitle.text = aNotification?.committeeName
        aCell.lblSecondTitle.text = aNotification?.notificationMessage
        if let status = aNotification?.status{
            
            if status == "U"{
                aCell.lblreadStatus.text = "Unread"
                aCell.lblreadStatus.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
            else {
                aCell.lblreadStatus.text = "Read"
                aCell.lblreadStatus.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aNotification = self.comNotiListObj?.notificationData![indexPath.row]
        
        let committeeName = "Committee Name : \(aNotification?.committeeName ?? "")"
        let totalAmount = "Total Amount :  PKR:\(aNotification?.tblCommitteeHead?.totalAmount ?? 00)"
        let installmentAmount = "Instalment Amount : \(aNotification?.tblCommitteeHead?.installmentAmount ?? 00)"
        var frequency: String?
        if let freq = aNotification?.tblCommitteeHead?.frequency{
            if freq == "M"{
                frequency = "Frequency : Monthly"
            }
            else if freq == "W"{
                frequency = "Frequency : Weekly"
            }
            else{
                frequency = "Frequency : Daily"
            }
        }
        let totalParticipants = "Total Participants : \(aNotification?.tblCommitteeHead?.totalParticipants ?? 00)"
        
        let splitdate = aNotification?.tblCommitteeHead?.startDate?.components(separatedBy: .whitespaces)
        let startDate = "Start Date : \(splitdate![0])"
        
        if aNotification?.status == "U"{
            
            let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Accept or Reject ? \n\(committeeName) \n\(totalAmount) \n\(installmentAmount) \n\(frequency ?? "") \n\(totalParticipants) \n\(startDate)", preferredStyle: UIAlertControllerStyle.alert)
            
            consentAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
                self.notificationCommitteeActionCall(actionFlag: "A", committeeID: "\(aNotification?.tblCommitteeHead?.committeeHeadId ?? 00)")
                self.notiID = "\(aNotification?.committeeNotificationId ?? 00)"
                self.dismiss(animated: true, completion:nil)
            }))
            consentAlert.addAction(UIAlertAction(title: "Reject", style: .default, handler: { (action: UIAlertAction!) in
                self.notificationCommitteeActionCall(actionFlag: "R", committeeID: "\(aNotification?.tblCommitteeHead?.committeeHeadId ?? 00)")
                self.notiID = "\(aNotification?.committeeNotificationId ?? 00)"
                self.dismiss(animated: true, completion:nil)
            }))
            consentAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
                self.dismiss(animated: true, completion:nil)
            }))
            present(consentAlert, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: - API CALL
    
    private func getNotificationListCall() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "committeeNotification"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<CommNotificationListModel>) in
            
            
            self.hideActivityIndicator()
            
            self.comNotiListObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.comNotiListObj?.responsecode == 2 || self.comNotiListObj?.responsecode == 1 {
                    self.notificationListTableView.reloadData()
                }
                else {
                    if let message = self.comNotiListObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.comNotiListObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    private func notificationCommitteeActionCall(actionFlag : String? , committeeID : String?) {

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


        let compelteUrl = GlobalConstants.BASE_URL + "committeeAction"


        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":committeeID!,"actionFlag":actionFlag!]
      
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

            self.genericObj = response.result.value

            if response.response?.statusCode == 200 {
                if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
//                    if let message = self.genericObj?.messages{
//                        self.showDefaultAlert(title: "Success", message: message)
//                    }
                    
                    self.notificationAcceptReject(notificationID: self.notiID)
                }
                else {
                    if let message = self.genericObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.comNotiListObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    private func notificationAcceptReject(notificationID : String?) {

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


        let compelteUrl = GlobalConstants.BASE_URL + "committeeNotificationAction"


        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"notificationId":notificationID!]

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

            self.genericObj = response.result.value

            if response.response?.statusCode == 200 {
                if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                    self.getNotificationListCall()
                    if let message = self.genericObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
                else {
                    if let message = self.genericObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.comNotiListObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
   
    
    @IBAction func backpressed(_ sender: UIButton) {
        
     let commListVC = self.storyboard!.instantiateViewController(withIdentifier: "CommitteeMainVC") as! CommitteeMainVC
        commListVC.ischecked = "false"
        
    self.navigationController!.pushViewController(commListVC, animated: true)
    }
    
}

