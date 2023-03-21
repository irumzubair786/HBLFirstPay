//
//  MyBillsVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 11/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SwiftKeychainWrapper
import AlamofireObjectMapper

class MyBillsVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
   
    var mybillsObj:MiniStatementModel?
    @IBOutlet var myBillsTableView: UITableView!
    
    @IBOutlet weak var lblMainTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMainTitle.text = "My Bills".addLocalizableString(languageCode: languageCode)
        self.getMyBills()
        
        
        // Do any additional setup after loading the view.
    }
    
  
    // MARK: - Table View Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if let count = self.mybillsObj?.ministatement?.count{
            return count
        }
        return 0
        
        //return (self.notificationsObj?.notifications?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "MiniStatementTableViewCell") as! MiniStatementTableViewCell
        aCell.selectionStyle = .none
        
        //            let aStatement = miniStatementObj?.ministatement[indexpath]
        //            if let lastTrans = aStatement.lcy_amount{ 
        //            }
        
        let aStatement = self.mybillsObj?.ministatement![indexPath.row]
 
        
        aCell.lblTitle.text = aStatement?.transDocsDescr
        aCell.lblDate.text = aStatement?.transDate
        aCell.lblFromAccountNo.text = "FEE:\(aStatement?.feeAmt ?? 0).00|FED:\(aStatement?.fedAmt ?? 0).00"
        
        if aStatement?.amountType == "C"{
            aCell.lblType.text = "Credit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            aCell.imgCreditDebit.image = #imageLiteral(resourceName: "arrow_credit")
            if let fromAccountTitle = aStatement?.fromAccountTitle{
                aCell.lblFromAccountTitle.text = "Consumer No : \(fromAccountTitle.trimmingCharacters(in: .whitespacesAndNewlines))"
            }
        }
        else if aStatement?.amountType == "D" {
            aCell.lblType.text = "Debit"
            aCell.lblAmount.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            aCell.imgCreditDebit.image = #imageLiteral(resourceName: "arrow_debits")
            if let toAccountTitle = aStatement?.toAccountTitle{
                aCell.lblFromAccountTitle.text = "Consumer No : \(toAccountTitle.trimmingCharacters(in: .whitespacesAndNewlines))"
            }
        }
        
        if let amount = aStatement?.txnAmt{
            aCell.lblAmount.text = "PKR \(amount)"
        }
        
        return aCell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let aValue:SingleMiniStatement = (self.mybillsObj?.ministatement![indexPath.row])!

        let utilityInfoVC = self.storyboard!.instantiateViewController(withIdentifier: "UbilityBillPaymentListVC") as! UbilityBillPaymentListVC
        
        utilityInfoVC.companyID = aValue.transDocsCode
        utilityInfoVC.mainTitle = aValue.transDocsDescr
        utilityInfoVC.consumerNumber = aValue.toAccountTitle
        utilityInfoVC.companyCode = aValue.ubpCompanyId
        utilityInfoVC.isFromQuickPay = true
        self.navigationController!.pushViewController(utilityInfoVC, animated: true)

        NSLog ("You selected row: %@ \(indexPath)")
        print("Trans Code : \( aValue.transDocsCode))")
        print("Account Title : \(aValue.transDocsDescr))")
        print("To Account No : \(aValue.toAccountTitle))")
        print("Trans Code : \(aValue.ubpCompanyId))")
        
//
        
//        let aStatement = self.mybillsObj?.ministatement![indexPath.row]
//
//
//        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "MiniStatementDetailsVC") as! MiniStatementDetailsVC
//        detailsVC.strAmount = "PKR. \(aStatement?.txnAmt ?? 0)"
//
//        if aStatement?.amountType == "C"{
//            detailsVC.strCreditDebit = "CREDIT"
//        }
//        else if aStatement?.amountType == "D" {
//            detailsVC.strCreditDebit = "DEBIT"
//        }
//
//        detailsVC.strReceiverWallet = ("\(aStatement?.toAccountNo ?? "") \n\(aStatement?.toAccountTitle ?? "")")
//        detailsVC.strSourceWallet = ("\(aStatement?.fromAccountNo ?? "") \n\(aStatement?.fromAccountTitle ?? "")")
//        detailsVC.strDateTime = aStatement?.transDate
//        detailsVC.strTransactionType = aStatement?.transDocsDescr
//        detailsVC.strPurpose = aStatement?.transRefnum
//
//        detailsVC.modalPresentationStyle = .overCurrentContext;
//        self.rootVC?.present(detailsVC, animated: true, completion: nil)
    }
    
    // MARK: - API Call
    
    public func getMyBills(){
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        var userCnic : String?
        var pessi : String?
//        let compelteUrl = GlobalConstants.BASE_URL + "myBills"
        
        let compelteUrl = GlobalConstants.BASE_URL + "v2/myBills"
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
      
        
        
//
//        let parameters = ["channelId":"\(DataManager.instance.channelID)","accountType": DataManager.instance.accountType!,"cnic":DataManager.instance.userCnic!,"imeiNo": DataManager.instance.imei!]
//      orginal
        let parameters = ["channelId":"\(DataManager.instance.channelID)","acountId":"\(DataManager.instance.accountId!)", "accountType": DataManager.instance.accountType!,"cnic": userCnic!,"imeiNo": DataManager.instance.imei!]
//        end
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<MiniStatementModel>) in
            
            self.hideActivityIndicator()
            
            self.mybillsObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.mybillsObj?.responsecode == 2 || self.mybillsObj?.responsecode == 1 {
                    self.myBillsTableView.reloadData()
                }
                else {
                    if let message = self.mybillsObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.mybillsObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }

    
}
