//
//  InstalmentDetailsVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 21/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class InstalmentDetailsVC: BaseClassVC, UITableViewDelegate , UITableViewDataSource {
    var  ischecked = ""
    @IBOutlet var commListTableView: UITableView!
    var commListObj : CommitteeListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMaintitle.text = "Installment List".addLocalizableString(languageCode: languageCode)
        self.getCommitteeListCall()
        
    }
    
    @IBOutlet weak var lblMaintitle: UILabel!
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
        
        DataManager.instance.commiteeid = self.commListObj?.committeedata?[indexPath.row].committeeHeadId
        let aCommittee = self.commListObj?.committeedata![indexPath.row]
        
        aCell.lblFirstTitle.text = aCommittee?.committeeDescr
        aCell.lblSecondTitle.text = aCommittee?.adminAccountTitle
        aCell.lblTotalAmount.text = "Total Amount:     PKR: \( aCommittee?.totalAmount ?? 00)"
        aCell.lblTotalParticipant.text = "Total Participant: \(aCommittee?.totalParticipants ?? 00)"
        let splitdate = aCommittee?.startDate?.components(separatedBy: .whitespaces)
        print(splitdate!)
        aCell.lblStartDate.text = "Start Date: \(splitdate![0])"
    
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        let aCommittee = self.commListObj?.committeedata![indexPath.row]
        if ischecked == "true"
        {
          print("do nothing")
        }
        
        else{
            let instalDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "InstallmentVc") as! InstallmentVc
            instalDetailsVC.commId = "\(aCommittee?.committeeHeadId! ?? 00)"
            
            print("id is",aCommittee?.committeeHeadId!)
            instalDetailsVC.fineAmount = "\(aCommittee?.fineAmount ?? 00)"
    //
            self.navigationController!.pushViewController(instalDetailsVC, animated: true)
        }
        
    }
    
   
    // MARK: - API CALL
    
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
    
    
    @IBAction func backpreesd(_ sender: UIButton) {
     let commListVC = self.storyboard!.instantiateViewController(withIdentifier: "CommitteeMainVC") as! CommitteeMainVC
        commListVC.ischecked = "false"
    self.navigationController!.pushViewController(commListVC, animated: true)
    }
    
}
