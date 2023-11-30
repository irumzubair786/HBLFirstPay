//
//  PurposeSelectionVC.swift
//  First Pay
//
//  Created by Irum Zubair on 29/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class PurposeSelectionVC: BaseClassVC {
    var arrReasonsList : [String]?
    var reasonsObj : GetReasonsModel?
    var reasonID: Int?
    var resonCode : String?
    var reasonsList : [String]?
    var getrznid = [myPurpose]()
    var Seclected_Rzn :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        FBEvents.logEvent(title: .Request_Money_Selection)
        FaceBookEvents.logEvent(title: .Request_Money_Selection)
        tableView.delegate = self
        tableView.dataSource = self
//        getReasonsForTrans()
        tableView.rowHeight = 80
        getReasonsForTrans()
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    private func getReasonsForTrans() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        let compelteUrl = GlobalConstants.BASE_URL + "\(transactionV1or2)/getFtTransPurpose"
         let header: HTTPHeaders = ["Accept":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).response {
//            (response: DataResponse<GetReasonsModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                //            self.reasonsObj = Mapper<GetReasonsModel>().map(JSONObject: json)
                
                if response.response?.statusCode == 200 {
                    //                self.reasonsObj = response.result.value
                    self.reasonsObj = Mapper<GetReasonsModel>().map(JSONObject: json)
                    if self.reasonsObj?.responsecode == 2 || self.reasonsObj?.responsecode == 1 {
                        var aReq =  self.reasonsObj?.reasonsData!
                        for i in self.reasonsObj?.reasonsData! ?? []
                        {
                            var temp = myPurpose()
                            temp.code = (i.code!)
                            temp.name = (i.descr ?? "")
                            temp.id = (i.transactionPurposeId!)
                            self.getrznid.append(temp)
                        }
                        self.reasonsList = self.reasonsObj!.stringReasons
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                        
                        
                    }
                    
                }
                else {
                    
                    print(response.value)
                    print(response.response?.statusCode)
                }
            }
        }
    }
    
}
extension PurposeSelectionVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasonsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellMoneyTransfer_ReasonVC") as! cellMoneyTransfer_ReasonVC
//        let aRequest = reasonsList?[indexPath.row]

        aCell.lblname.text = reasonsList?[indexPath.row]
//m        aCell.lblcityname.text =
        return aCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        Seclected_Rzn = reasonsList?[indexPath.row]
        for i in getrznid
        {
            if i.name == Seclected_Rzn
            {
                reasonID = i.id
                resonCode = i.code

            }

        }
        
        
//        City_View.isHidden = false
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellMoneyTransfer_ReasonVC") as! cellMoneyTransfer_ReasonVC
        aCell.lblname.textColor = .green
        aCell.accessoryType = UITableViewCell.AccessoryType.checkmark
        aCell.tintColor = UIColor.gray
        
         GlobalData.money_Reason = Seclected_Rzn!
//        GlobalData.money_Reason = (reasonsList?[0])!
        GlobalData.moneyReasonid = reasonID!
        GlobalData.moneyTransferReasocCode = resonCode!
        print("city id get",  GlobalData.money_Reason)
        isFromReason = true
        self.dismiss(animated: false)
//        self.navigationController?.popViewController(animated: false)
    
    }
    
    
    
    
    
}

class myPurpose
{
    var name = ""
    var code = ""
    var id  = 0
}
