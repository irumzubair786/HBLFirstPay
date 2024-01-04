//
//  FromLinkAccountListVc.swift
//  First Pay
//
//  Created by Irum Butt on 22/03/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import FittedSheets
class FromLinkAccountListVc: BaseClassVC , DrawerGesture{
    static var name: String { "CategoryPicker" }
    var LinkedAccountsObj : getLinkedAccountModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        getLinkAccounts()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        buttonback.setTitle("", for: .normal)
        self.tableView.rowHeight = 120
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonback: UIButton!
    
    @IBAction func buttonback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true
        )
    }
    @IBOutlet weak var tableView: UITableView!
    func openPicker(from parent: UIViewController, id: String, in view: UIView?) {
        
        let useInlineMode = view != nil
        let controller = (UIStoryboard.init(name: "AddCash", bundle: Bundle.main).instantiateViewController(withIdentifier: "UnlinkAccountVC") as? UnlinkAccountVC)!
//        controller.daily = daily
//        controller.dailyAmount = dailyAmount
//        controller.dailyminValue = dailyminValue
//        controller.dailymaxValue = dailymaxValue
//        controller.tag  = tag
//        controller.delegate = self
//        controller.section = section
//        controller.refreshScreen = {
//            self.apicall()
        
//        controller.LimitType = LimitType
//        controller.AmounttType =  AmounttType
        let sheet = SheetViewController(
            controller: controller,
            sizes: [.percent(0.45), .fullscreen],
            options: SheetOptions(useInlineMode: useInlineMode))
    FromLinkAccountListVc.addSheetEventLogging(to: sheet)
        
        if let view = view {
            sheet.animateIn(to: view, in: parent)
        } else {
            
            parent.present(sheet, animated: true, completion: nil)
        }
    }
    
    private func getLinkAccounts() {
        
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/getLinkAccount"
        
        
        var userCnic : String?
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!, "imei":DataManager.instance.imei!]
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        print(params)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            [self] (response: DataResponse<getLinkedAccountModel>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.LinkedAccountsObj = Mapper<getLinkedAccountModel>().map(JSONObject: json)
                
                //            self.LinkedAccountsObj = response.result.value
                if response.response?.statusCode == 200 {
                    
                    if self.LinkedAccountsObj?.responsecode == 2 || self.LinkedAccountsObj?.responsecode == 1 {
                        
                        if self.LinkedAccountsObj?.data?.count ?? 0 > 0{
                            
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.reloadData()
                            self.tableView.rowHeight = 120
                            
                        }
                    }
                    else {
                        self.showAlert(title: "", message: (self.LinkedAccountsObj?.messages)!, completion: nil)
                    }
                }
                else {
                    
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                    
                }
            }
        }
    }
    
    
    
    @IBAction func buttonDelink(_ sender: UIButton) {
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnlinkAccountVC") as! UnlinkAccountVC
        openPicker(from: self, id:  "changeLimitVC", in: nil)
//      
        
//                        vc.accountTitle = cbsAccountsObj?.accdata[0].cbsAccountTitle
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func buttonpress(_ sender:UIButton)
    {
        let tag = sender.tag
        let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0))
        as! cellFromLinkedAccountListVc
        GlobalData.userAcc = self.LinkedAccountsObj?.data?[tag].cbsAccountNo!
        GlobalData.userAcc =  GlobalData.userAcc?.replacingOccurrences(of: " ", with: "")
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "AddCashVC") as!   AddCashVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension FromLinkAccountListVc :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.LinkedAccountsObj?.data?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "cellFromLinkedAccountListVc") as! cellFromLinkedAccountListVc
        let aRequest =  self.LinkedAccountsObj?.data?[indexPath.row]
        aCell.labelName.text = aRequest?.cbsAccountTitle
        aCell.labelAccountNo.text = aRequest?.cbsAccountNo
        aCell.labelBankName.text = aRequest?.branchName
        aCell.buttonBackView.setTitle("", for: .normal)
        aCell.buttonBackView.tag = indexPath.row
        aCell.buttonBackView.dropShadow1()
        aCell.buttonBackView.addTarget(self, action:  #selector(buttonpress(_:)), for: .touchUpInside)
        
        aCell.buttonDotedIcon.setTitle("", for: .normal)
        return aCell
    }
    

    
//    AddCashVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog ("You selected row: %@ \(indexPath)")
    
      let tag =  indexPath.row
      let cell = tableView.cellForRow(at: IndexPath(row: tag, section: 0)) as! cellFromLinkedAccountListVc
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "AddCashVC") as!   AddCashVC
        self.navigationController?.pushViewController(vc, animated: true)
        

}
}
protocol DrawerGesture {
    static var name: String { get }
    func openPicker(from parent: UIViewController , id : String , in view: UIView?)
    
}

extension DrawerGesture {
    static func addSheetEventLogging(to sheet: SheetViewController) {
        let previousDidDismiss = sheet.didDismiss
        sheet.didDismiss = {
            print("did dismiss")
            previousDidDismiss?($0)
        }
        
        let previousShouldDismiss = sheet.shouldDismiss
        sheet.shouldDismiss = {
            print("should dismiss")
            return previousShouldDismiss?($0) ?? true
        }
        
        let previousSizeChanged = sheet.sizeChanged
        sheet.sizeChanged = { sheet, size, height in
            print("Changed to \(size) with a height of \(height)")
            previousSizeChanged?(sheet, size, height)
        }
    }
}
