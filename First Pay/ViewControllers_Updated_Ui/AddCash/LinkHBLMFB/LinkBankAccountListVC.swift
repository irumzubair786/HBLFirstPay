//
//  LinkBankAccountListVC.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class LinkBankAccountListVC: BaseClassVC {
//    var  accountTitle :String?
//    var  accountNumber :String?
//    var  bankName :String?
   
    var cbsAccountsObj : GetCBSAccounts?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getLinkAccounts()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        buttonback.setTitle("", for: .normal)
        self.tableView.rowHeight = 120
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBOutlet weak var buttonback: UIButton!
    @IBAction func buttonback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true
        )
    }
    private func getLinkAccounts() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getCbsAccounts"
        
        
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!]
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<GetCBSAccounts>) in
            
            
            self.hideActivityIndicator()
            
            self.cbsAccountsObj = response.result.value
            if response.response?.statusCode == 200 {
            
                if self.cbsAccountsObj?.responsecode == 2 || self.cbsAccountsObj?.responsecode == 1 {
                    if self.cbsAccountsObj?.accdata?.count ?? 0 > 0{
//                        "cnic" : "3740526510394",
//                             "imei" : "17C53E82959F494EAA8400280F8616D2",
//                              "mobileNo" : "03406401050",
//                              "accountNo" : "0021122403871012",
//                              "otpRequired" : "Y",
//                              "otp" : "9718",
//                              "accountType" : "20",
//                              "accountTitle" : "IRUM  ZUBAIR",
//                              "branchCode" : "0002",
//                              "branchName" : "MURREE ROAD RWP BRANCH",
//                             "channelId" : "3"
                        
                        GlobalData.branchName = cbsAccountsObj?.accdata?[0].accountBranch
                        GlobalData.branchCode = cbsAccountsObj?.accdata?[0].accountBranchCode
                        
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                        self.tableView.rowHeight = 120

                    }
                   
                }
                else {
                    self.showAlert(title: "", message: (self.cbsAccountsObj?.messages)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    @objc func buttontaped(_sender:UIButton)
    {
        let tag = _sender.tag
//
      let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! cellLinkedAccount
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LinkBankAccountDetailVc") as! LinkBankAccountDetailVc
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension LinkBankAccountListVC :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.cbsAccountsObj?.accdata?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellLinkedAccount") as! cellLinkedAccount
        
        let aRequest =  self.cbsAccountsObj?.accdata?[indexPath.row]
        aCell.LabelName.text = aRequest?.accountTitle
        aCell.labelAccNo.text = aRequest?.accountNumber
        aCell.buttonChecked.isHidden = true
//        aCell.backView.borderColor = .gray
        aCell.labelBankName.text = aRequest?.accountBranch
        aCell.buttonChecked.tag = indexPath.row
        aCell.buttonChecked.setTitle("", for: .normal)
        aCell.buttonChecked.addTarget(self, action: #selector(buttontaped), for: .touchUpInside)

        return aCell
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.3, animations: {
                cell.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
                },completion: { finished in
                    UIView.animate(withDuration: 0.1, animations: {
                        cell.layer.transform = CATransform3DMakeScale(1,1,1)
                    })
            })
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
    
        let tag =  indexPath.row
      let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! cellLinkedAccount
//        cell.buttonChecked.isHidden = false
//        cell.backView.borderColor = .green
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LinkBankAccountDetailVc") as! LinkBankAccountDetailVc
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.reloadData()
    }
}
