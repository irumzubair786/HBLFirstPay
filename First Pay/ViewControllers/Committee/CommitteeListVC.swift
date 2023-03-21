//
//  CommitteeListVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 08/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class CommitteeListVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
    var ischecked = "false"
    @IBOutlet var commListTableView: UITableView!
    var commListObj : CommitteeListModel?
   
    @IBOutlet weak var lblMainTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMainTitle.text = "Commitee List".addLocalizableString(languageCode: languageCode)
        self.getCommitteeListCall()
        
    }
    
 
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.commListObj?.committeedata?.count{
            return count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "CommitteeTableViewCell") as! CommitteeTableViewCell
        aCell.selectionStyle = .none
        
        
        let aCommittee = self.commListObj?.committeedata![indexPath.row]
        
        var freq : String? = ""
          
        if let frequence = aCommittee?.frequency{
            if frequence == "M"{
                freq = "Monthly"
            }
            else if frequence == "W"{
                freq = "Weekly"
            }
            else{
                freq = "Daily"
            }
        }
        aCell.lblFirstTitle.text = "Title : \(aCommittee?.committeeDescr ?? "") - \(freq ?? "")"
        aCell.lblSecondTitle.text = "Admin : \(aCommittee?.adminAccountTitle ?? "")"
        aCell.lblTotalAmount.text = "Total Amount: \( convertToCurrrencyFormat(amount: "\(aCommittee?.totalAmount ?? 0)"))"
//        print(lblTotalAmount.text)
        aCell.lblTotalParticipant.text = "Total Participant: \(aCommittee?.totalParticipants ?? 00)"
//        aCell.lblStartDate.text = "Start Date: \(aCommittee?.startDate ?? "")"
        
        let splitdate = aCommittee?.startDate?.components(separatedBy: .whitespaces)
        print(splitdate!)
        aCell.lblStartDate.text = "Start Date: \(splitdate![0])"
        
//        let a = aCommittee?.startDate?.replacingOccurrences(of: "00:00:00:00", with: "")
//        print(a)
//        aCell.lblStartDate.text = "Start Date: \(a)"
        
        
        
//        aCell.lblStartDate.text = "Start Date: \(AppDelegate.dateformatter.date(from: "\(aCommittee?. ?? 0)"))"
//        let a = AppDelegate.dateformatter.date(from: (aCommittee?.startDate)!)
//        aCell.lblStartDate.text  = "Start Date: \(a)"
     
     
        if let aStatus = aCommittee?.status{
            print(aStatus)
            if aStatus == "I"{
                aCell.lblStatus.text = "Status : Started"
            }
           
            if aStatus == "P"{
                let a = (aCommittee?.installmentAmount)
                let b = aCommittee?.totalParticipants
                aCell.lblStatus.text = "Status : Pending"
                print("aaaa",aCommittee?.totalAmount)
                if aCommittee?.totalAmount == nil{
                    aCell.lblTotalAmount.text = "Total Amount:  PKR:\(0)"
                }
                if aStatus == "C"
                {
                    aCell.lblStatus.text = "Status : Completed"
                }
                else{
                    
                    aCell.lblTotalAmount.text = "PKR: \(aCommittee?.totalAmount)"
                }
            }
        }
        
//        aCell.comitteeActionBlock = {
//            
//            let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCommitteeVC") as! EditCommitteeVC
//            editVC.commId = "\(aCommittee?.committeeHeadId ?? 00)"
//            editVC.committeeMemebers = "\(aCommittee?.totalParticipants ?? 00)"
//            editVC.installmentAmount = "\(aCommittee?.installmentAmount ?? 00)" 
//            editVC.startDate =  "\(aCommittee?.startDate ?? "")"
//            
//            self.navigationController!.pushViewController(editVC, animated: true)
//            
//            
//            NSLog ("You selected row: %@ \(indexPath)")
//        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aCommittee = self.commListObj?.committeedata![indexPath.row]
        
        let comDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "CommitteeDetailsVC") as! CommitteeDetailsVC
        comDetailsVC.commId = "\(aCommittee?.committeeHeadId ?? 00)"
        
        self.navigationController!.pushViewController(comDetailsVC, animated: true)
        
    }
   



    
    // MARK: - API CALL
//    func convertDateFormater(_ date: String) -> String
//    {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let date = dateFormatter.date(from: date)
//   //     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // MMM d, yyyy
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        return  dateFormatter.string(from: date!)
//
//    }
    private func getCommitteeListCall() {
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "getCommittee"
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<CommitteeListModel>) in
            
            
            self.hideActivityIndicator()
            
            self.commListObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.commListObj?.responsecode == 2 || self.commListObj?.responsecode == 1 {
                    self.commListTableView.reloadData()
                }
                else {
                    if let message = self.commListObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.commListObj?.messages{
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
