////
////  ManualSattlementVC.swift
////  First Pay
////
////  Created by Arsalan Amjad on 11/09/2021.
////  Copyright © 2021 FMFB Pakistan. All rights reserved.
////

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
var nldsbrsmntid = ""
class ManualSattlementVC: BaseClassVC {
  
    var mylonobj  : getLoans?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.rowHeight = 190
        self.getLoans()
        lblMain.text
        = "Manual Settlement".addLocalizableString(languageCode: languageCode)
//        btnManual.setTitle("Manual  Settlement".addLocalizableString(languageCode: languageCode), for: .normal)
        
        

    }
    
    
    @IBOutlet weak var lblMain: UILabel!
    
   
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    @IBAction func backpressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBOutlet weak var tableview: UITableView!
    private func getLoans() {

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
//       
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
                      nldsbrsmntid = "\(mylonobj?.dataloan?[0].nl_disbursement_id)"
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
//                    tableview.isHidden = true
                    self.showDefaultAlert(title: "", message: message)
                }

            }
}
    }
    
    @IBAction func manualsettlement(_ sender: UIButton) {
        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "MSPopupview") as! MSPopupview
        
        bookMeVC.nlDisbursementId = nldsbrsmntid
        print("dis id", nldsbrsmntid)
        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    

}
extension ManualSattlementVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.mylonobj?.dataloan?.count
        {
            return count
        }
        return 0
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let aCell = tableView.dequeueReusableCell(withIdentifier: "ManualSattementCEll") as! ManualSattementCEll
        aCell.backview.dropShadow1()
    
        aCell.lblname.text = mylonobj?.dataloan?[indexPath.row].account_title
//        changes
//        aCell.lblloanpurpose.text =  DataManager.instance.NanoLoanProductType 
        aCell.lblloanamount.text = " \(mylonobj?.dataloan?[indexPath.row].loan_amount ?? 0)"
        aCell.lblinstallmentamount.text = "\(mylonobj?.dataloan?[indexPath.row].installment_amount ?? 0)"
        aCell.lbltotalamount.text = "PKR:\(mylonobj?.dataloan?[indexPath.row].total_installments! ?? 0)"
        aCell.lblPrpductDetail.text = "\(mylonobj?.dataloan?[indexPath.row].nl_product_descr! ?? "")"
        return aCell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let bookMeVC = self.storyboard!.instantiateViewController(withIdentifier: "MSDetailVC") as! MSDetailVC
//        bookMeVC.nl_disbursement_id = "\(mylonobj?.dataloan?[indexPath.row].nl_disbursement_id! ?? 0)"
////        nldsbrsmntid = "\(mylonobj?.dataloan?[indexPath.row].nl_disbursement_id! ?? 0)"
//        self.navigationController!.pushViewController(bookMeVC, animated: true)
    }
    
}

