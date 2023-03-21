//
//  BranchAtmLocatrMainVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 27/12/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import AlamofireObjectMapper
class BranchAtmLocatrMainVC: BaseClassVC {
    var getAllProvincedataobj : getAllprovince?
    var BranchAtmLocatorobj : BranchAtmLocator?
    var selectedProvince: String?
    var selectedlist : String?
    var ProvinceArray = [String]()
    @IBOutlet weak var lblSelectprovinence: UILabel!
    
    @IBOutlet weak var proviencetextfield: DropDown!
    @IBOutlet weak var lblselecttype: UILabel!
     
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnshow: UIButton!
    @IBOutlet weak var typetextfield: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSelectprovinence.text = "Select Province".addLocalizableString(languageCode: languageCode)
        lblselecttype.text = "Select Type".addLocalizableString(languageCode: languageCode)
        btnshow.setTitle("SHOW".addLocalizableString(languageCode: languageCode), for: .normal)
        tableview.rowHeight = 200
        getAllProvince()
        proviencetextfield.dropShadow1()
        self.proviencetextfield.didSelect{(b , index ,id) in
            self.proviencetextfield.selectedRowColor = UIColor.gray
                    self.selectedProvince = b
//            self.FetchProvinceId()
            
          
            self.proviencetextfield.reloadInputViews()
             self.proviencetextfield.isSelected = true
            self.proviencetextfield.selectedRowColor = UIColor.gray
            self.proviencetextfield.isSearchEnable = true
       
            self.FetchProvinceId()
            self.methodDropDownOptions()

        }
        // Do any additional setup after loading the view.
    }
    private func methodDropDownOptions() {
        
        self.typetextfield.rowHeight = 30.0
        self.typetextfield.selectedRowColor = UIColor.gray
        self.typetextfield.isSearchEnable = true
        self.typetextfield.placeholder = "Select Type".addLocalizableString(languageCode: languageCode)
        self.typetextfield.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        self.typetextfield.optionArray = ["ATM","BRANCH"]
        self.typetextfield.didSelect{(b , index ,id) in
            print("You Just select: \(b) at index: \(index)")
            self.selectedlist = "\(b)"
            if self.selectedlist == "ATM"
            {
                self.selectedlist = "A"
                
            }
            else{
                self.selectedlist = "B"
            }
//            self.selectedlist = b
        }
    }
    
    
    
    @IBAction func btnback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    
    @IBAction func show(_ sender: UIButton) {
        if self.proviencetextfield.text == ""{
            self.showToast(title: "Please Select Provience")
            return
        }
        if self.typetextfield.text == ""{
            self.showToast(title: "Please Select Type")
            return
        }
       
        getBranchAgainstProvinceIdandAtm()
        
        
        
    }
    
    
    var ProvinceId : Int?
    func FetchProvinceId()
    {
        
        
        if let  productlist = self.getAllProvincedataobj?.Allprovince        {
            for data in productlist
            {
                if selectedProvince == data.provinceDescr
                {
                    ProvinceId = data.provinceId
//                    self.getCityAgainstProvinceId()
                    
                }
               
                print("province id is", ProvinceId)
            }
            
            
        }
    }
    
    private func getAllProvince() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

       
        showActivityIndicator()
//
        let compelteUrl = GlobalConstants.BASE_URL + "getAllProvince"
        let params = ["": ""] as [String : Any]
//        ,"Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        let header = ["Content-Type":"application/json"]


        print(params)
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()
        Alamofire.request(compelteUrl).responseObject { (response: DataResponse<getAllprovince>) in
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<getAllprovince>) in
            self.hideActivityIndicator()
            self.getAllProvincedataobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.getAllProvincedataobj?.responsecode == 2 || self.getAllProvincedataobj?.responsecode == 1 {
                    
                    print("api run successfully")
                    if let ProvinceList = self.getAllProvincedataobj?.Allprovince{
                        for data in ProvinceList
                        {
                            
                            self.ProvinceArray.append(data.provinceDescr ?? "")
//
                        }
                        self.proviencetextfield.optionArray = self.ProvinceArray
                      
                      
                    }
                   
                    
                    }

                else {
                    if let message = self.getAllProvincedataobj?.messages{
                        self.showAlert(title: "" , message: message, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
//
                    }

                }

        }
            else {
                if let message = self.getAllProvincedataobj?.messages{
//                     tableview.isHidden = true
                    self.showDefaultAlert(title: "", message: message)
                }

            }
}
    }
    
    
    

    private func getBranchAgainstProvinceIdandAtm() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

       
        showActivityIndicator()
//"\(a), \(b)
        let a  = "\(self.ProvinceId!)"
        let be = "\("/")\(self.selectedlist!)"
        let concatestring = a + be
        print("concatestring is " ,concatestring)
        let compelteUrl = GlobalConstants.BASE_URL + "getBranchAgainstProvinceIdandAtm/" + concatestring
        let params = ["": ""] as [String : Any]
//        ,"Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        let header = ["Content-Type":"application/json"]


        print(params)
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()
        Alamofire.request(compelteUrl).responseObject { (response: DataResponse<BranchAtmLocator>) in
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<getAllprovince>) in
            self.hideActivityIndicator()
            self.BranchAtmLocatorobj = response.result.value
         
            if response.response?.statusCode == 200 {
                if self.BranchAtmLocatorobj?.responsecode == 2 || self.BranchAtmLocatorobj?.responsecode == 1 {
                    self.tableview.delegate = self
                    self.tableview.dataSource = self
                    self.tableview.reloadData()
                    print("api run successfully")
                    print(response.value)
                    }

                else {
                    if let message = self.BranchAtmLocatorobj?.messages{
                        self.showAlert(title: "" , message: message, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
//
                    }

                }

        }
            else {
                if let message = self.BranchAtmLocatorobj?.messages{
//                     tableview.isHidden = true
                    self.showDefaultAlert(title: "", message: message)
                }

            }
}
    }
    
}
extension BranchAtmLocatrMainVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell1 = tableView.dequeueReusableCell(withIdentifier: "BranchLocatorCell") as! BranchLocatorCell
           Cell1.selectionStyle = .none
        let avalue = BranchAtmLocatorobj?.dataBranchAtm?[indexPath.row]
        Cell1.lblcode.text = "Code: \(avalue?.branchCode! ?? "")"
        Cell1.lblName.text =  "Name: \(avalue?.branchDescr! ?? "")"
        Cell1.lblAddress.text = "Address: \(avalue?.address1  ?? "")"
        if avalue?.landline != nil{
            Cell1.lblnumber.text = "Number: \(avalue?.landline ?? "")"
        }
        Cell1.backview.dropShadow1()
    
            return Cell1
    }
    
    
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    
    if let count  = BranchAtmLocatorobj?.dataBranchAtm?.count{
        return count
    }
    return 0

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
