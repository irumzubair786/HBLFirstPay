//
//  ReceivedInstallmentVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 15/06/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class ReceivedInstallmentVC: BaseClassVC,UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.instalDetailsObj?.InsDAta?.count{
            return count
        }
        return 0
    }
    
    @IBOutlet weak var lblmain: UILabel!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let aCell = tableView.dequeueReusableCell(withIdentifier: "ReceivedCEllVC") as! ReceivedCEllVC
        aCell.selectionStyle = .none
    
        aCell.backview.dropShadow1()
        let aCommittee = self.instalDetailsObj?.InsDAta?[indexPath.row]
        aCell.lblPayTo.text = aCommittee?.accountTitle
        aCell.lblAccountNo.text = aCommittee?.accountNo
        aCell.lblDueDate.text = convertDateFormater((aCommittee?.dueDate)!)
        aCell.lblStatus.text = aCommittee?.status
        aCell.lblAmount.text = "Amount:  PKR:\(aCommittee?.installmentAmount ?? 00)"
        aCell.lblFineAmount.text = "Fine Amount : PKR:\(self.fineAmount ?? "")"
        return aCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog ("You selected row: %@ \(indexPath)")
        
        //        let aCommittee = self.instalDetailsObj?.instalmentData![indexPath.row]
        //
        //        let comDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "CommitteeDetailsVC") as! CommitteeDetailsVC
        //        comDetailsVC.commId = "\(aCommittee?.committeeHeadId ?? 00)"
        //
        //        self.navigationController!.pushViewController(comDetailsVC, animated: true)
        
    }
    
    
    func convertDateFormater(_ date: String) -> String
     {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         let date = dateFormatter.date(from: date)
    //     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // MMM d, yyyy
         dateFormatter.dateFormat = "yyyy-MM-dd"
         return  dateFormatter.string(from: date!)
         
     }
    
    var instalDetailsObj : InstalmentDetailsModel?
    var commId : String?
    var fineAmount : String?
    var allCommiteemodelObj : AllCommiteeModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mycommitteeInstallment()
        lblmain.text = "Installment Detail".addLocalizableString(languageCode: languageCode)
       
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBAction func logopressed(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        
            self.navigationController!.popViewController(animated: true)
    }
    
    
    @IBAction func logout(_ sender: UIButton) {
        self.logoutUser()
    }
    private func mycommitteeInstallment() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "myCommitteeInstallments"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId": "\(commId!)"]  as [String : Any]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<InstalmentDetailsModel>) in
            
            
            self.hideActivityIndicator()
            
            self.instalDetailsObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.instalDetailsObj?.responsecode == 2 || self.instalDetailsObj?.responsecode == 1 {
                    self.tableview.delegate = self
                    self.tableview.dataSource = self
                    self.tableview.reloadData()
                }
                else {
                    UtilManager.showAlertMessage(message: "Committee is not Started Yet", viewController: self)
//                    if let message = self.instalDetailsObj?.messages{
//                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            
            else {
                if let message = self.instalDetailsObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
   
}
