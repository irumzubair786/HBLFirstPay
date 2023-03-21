//
//  MyPendingRequestsVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 16/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class MyPendingRequestsVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet var myRequestTableView: UITableView!
    var myPendingRequestsObj:PendingRequestsModel?
    @IBOutlet var dropDownOptions: UIDropDown!
    var arrApproved = [PendingData]()
    var arrRejected = [PendingData]()
    var arrPending = [PendingData]()
    var indexOfDropDown : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMainTitle.text = "My Pending Request".addLocalizableString(languageCode: languageCode )
        // Do any additional setup after loading the view.
      
        self.requestMoneyDetails()
        self.methodDropDownOptions()
    }
    
    
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
                self.myRequestTableView.reloadData()
            }
            else if index == 1{
                self.indexOfDropDown = "1"
                self.myRequestTableView.reloadData()
            }
            else{
                self.indexOfDropDown = "2"
                self.myRequestTableView.reloadData()
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
            if let count = self.myPendingRequestsObj?.pendingData?.count{
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
            
            let aRequest = self.myPendingRequestsObj?.pendingData![indexPath.row]
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
        
        //            let aRequest = self.myPendingRequestsObj?.pendingData![indexPath.row]
        //
        //            if aRequest?.status == "P"{
        //
        //                let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Accept or Reject", preferredStyle: UIAlertControllerStyle.alert)
        //
        //                consentAlert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action: UIAlertAction!) in
        //
        //                    self.requestMoneyAcceptReject(requestID: (aRequest?.requesterMoneyId)!, status: "A")
        //                    self.dismiss(animated: true, completion:nil)
        //                }))
        //
        //                consentAlert.addAction(UIAlertAction(title: "Reject", style: .cancel, handler: { (action: UIAlertAction!) in
        //
        //                    self.requestMoneyAcceptReject(requestID: (aRequest?.requesterMoneyId)!, status: "R")
        //                    self.dismiss(animated: true, completion:nil)
        //                }))
        //
        //                present(consentAlert, animated: true, completion: nil)
        //
        //            }
    }
    
    
    // MARK: - API call
    
    func requestMoneyDetails() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getMyRequestMoneyDetail"
        
        let params = ["":""] as [String : Any]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<PendingRequestsModel>) in
            
            self.hideActivityIndicator()
            
            self.myPendingRequestsObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.myPendingRequestsObj?.responsecode == 2 || self.myPendingRequestsObj?.responsecode == 1 {
                    
                    for aRequest in (self.myPendingRequestsObj!.pendingData)!{
                        
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
                    self.myRequestTableView.reloadData()
                }
                else {
                    self.showAlert(title: "", message: (self.myPendingRequestsObj?.messages)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
}
