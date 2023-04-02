//
//  SelectWalletVC.swift
//  First Pay
//
//  Created by Irum Butt on 13/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import iOSDropDown
import SDWebImage
class SelectWalletVC: BaseClassVC, UITextFieldDelegate, UISearchBarDelegate  {
    var banksObj:GetBankNames?
    var walletList = [WalletList]()
    var sourceBank:String?
    var accountImd : String?
    var varBeneAccountNum:String?
    var Seclected_bank :String?
    var filteredData = [mybank]()
    var getBankid = [mybank]()
    var bankId : Int?
    var bankcode : String?
    var logo: String?
//    var arrBankNameList : [String]?
    
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var MainTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableview.rowHeight = 100
        getBankNames()
        MainTitle.text = ""
        updateUI()
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoStatement(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizerr)
        // Do any additional setup after loading the view.
    }
    
    var bankNames = ["Advans Micro Finance Bank LTD" ,"Al Baraka Islamic Bank Limited","Allied Bank Limited","Apna Microfinance Bank","Askari Commercial Bank Limited","Bank AL Habib Limited","Bank Alfalah Limited","Bank of Punjab","Bank of Khyber","BankIslami Pakistan Limited", "Burj Bank Limited", "Citi Bank","Dubai Islamic Bank Pakistan Limited","FINCA Microfinance Bank", "Faysal Bank Limite","First Women Bank", "Habib Metropolitan Bank Limited", "Habib Bank Limited","ICBC","Tameer Bank / EasyPaisa","JS Bank Limited", "MCB Bank Limited","MCB Islamic Banking","Meezan Bank Limited","NIB Bank Limited","National Bank of Pakistan","NRSP MFBL", "SAMBA","Silk Bank","Sindh Bank","Soneri Bank Limited","Standard Chartered Bank","Summit Bank","U Microfinance Bank","Mobilink Microfinance Bank Ltd/Jazzcash","United Bank Limite","SME Bank Limited","NBP Funds Management","Zarai Taraqiati Bank Limited","HBL Microfinance Bank Ltd","HBL","PayMax (Zong)","MODEL BANK","SadaPay","BYKEA"]
    
    
    
    
//    var bankarr = ["easy paisa Telenor","Allied Bank", "HBL MFB","JazzCash","Habib metro Bank","HBL"]
    var bankarr  : [String]?
    @IBOutlet weak var tableview: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    func  updateUI()
    {
        
        if isfromBanktoBank == true{
            
            MainTitle.text = "Select Wallet"
        }
        else{
            MainTitle.text = "Select Bank"
        }
        
        
    }
    @objc func MovetoStatement(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        self.navigationController?.popViewController(animated: false)
        
    }
    
    func test()
    {
        if isfromBanktoBank == false
        {
            if self.banksObj?.dataobj?.bankList?.count ?? 0  > 0
                               {
                var aReq =  self.banksObj?.dataobj?.bankList
                for item in aReq! ?? []
                {
                    let temp = mybank()
                    temp.id = item.imdListId!
                    temp.code = item.imdNo!
                    temp.name  = item.bankName!
                    temp.path = item.path!
                    self.getBankid.append(temp)
                }
//                if let banks = self.banksObj?.dataobj?.bankList{
//                    self.bankList = banks
//    //                self.arrBankNameList = self.banksObj?.dataobj?.walletList
//                }
                self.filteredData = getBankid
                self.tableview.delegate = self
                self.tableview.dataSource = self
                self.tableview.reloadData()
          }

        }
        else
        {
            if self.banksObj?.dataobj?.walletList?.count ?? 0  > 0
                               {
                var aReq =  self.banksObj?.dataobj?.walletList
                for item in aReq! ?? []
                {
                    let temp = mybank()
                    temp.id = item.imdListId!
                    temp.code = item.imdNo!
                    temp.name  = item.bankName!
                    temp.path = item.path!
                    self.getBankid.append(temp)
                }
//                if let banks = self.banksObj?.dataobj?.walletList{
//                    self.walletList = banks
//    //                self.arrBankNameList = self.banksObj?.dataobj?.walletList
//                }
                self.filteredData = getBankid
                self.tableview.delegate = self
                self.tableview.dataSource = self
                self.tableview.reloadData()
          }

        }
    }
    private func getBankNames() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/getImdList"
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(header)
        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetBankNames>) in
            self.hideActivityIndicator()
            if response.response?.statusCode == 200 {
                self.banksObj = response.result.value
                if self.banksObj?.responsecode == 2 || self.banksObj?.responsecode == 1 {
                    self.test()
                }
                else  {
                    if let message = self.banksObj?.messages{
                        UtilManager.showAlertMessage(message: message, viewController: self)
                    }
                     
                }
            }
            else {
                if let message = self.banksObj?.messages{
                    UtilManager.showAlertMessage(message: message, viewController: self)
                }

                    print(response.result.value)
                    print(response.response?.statusCode)
                
            }
        }
    }
//    func img(tag : Int) -> UIImage{
//        guard let img = UIImage(named: filteredData[tag].path)else {
//            return UIImage(named: "e803d189c1a961c2b404641ea477128c-1")!
//
//        }
//        return img
//
//    }

}
extension SelectWalletVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredData.count ?? 0

        
        
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableview.dequeueReusableCell(withIdentifier: "cellSelectWalletvc") as! cellSelectWalletvc
        let aRequest = filteredData[indexPath.row]
        aCell.lblBankNem.text = aRequest.name
        let url = URL(string:"\(GlobalConstants.BASE_URL)\(filteredData[indexPath.row].path)")
        aCell.img.sd_setImage(with: url)

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
        Seclected_bank = filteredData[indexPath.row].name
        for i in getBankid
        {
            if i.name == Seclected_bank
            {
                bankId = i.id
                bankcode = i.code
                logo = i.path
                
                
            }
            

        }
        
        let aCell = tableview.dequeueReusableCell(withIdentifier: "cellSelectWalletvc") as! cellSelectWalletvc
        GlobalData.Selected_bank = Seclected_bank!
        GlobalData.Selected_bank_id  = bankId!
        GlobalData.Selected_bank_code  = bankcode!
       
        GlobalData.selected_bank_logo = filteredData[indexPath.row].path

        self.navigationController?.popViewController(animated: false)
     
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
            
            
        {
          
          self.filteredData.removeAll()
            print("from searchbar")

            guard let searchText = searchBar.text else { return }
            if searchText == ""{
                print(searchText)
               print("searchlist")
                if(self.filteredData.count == 0){
                   print("searchlist")
                   if(searchBar.text == ""){
                       self.filteredData = self.getBankid
                    print(self.filteredData)
                   }
                }


            }else{
                 print(searchText)

                self.filteredData = (self.getBankid.filter({selectbank -> Bool in
                    return selectbank.name.lowercased().contains(searchText.lowercased())
                }))

                
//                self.filteredData = self.getBankid.filter({ SearchCity  in
//                    return SearchCity.name.contains(searchText.lowercased())
//                }) as! [mybank]
//                print(self.searchdoctor)
                if(filteredData.count == 0){
                    if(searchBar.text == ""){
                        filteredData = getBankid
                    }
                   // self.nosearchlb.isHidden = false
                }else{
                    //self.nosearchlb.isHidden = true
                }

            }

            tableview.reloadData()


        }
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
            
        {
            
            searchBar.text = ""
            filteredData = getBankid
                
            searchBar.endEditing(true)
                
                tableview.reloadData()
                
           
        }
       
    
}

class mybank
{
    var name = ""
    var code = ""
    var id  = 0
    var path = ""
}
