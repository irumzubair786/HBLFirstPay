//
//  LimitManagementMainVc.swift
//  First Pay
//
//  Created by Arsalan Amjad on 23/12/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
var limitflag = ""
class LimitManagementMainVc: BaseClassVC {
    var ATMID : String?
    var MBID : String?
    
    
    struct ATMData {
        static var newsalaryUserStruct: ATMData = ATMData()

        var limitId : String = ""
        var limitAmount : String = ""
        var channelCode : String = ""
        var channelName : String = ""
        var transactionName : String = ""
        var frequency : String = ""
        var key : String = ""
        var identifier : String = ""
        
    }
    
    struct MobilebankingData {
        static var newsalaryUserStruct: MobilebankingData = MobilebankingData()

        var limitId : String = ""
        var limitAmount : String = ""
        var channelCode : String = ""
        var channelName : String = ""
        var transactionName : String = ""
        var frequency : String = ""
        var key : String = ""
        var identifier : String = ""
       
    }

    
    var descrptionlist = [String]()
    var GetChangeLimitObj : getChangeLimitModel?
   
    var arrMBItems = [MB]()
    var arrATMItems = [ATM]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview1.reloadData()
        self.tableview2.reloadData()
        print("array is ", arrMBItems.count)
        print("ATM data is", arrATMItems.count)
        getChannelLimits()
        tableview1.rowHeight = 100
        tableview2.rowHeight = 100
        lblMain.text = "LimitManagement".addLocalizableString(languageCode: languageCode)
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        getChannelLimits()
//        super.viewDidAppear(animated)
//        self.tableview1.reloadData()
//        self.tableview2.reloadData()
//    }
//
    override func viewWillAppear(_ animated: Bool) {
        getChannelLimits()
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
                        self.tableview1.reloadData()
                    }
      
        self.tableview2.reloadData()

    }
    @IBOutlet weak var tableview1: UITableView!
    @IBOutlet weak var lblATM: UILabel!
    @IBOutlet weak var lblMobilebanking: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var tableview2: UITableView!
    @IBAction func backpressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    
    
    @IBAction func changelimiit2(_ sender: UIButton) {
        limitflag = "false"
        let tag = sender.tag
        let cell = tableview2.cellForRow(at: IndexPath(row: tag, section: 0))
         as! ATMCellvC
        ATMID = GetChangeLimitObj?.limitmangemnetdata?.aTM?[tag].limitId
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectLimitMangamnetLovVC") as!
        SelectLimitMangamnetLovVC
        DataManager.instance.transactionNameATm = GetChangeLimitObj?.limitmangemnetdata?.aTM?[tag].transactionName! ?? ""
        vc.ATMIdget = self.ATMID ?? ""
//        vc.MBidget = self.MBID ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    @IBAction func changeLimit(_ sender: UIButton) {
        limitflag = "true"
        let tag = sender.tag
        let cell = tableview1.cellForRow(at: IndexPath(row: tag, section: 0))
         as! MobileBankingCell
        MBID = GetChangeLimitObj?.limitmangemnetdata?.mB?[tag].limitId
        let vc = storyboard?.instantiateViewController(withIdentifier: "SelectLimitMangamnetLovVC") as!
        SelectLimitMangamnetLovVC
        DataManager.instance.transactionNameMB = GetChangeLimitObj?.limitmangemnetdata?.mB?[tag].transactionName! ?? ""
//        vc.ATMIdget = self.ATMID ?? ""
        vc.MBidget = self.MBID ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    private func getChannelLimits() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        showActivityIndicator()

        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }


        let compelteUrl = GlobalConstants.BASE_URL + "getChannelLimits"

        let parameters = ["cnic": userCnic!,"imei": DataManager.instance.imei!,"channelId": DataManager.instance.channelID]

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
       
        
      
        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<getChangeLimitModel>) in
//            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<getChangeLimitModel>) in

            self.hideActivityIndicator()

            self.GetChangeLimitObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.GetChangeLimitObj?.responsecode == 2 || self.GetChangeLimitObj?.responsecode == 1 {
                    if self.GetChangeLimitObj?.limitmangemnetdata?.aTM != nil{
                        self.lblATM.text = "ATM".addLocalizableString(languageCode: languageCode)
                    }
                    if  self.GetChangeLimitObj?.limitmangemnetdata?.mB != nil
                    {
                        self.lblMobilebanking.text = "Mobile Banking".addLocalizableString(languageCode: languageCode)
                    }
                   
                    
                    
                    print("Atm  array is", self.GetChangeLimitObj?.limitmangemnetdata?.aTM)
                    print("MB  array is", self.GetChangeLimitObj?.limitmangemnetdata?.mB)
                    self.tableview1.delegate = self
                    self.tableview1.dataSource = self
                    self.tableview2.delegate = self
                    self.tableview2.dataSource = self
                    DispatchQueue.main.async {
                        self.tableview1.reloadData()
                        self.tableview2.reloadData()
                                }
                    self.tableview1.reloadData()
                    self.tableview2.reloadData()
                }
                else {
                    if let message = self.GetChangeLimitObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
                if let message = self.GetChangeLimitObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
 func imagetap(recognizer: UIGestureRecognizer)
    {
        
    }
}
extension LimitManagementMainVc: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableview1{
            if self.arrMBItems != nil {
                return self.GetChangeLimitObj?.limitmangemnetdata?.mB?.count ?? -1
            }
        }
        if tableView == self.tableview2{
            if self.arrATMItems != nil
            {
                return self.GetChangeLimitObj?.limitmangemnetdata?.aTM?.count ?? -1
            }
            
        }
        return 0
//
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        if tableView == tableview1
        {
        let Cell1 = tableView.dequeueReusableCell(withIdentifier: "MobileBankingCell") as! MobileBankingCell
       Cell1.selectionStyle = .none
          
            Cell1.btnchangelimit.tag = indexPath.row
//            let aValue = arrMBItems[indexPath.row]
            
         print("seleted MBId is",MBID)
            Cell1.backview.dropShadow1()
            Cell1.lblamount.text = GetChangeLimitObj?.limitmangemnetdata?.mB?[indexPath.row].limitAmount!
            Cell1.lblTransactionname.text = "\(GetChangeLimitObj?.limitmangemnetdata?.mB?[indexPath.row].transactionName! ?? "")"
            DataManager.instance.frequencyMB = GetChangeLimitObj?.limitmangemnetdata?.mB?[indexPath.row].frequency! ?? ""
           
            DataManager.instance.keyMB = GetChangeLimitObj?.limitmangemnetdata?.mB?[indexPath.row].key! ?? ""

            DataManager.instance.identifierMB = GetChangeLimitObj?.limitmangemnetdata?.mB?[indexPath.row].identifier! ?? ""
            return Cell1
    }

       else
        {
           
            let Cell2 = tableView.dequeueReusableCell(withIdentifier: "ATMCellvC") as! ATMCellvC
           
            print("seleted ATmId is",ATMID as Any)
            Cell2.btnlimitchange.tag = indexPath.row
           
            Cell2.lblAmount.text = GetChangeLimitObj?.limitmangemnetdata?.aTM?[indexPath.row].limitAmount! ?? ""
            Cell2.lblTransactionname.text = "\(GetChangeLimitObj?.limitmangemnetdata?.aTM?[indexPath.row].transactionName! ?? "")"
         
            DataManager.instance.frequencyATM = GetChangeLimitObj?.limitmangemnetdata?.aTM?[indexPath.row].frequency! ?? ""
            DataManager.instance.keyATm = GetChangeLimitObj?.limitmangemnetdata?.aTM?[indexPath.row].key! ?? ""
            DataManager.instance.identifierATm = GetChangeLimitObj?.limitmangemnetdata?.aTM?[indexPath.row].identifier! ?? ""
           Cell2.selectionStyle = .none

            return Cell2
        }

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

//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == tableview1
//        {
//            MBID = GetChangeLimitObj?.limitmangemnetdata?.mB?[indexPath.row].limitId
//            print("seleted Id is",MBID ?? "")
//        }
//        else
//         {
//             ATMID = GetChangeLimitObj?.limitmangemnetdata?.aTM?[indexPath.row].limitId
//             print("seleted Id is",ATMID as Any)
//         }


    }
}
