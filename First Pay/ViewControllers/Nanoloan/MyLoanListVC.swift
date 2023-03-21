//
//  MyLoanListVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 09/11/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class MyLoanListVC: BaseClassVC {
    var mylonobj  : getLoanSettledModel?
    
  
    @IBOutlet weak var lblLoanSettlement: UILabel!
    
    var DisbursmentID : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSettledLoans()
        tablev.delegate = self
        tablev.dataSource = self
        tablev.rowHeight = 170
        lblLoanSettlement.text = "Settled Loans".addLocalizableString(languageCode: languageCode)
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
//        btnkeyFactS.setTitle("Key Fact Statment".addLocalizableString(languageCode: languageCode), for: .normal)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblhome: UILabel!
       @IBOutlet weak var lblContactus: UILabel!
       @IBOutlet weak var lblBookme: UILabel!
       @IBOutlet weak var lblInviteFriend: UILabel!


    @IBAction func btnlogout(_ sender: UIButton) {
        self.popUpLogout()
       
    }
    @IBAction func btnback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnkeyfact(_ sender: UIButton) {
       
        
        let tag = sender.tag
        print("tag is", tag)
        let indexPath = IndexPath(row: tag, section: 0)
        let aCell = tablev.cellForRow(at: indexPath) as!
        MyLoanCellVC
        let SelectedDisbursmentId = mylonobj?.MyLoan?[indexPath.row].nl_disbursement_id
        if SelectedDisbursmentId == mylonobj?.MyLoan?[indexPath.row].nl_disbursement_id
        {
            DisbursmentID = mylonobj?.MyLoan?[indexPath.row].nl_disbursement_id
            print("disbursment id", DisbursmentID)
            let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "MyLoanKFSVC") as! MyLoanKFSVC
            bookMeVC.loanAmount = mylonobj?.MyLoan?[indexPath.row].loan_amount
            bookMeVC.nl_disbursement_id = mylonobj?.MyLoan?[indexPath.row].nl_disbursement_id
            bookMeVC.InstallmentAmount = mylonobj?.MyLoan?[indexPath.row].installment_amount
            bookMeVC.TotalInstallment =  mylonobj?.MyLoan?[indexPath.row].total_installments
            bookMeVC.total_markup_amount =  mylonobj?.MyLoan?[indexPath.row].total_markup_amount
            bookMeVC.markupRate = mylonobj?.MyLoan?[indexPath.row].markup_rate
            self.navigationController!.pushViewController(bookMeVC, animated: true)
        }
        
    }
    @IBOutlet weak var tablev: UITableView!
    
    private func getSettledLoans() {

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
     
        let compelteUrl = GlobalConstants.BASE_URL + "getSettledLoans"

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
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<getLoanSettledModel>) in
            self.hideActivityIndicator()

            self.mylonobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.mylonobj?.responsecode == 2 || self.mylonobj?.responsecode == 1 {
        
                    DataManager.instance.MyloanInstallemntAmount = mylonobj?.MyLoan?[0].installment_amount
                    self.tablev.reloadData()
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
extension MyLoanListVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.mylonobj?.MyLoan?.count
        {
            return count
        }
        return 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        let aCell = tablev.dequeueReusableCell(withIdentifier: "MyLoanCellVC") as! MyLoanCellVC
        aCell.backview.dropShadow1()
        aCell.lblProductName.text = mylonobj?.MyLoan?[indexPath.row].nl_product_descr
        aCell.lblname.text =  mylonobj?.MyLoan?[indexPath.row].account_title
//      `     aCell.lblloanpurpose.text =   mylonobj?.MyLoan?[indexPath.row].nl_product_descr
        aCell.lblLoanAmount.text = "\(mylonobj?.MyLoan?[indexPath.row].loan_amount! ?? 0)"
//
        aCell.lblInstallmentAmount.text = "\(mylonobj?.MyLoan?[indexPath.row].installment_amount! ?? 0)"
        aCell.lblTotalAmount.text = "\(mylonobj?.MyLoan?[indexPath.row].total_installments! ?? 0)"
        
        
        return aCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let SelectedDisbursmentId = mylonobj?.MyLoan?[indexPath.row].nl_disbursement_id
        if SelectedDisbursmentId == mylonobj?.MyLoan?[indexPath.row].nl_disbursement_id
        {
            DisbursmentID = mylonobj?.MyLoan?[indexPath.row].nl_disbursement_id
            print("disbursment id", DisbursmentID)
            let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "MyLoanKFSVC") as! MyLoanKFSVC
            
            bookMeVC.loanAmount = mylonobj?.MyLoan?[indexPath.row].loan_amount
            bookMeVC.nl_disbursement_id = mylonobj?.MyLoan?[indexPath.row].nl_disbursement_id
            bookMeVC.InstallmentAmount = mylonobj?.MyLoan?[indexPath.row].installment_amount
            bookMeVC.TotalInstallment =  mylonobj?.MyLoan?[indexPath.row].total_installments
            bookMeVC.total_markup_amount =  mylonobj?.MyLoan?[indexPath.row].total_markup_amount
            
            self.navigationController!.pushViewController(bookMeVC, animated: true)
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
//extension String {
//    func index(from: Int) -> Index {
//        return self.index(startIndex, offsetBy: from)
//    }
//
//    func substring(from: Int) -> String {
//        let fromIndex = index(from: from)
//        return String(self[fromIndex...])
//    }
//
//    func substring(to: Int) -> String {
//        let toIndex = index(from: to)
//        return String(self[..<toIndex])
//    }
//
//    func substring(with r: Range<Int>) -> String {
//        let startIndex = index(from: r.lowerBound)
//        let endIndex = index(from: r.upperBound)
//        return String(self[startIndex..<endIndex])
//    }
//}
