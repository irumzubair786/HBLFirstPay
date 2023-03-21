//
//  CommitteeInstalDetailsVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 21/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class CommitteeInstalDetailsVC: BaseClassVC, UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet var instalDetailsTableView: UITableView!
    var instalDetailsObj : InstalmentDetailsModel?
    var commId : String?
    var fineAmount : String?
    var comitteeObj : ComiteeInstallmentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblmain.text = "Installment Detail".addLocalizableString(languageCode: languageCode)
        // Do any additional setup after loading the view.
        self.getInstalmentDetailsCall()
    }
    
   
    @IBOutlet weak var lblmain: UILabel!
    // MARK: - Utility Methods
    
    func convertDateFormater(_ date: String) -> String
     {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         let date = dateFormatter.date(from: date)
    //     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // MMM d, yyyy
         dateFormatter.dateFormat = "yyyy-MM-dd"
         return  dateFormatter.string(from: date!)
         
     }
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.comitteeObj?.committeedata?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "InstalmentDetailsTableViewCell") as! InstalmentDetailsTableViewCell
        aCell.selectionStyle = .none
        
        
        let aDetails = self.comitteeObj?.committeedata![indexPath.row]
        
        aCell.lblPayTo.text = aDetails?.accountTitle
        aCell.lblAccountNo.text = aDetails?.accountNo
        aCell.lblDueDate.text = convertDateFormater((aDetails?.dueDate)!)
        aCell.lblStatus.text = aDetails?.status
        aCell.lblAmount.text = "Amount: PKR: \(aDetails?.installmentAmount ?? 00)"
        aCell.lblFineAmount.text = "Fine Amount:  PKR:\(self.fineAmount ?? "")"
        
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
    
    
    // MARK: - API CALL
    
    private func getInstalmentDetailsCall() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "committeeInstallments"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":"\(commId!)" ?? ""] as [String : Any]
        print(compelteUrl)
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<ComiteeInstallmentModel>) in
            
            
            self.hideActivityIndicator()
            
            self.comitteeObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.comitteeObj?.responsecode == 2 || self.comitteeObj?.responsecode == 1 {
                    self.instalDetailsTableView.delegate = self
                    self.instalDetailsTableView.dataSource = self
                    self.instalDetailsTableView.reloadData()
                }
                else {
                    self.showDefaultAlert(title: "", message: "Committee is not Started Yet" )
//                    UtilManager.showAlertMessage(message: "Committee is not Started Yet", viewController: self)
//                    if let message = self.comitteeObj?.messages{
//                        self.showDefaultAlert(title: "", message: message)
//                    }
                }
            }
            else {
                if let message = self.comitteeObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
    
}
