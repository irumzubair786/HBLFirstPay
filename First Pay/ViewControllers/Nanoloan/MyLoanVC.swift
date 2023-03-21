//
//  MyLoanVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 09/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class MyLoanVC:  BaseClassVC {
    var mylonobj  : getLoans?
    var getProductName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLoansForManualSettlement()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 170
        lblMain.text = "My Loan".addLocalizableString(languageCode: languageCode)
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
//        btnKeyFact.setTitle("Key Fact Statment".addLocalizableString(languageCode: languageCode), for: .normal)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblhome: UILabel!
      @IBOutlet weak var lblContactus: UILabel!
      @IBOutlet weak var lblBookme: UILabel!
      @IBOutlet weak var lblInviteFriend: UILabel!
   
    @IBOutlet weak var lblMain: UILabel!
    
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
       
    }
    @IBAction func backpressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func keyfactstatment(_ sender: UIButton) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "KFSnanoloanVC") as! KFSnanoloanVC
        bookMeVC.LoanAmount = mylonobj?.dataloan?[0].loan_amount
        bookMeVC.nl_disbursement_id = mylonobj?.dataloan?[0].nl_disbursement_id
        bookMeVC.Markuprate = (mylonobj?.dataloan?[0].markup_rate)!
//            mylonobj?.dataloan?[indexPath.row].nl_disbursement_id
        
        self.navigationController!.pushViewController(bookMeVC, animated: true)
        
    }
    @IBOutlet weak var tableview: UITableView!
    private func getLoansForManualSettlement() {

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
        let userSelfie: String?
        showActivityIndicator()
//        let compelteUrl = "http://bbuat.fmfb.pk/nanoloan/getLoans"
        let compelteUrl = GlobalConstants.BASE_URL + "getLoansForManualSettlement"

        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!, "channelId": DataManager.instance.channelID] as [String : Any]

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

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<getLoans>) in
            self.hideActivityIndicator()

            self.mylonobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.mylonobj?.responsecode == 2 || self.mylonobj?.responsecode == 1 {
                    self.tableview.reloadData()
                    print("api run successfully")
                    
                    }
                    
                else {
                    if let message = self.mylonobj?.messages{
                        self.showAlert(title: "" , message: message, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
//
                    }

                }

        }
            else {
                if let message = self.mylonobj?.messages{
//                     tableview.isHidden = true
                    self.showDefaultAlert(title: "", message: message)
                }

            }
}
    }
}

extension MyLoanVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.mylonobj?.dataloan?.count
        {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let aCell = tableView.dequeueReusableCell(withIdentifier: "KFSStatmentCellVC") as! KFSStatmentCellVC
        aCell.backview.dropShadow1()
        aCell.lblProductname.text = mylonobj?.dataloan?[indexPath.row].nl_product_descr
        aCell.lblname.text = mylonobj?.dataloan?[indexPath.row].account_title
//        aCell.lblloanpurpose.text =   DataManager.instance.NanoLoanProductType
        aCell.lblloanamount.text = " \(mylonobj?.dataloan?[indexPath.row].loan_amount! ?? 0)"
        aCell.lblinstallmentamount.text = " \(mylonobj?.dataloan?[indexPath.row].installment_amount ?? 0)"
        aCell.lbltotalamount.text = "PKR:\(mylonobj?.dataloan?[indexPath.row].total_installments! ?? 0)"
        return aCell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "LoanDetailVc") as! LoanDetailVc
        bookMeVC.nl_disbursement_id = mylonobj?.dataloan?[indexPath.row].nl_disbursement_id
        
        self.navigationController!.pushViewController(bookMeVC, animated: true)
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
    
}
