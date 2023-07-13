//
//  OpreatorSelectionVc.swift
//  First Pay
//
//  Created by Irum Butt on 04/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import SDWebImage
class OpreatorSelectionVc: BaseClassVC, UITextFieldDelegate {
    var parentCompanyID : Int?
    var billCompanyListObj : UtilityBillCompaniesModel?
    var comapniesList = [SingleCompanyList]()
    var seclectedOperator = ""
    var getOperator = [myOperator]()
    var operatorid : Int?
    var operatorcode : String?
    var logo : String?
    var dummyarr : [String]?
    
    var returnData: (() -> ())!
    override func viewDidLoad() {
        super.viewDidLoad()
        FBEvents.logEvent(title: .Easyload_category_selection)
        FaceBookEvents.logEvent(title: .Easyload_category_selection)
        
        print("get parentCompanyID", parentCompanyID!)
      
        tableView.rowHeight = 90
        getCompanies()
//       if  GlobalData.topup == "Prepaid"
//        {
//           getCompanies()
//       }
//        else
//        {
//            getCompaniesPostPaid(id: parentCompanyID)
//        }
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoStatement(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizerr)
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var blurView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func Action_hideoperatorView(_ sender: UIButton) {
       
    }
    @objc func MovetoStatement(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated: false)
        
    }
    
   
    
    private func getCompanies() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
       
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v2/getCompaniesById/\(self.parentCompanyID ?? 0)"
       
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).response {
//            (response: DataResponse<UtilityBillCompaniesModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.billCompanyListObj = Mapper<UtilityBillCompaniesModel>().map(JSONObject: json)
            
//            self.billCompanyListObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.billCompanyListObj?.responsecode == 2 || self.billCompanyListObj?.responsecode == 1 {
                    if let companies = self.billCompanyListObj?.companies {
                        self.comapniesList = companies
                        self.dummyarr = self.billCompanyListObj?.stringCompaniesList
                    }
                    
                    for i in self.billCompanyListObj?.companies! ?? []
                    {
                        let temp = myOperator()
                        temp.code = i.code!
                        temp.id = i.ubpCompaniesId!
                        temp.name = i.name!
                        temp.path = i.path ?? ""
                        self.getOperator.append(temp)
                    }
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
                else {
                    if let message = self.billCompanyListObj?.messages{
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    private func getCompaniesPostPaid(id: Int?) {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
       
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v2/getCompaniesById/\(self.parentCompanyID ?? 0)"
       
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).response {
//            (response: DataResponse<UtilityBillCompaniesModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.billCompanyListObj = Mapper<UtilityBillCompaniesModel>().map(JSONObject: json)
            
//            self.billCompanyListObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.billCompanyListObj?.responsecode == 2 || self.billCompanyListObj?.responsecode == 1 {
                    if let companies = self.billCompanyListObj?.companies {
                        self.comapniesList = companies
                        self.dummyarr = self.billCompanyListObj?.stringCompaniesList
                    }
                    
                    for i in self.billCompanyListObj?.companies! ?? []
                    {
                        let temp = myOperator()
                        temp.code = i.code!
                        temp.id = i.ubpCompaniesId!
                        temp.name = i.name!
                        temp.path = i.path ?? ""
                        self.getOperator.append(temp)
                    }
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.tableView.reloadData()
                }
                else {
                    if let message = self.billCompanyListObj?.messages{
                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    
//    func img(tag : Int) -> UIImage{
//        guard let img = UIImage(named: dummyarr![tag])else {
//            return UIImage(named: "11")!
//
//        }
//        return img
//
//    }



}
extension OpreatorSelectionVc: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  getOperator.count ?? 0
   
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellOperator") as! cellOperator
       
        let aRequest = getOperator[indexPath.row]
//        aCell.backview.dropShadow1()
        aCell.lblOperator.text  = aRequest.name
        let url = URL(string:"\(GlobalConstants.BASE_URL)\(getOperator[indexPath.row].path)")
    print("url",url!)
        aCell.imgoperatoe.sd_setImage(with: url!)
    
//m        aCell.lblcityname.text =
        return aCell

    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
        seclectedOperator = (getOperator[indexPath.row].name)
        for i in getOperator
        {
            if i.name == seclectedOperator
            {
                operatorid = i.id
                operatorcode = i.code
                logo = i.path
            }

        }
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellOperator") as! cellOperator
//        aCell.lblcityname.textColor = UIColor(hexValue: 0x00CC96)
        aCell.accessoryType = UITableViewCell.AccessoryType.checkmark
        aCell.tintColor = UIColor.gray
        GlobalData.Selected_operator = seclectedOperator
        GlobalData.Select_operator_id = operatorid
        GlobalData.Select_operator_code = operatorcode!
        GlobalData.selected_operator_logo = getOperator[indexPath.row].path
//        GlobalData.selected_operator_logo = img(tag: indexPath.row)
        //returnData!()
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: false)
//            self.dismiss(animated: false)
            DispatchQueue.main.async {
                if  GlobalData.topup == "P R E P A I D" {
                    NotificationCenter.default.post(name: Notification.Name("showSelectedDataPrePaid"), object: nil)
                }
                else {
                    NotificationCenter.default.post(name: Notification.Name("showSelectedDataPostpaid"), object: nil)
                }
            }
        }
        
        
    }
}
class myOperator
{
    var code = ""
    var id = 0
    var name = ""
    var path = ""
}
