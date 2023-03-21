//
//  KFSnanoloanVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 11/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import SwiftKeychainWrapper

class KFSnanoloanVC: BaseClassVC {
    var kfsobj : KFSModel?
    var nl_disbursement_id : Int?
    var LoanAmount : Int?
    var Markuprate : Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMain.text = "Key Fact Statement Nano Loan".addLocalizableString(languageCode: languageCode)
        btnOK.setTitle("OK".addLocalizableString(languageCode: languageCode), for: .normal)
        tableview.delegate = self
        tableview.dataSource = self
        getKFS()
        print(nl_disbursement_id)
    }
  
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lblMain: UILabel!
    var fetchdatafromapi = [String]()
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func ok(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

 
    private func getKFS() {

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
//        let compelteUrl = "http://bbuat.fmfb.pk/nanoloan/applyLoan"
        let compelteUrl = GlobalConstants.BASE_URL + "getKFS"

        let parameters = ["imei":DataManager.instance.imei!,"cnic":userCnic!,"nlDisbursementId" : nl_disbursement_id,"channelId": DataManager.instance.channelID] as [String : Any]


//        print(parameters)

        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))

        print(result.apiAttribute1)
        print(result.apiAttribute2)

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]


        print(params)
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<KFSModel>) in
            self.hideActivityIndicator()

            self.kfsobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.kfsobj?.responsecode == 2 || self.kfsobj?.responsecode == 1 {
                    print("api run successfully")
                   
                    tableview.reloadData()

                    }


                else {
                    if let message = self.kfsobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }

            else {
                if let message = self.kfsobj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
            }

            }
        }
    
}
extension KFSnanoloanVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let count = self.kfsobj?.KFSdata?.count
//        {
//            return count
//        }
//        return kfsobj.KFSdata?.accountTitle
        return 1
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "KFScell") as! KFScell
       
        aCell.lbname.text = kfsobj?.kfsdata?.accountTitle
        aCell.lblcnic.text = kfsobj?.kfsdata?.cnic
        aCell.lblloanno.text = kfsobj?.kfsdata?.loanNo
//        changes
////
        let a = (kfsobj?.kfsdata?.productDescr! ?? "")
        if a != ""
        {
            let b = String(a.suffix(6))
            //        return 96 %\r\n
//            let APR = b.substring(to: 4)
            
            aCell.lblinstallmentamount.text = "   \(b)"
            
        }
        
        aCell.lblnameofproduct.text = (kfsobj?.kfsdata?.productDescr! ?? "")
        aCell.lblloanamount.text = "\(kfsobj?.kfsdata?.loanAmount! ?? 0)"
        aCell.lblnoofins.text = "\(kfsobj?.kfsdata?.totalInstallments! ?? 0)"
        aCell.lblrepayment.text = kfsobj?.kfsdata?.repaymentFrequency
        aCell.lbltotalpayableamount.text = "\(kfsobj?.kfsdata?.totalPayableAmount! ?? 0)"
       
        let  monthlyvalue = (Float(kfsobj?.kfsdata?.markupRate! ?? 0)/12)
//
        aCell.lblmarkup.text = "Monthly \(monthlyvalue) % "
        aCell.lblprocessingfee.text = "\(kfsobj?.kfsdata?.processingFee! ?? 0)"
       
        aCell.lbltotalpayableamount.text = "\((kfsobj?.kfsdata?.totalPayableAmount!) ?? 0)"
        let earlyvalue = (kfsobj?.kfsdata?.epChargesAmount! ?? 0)
        aCell.lblq2.text = "PKR \(earlyvalue) Early settlement charge"
        let latevalue = (kfsobj?.kfsdata?.lpChargesAmount! ?? 0)
        aCell.lblq4.text = "PKR \(latevalue) Late Payment Charges"
        aCell.lblfed.text = "\(kfsobj?.kfsdata?.fedAmount  ?? 0)"
        aCell.lbltenure.text = "\(kfsobj?.kfsdata?.noOfDaysTenure  ?? 0)"
        aCell.lblmarkupAmount.text = String(LoanAmount! * Markuprate! ?? 0)
        
       
        return aCell
    }
    
    
}
