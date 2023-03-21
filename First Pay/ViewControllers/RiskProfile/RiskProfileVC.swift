//
//  RiskProfileVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 30/09/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class RiskProfileVC: BaseClassVC, UITextFieldDelegate
{
    var selectedCity : String?
    var selectedCustomerType: String?
    var selectedAccountPurpose: String?
    var selectedProfession: String?
    var selectedProvince: String?
    var ProfessionArray = [String]()
    var ProvinceArray = [String]()
    var CustomeTypeArray = [String]()
    var AccountPurposeArray = [String]()
    var getCustomerTypeobj : CustomerTypeModel?
    var getAllProvincedataobj : getAllprovince?
    var getAllProfessionModelObj : getAllProfessionModel?
    var getCityAgainstCustomerobj : getCityAgainstCustomer?
    var getcityProvinceIdobj : getcityProvinceIDModel?
    var provinceArrayAgainstID = [String]()
    var getAccountPurposeObj : getAccountPurpose?
    var genResponseObj : GenericResponse?
// outlets
    var otherfieldata : String?
        @IBOutlet weak var btncalculareOutlet: UIButton!
    @IBOutlet weak var amountTextfiled: UITextField!
    @IBOutlet weak var textfieldOther: UITextField!
    @IBOutlet weak var DropdownProvince: DropDown!
    @IBOutlet weak var dropdownprofession: DropDown!
    @IBOutlet weak var dropdownpurpose: DropDown!
    
    @IBOutlet weak var dropdowncustomertype: DropDown!
    @IBOutlet weak var dropdowncity: DropDown!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CityrAgawinstCustomerCnic()
//        self.geCustomerType()
//
        dropdowncity.isHidden = true
        DropdownProvince.isHidden = true
        textfieldOther.isHidden = true
        textfieldOther.delegate = self
        amountTextfiled.delegate = self
        dropdowncustomertype.dropShadow1()
        
        self.dropdowncustomertype.didSelect{(b , index ,id) in
                    self.selectedCustomerType = b
            self.FetchCustomerId()
            self.dropdowncustomertype.rowHeight = 100

            self.dropdowncustomertype.isSelected = true
            self.dropdowncustomertype.selectedRowColor = UIColor.gray
            self.dropdowncustomertype.isSearchEnable = true
            self.getAllProfession()
        }
        
        
        dropdownprofession.dropShadow1()
        self.dropdownprofession.didSelect{(b , index ,id) in
                    self.selectedProfession = b
          self.getAccountPurpose()
            self.dropdownprofession.isSelected = true
            self.dropdownprofession.selectedRowColor = UIColor.gray
            self.dropdownprofession.isSearchEnable = true
            self.FetchProfessionID()
        }
        
//
        dropdownpurpose.dropShadow1()
        self.dropdownpurpose.didSelect{(b , index ,id) in
                    self.selectedCustomerType = b
            if (b == "Others")
            {
                self.textfieldOther.text = ""
                self.textfieldOther.isHidden = false
//                self.textfieldOther.text = ""
//                self.otherfieldata = b
                self.FetchPurposeId()
               self.otherfieldata = self.textfieldOther.text
                
                print("other field data is",   self.otherfieldata)
            }
            else{
                self.textfieldOther.text = b
                self.otherfieldata = b
                print("field data is", b)
                self.textfieldOther.isHidden = true
                self.dropdownpurpose.isSelected = true
                self.dropdownpurpose.selectedRowColor = UIColor.gray
                self.dropdownpurpose.isSearchEnable = true
            }
            self.FetchPurposeId()
//            self.textfieldOther.text  = self.otherfieldata
//
//            print("other field data is", self.textfieldOther.text)
        }
        
        
        DropdownProvince.dropShadow1()
        self.DropdownProvince.didSelect{(b , index ,id) in
                    self.selectedProvince = b
//            self.FetchProvinceId()
            self.dropdowncity.text = ""
            self.dropdowncity.isHidden = false
            self.DropdownProvince.reloadInputViews()
             self.DropdownProvince.isSelected = true
            self.DropdownProvince.selectedRowColor = UIColor.gray
            self.DropdownProvince.isSearchEnable = true
       
            self.FetchProvinceId()

        }

       // dropdowncity.dropShadow1()
        self.dropdowncity.didSelect{(b , index ,id) in
           
                    self.selectedCity = b
            self.FetchCityId()
            self.dropdowncity.isSelected = true
            self.dropdowncity.selectedRowColor = UIColor.gray
            self.dropdowncity.isSearchEnable = true
            
        }

    }
    
//
    func UpDateUi()
    {
      
        self.getAllProfession()
        self.getAccountPurpose()

    
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
    }
    @IBAction func backpressed(_ sender: UIButton) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPinVC") as! LoginPinVC
//        self.navigationController?.pushViewController(vc, animated: true)
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
                    self.geCustomerType()

                    self.DropdownProvince.isHidden = false
                    print("api run successfully")
                    if let ProvinceList = self.getAllProvincedataobj?.Allprovince{
                        for data in ProvinceList
                        {
                            
                            self.ProvinceArray.append(data.provinceDescr ?? "")
//
                        }
                        self.DropdownProvince.optionArray = self.ProvinceArray
                      
                      
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
    
   private func CityrAgawinstCustomerCnic() {

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

       let compelteUrl = GlobalConstants.BASE_URL + "getCityAgainstCustomer/\(userCnic!)"
       showActivityIndicator()
        let params = ["":""] as [String : Any]
//       ,"Authorization":"\(DataManager.instance.accessToken ?? "nil")"
        let header = ["Content-Type":"application/json"]


        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
//       NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<getCityAgainstCustomer>) in
    Alamofire.request(compelteUrl).responseObject { (response: DataResponse<getCityAgainstCustomer>) in
           self.hideActivityIndicator()
            self.getCityAgainstCustomerobj = response.result.value

            if response.response?.statusCode == 200 {
                print("api call")
                self.getCityAgainstCustomerobj = response.result.value
                if (self.getCityAgainstCustomerobj?.responsecode == 2) || ((self.getCityAgainstCustomerobj?.responsecode) == 1)
            {
                    if self.getCityAgainstCustomerobj?.getCityCustomer == "Y"  {
                        DataManager.instance.provnicityid = "hide"
                        self.geCustomerType()

//                        self.UpDateUi()
            
                    }
                    else if self.getCityAgainstCustomerobj?.getCityCustomer == "N" {
                        self.DropdownProvince.isHidden = false
                        self.getAllProvince()
                    }
                   
                }
               
             
                else {
                    if let message = self.getCityAgainstCustomerobj?.messages{
                        self.showAlert(title: "", message: message, completion:nil)
                    }
                }
            }
           
            }
        
}
//    getCityAgainstProvinceId/4
    private func  getCityAgainstProvinceId() {
       
         if !NetworkConnectivity.isConnectedToInternet(){
             self.showToast(title: "No Internet Available")
             return
         }
//
        let compelteUrl = GlobalConstants.BASE_URL + "getCityAgainstProvinceId/\(ProvinceId!)"
      
        showActivityIndicator()
         let params = ["":""] as [String : Any]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

         print(params)
         print(compelteUrl)
         print(header)
         NetworkManager.sharedInstance.enableCertificatePinning()
        Alamofire.request(compelteUrl).responseObject { (response: DataResponse<getcityProvinceIDModel>) in
//             NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<getcityProvinceIDModel>) in
                 self.hideActivityIndicator()
             self.getcityProvinceIdobj = response.result.value

             if response.response?.statusCode == 200 {

                 self.getcityProvinceIdobj = response.result.value
                 if self.getcityProvinceIdobj?.responsecode == 2 || ((self.getcityProvinceIdobj?.responsecode) == 1) {
                     
                     if let ProfessionList = self.getcityProvinceIdobj?.getCityprovinceId{
                         self.provinceArrayAgainstID.removeAll()
                         for data in ProfessionList
                         {
                             self.provinceArrayAgainstID.append(data.cityDescr ?? "")
                            
                         }
                         self.dropdowncity.optionArray = self.provinceArrayAgainstID
                     }
                     
                     print("ProfessionArray", self.ProfessionArray)
                    
                 }
                 else {
                     if let message = self.getcityProvinceIdobj?.messages{
                         self.showAlert(title: "", message: message, completion:nil)
                     }
                 }
             }
             else {
                                 self.showAlert(title: "", message: "Something Went Wrong", completion:nil)
                                 print(response.result.value)
                                 print(response.response?.statusCode)
             }
         }
     }
    
    
//
    private func getAllProfession() {
       
         if !NetworkConnectivity.isConnectedToInternet(){
             self.showToast(title: "No Internet Available")
             return
         }

        let compelteUrl = GlobalConstants.BASE_URL + "getAllProfession"
        showActivityIndicator()
         let params = ["":""] as [String : Any]

//
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]

         print(params)
         print(compelteUrl)
         print(header)
         NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { [self] (response: DataResponse<getAllProfessionModel>) in
//        Alamofire.request(compelteUrl).responseObject { (response: DataResponse<getAllProfessionModel>) in
            
             self.hideActivityIndicator()
             self.getAllProfessionModelObj = response.result.value

             if response.response?.statusCode == 200 {

                 self.getAllProfessionModelObj = response.result.value
                 if self.getAllProfessionModelObj?.responsecode == 2 || ((self.getAllProfessionModelObj?.responsecode) == 1) {
//
                     if let ProfessionList = self.getAllProfessionModelObj?.dataprofession{
                         for data in ProfessionList
                         {
                             self.ProfessionArray.append(data.professionDescr ?? "")
                         }
                         
                         self.dropdownprofession.optionArray = self.ProfessionArray
                     }
//                     self.getAccountPurpose()
                     print("ProfessionArray", self.ProfessionArray)
                    
                 }
                 else {
                     if let message = self.getAllProfessionModelObj?.messages{
                         self.showAlert(title: "", message: message, completion:nil)
                     }
                 }
             }
             else {
                 //                self.showAlert(title: "", message: "Something Went Wrong", completion:nil)
                 //                print(response.result.value)
                 //                print(response.response?.statusCode)
             }
         }
     }
    
    
    
    private func geCustomerType() {
        
         if !NetworkConnectivity.isConnectedToInternet(){
             self.showToast(title: "No Internet Available")
             return
         }

        let compelteUrl = GlobalConstants.BASE_URL + "getCustomerTypes"
        showActivityIndicator()
         let params = ["":""] as [String : Any]

         let header = ["Content-Type":"application/json"]

         print(params)
         print(compelteUrl)
         print(header)
         NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CustomerTypeModel>) in
             self.getCustomerTypeobj = response.result.value
            self.hideActivityIndicator()
             if response.response?.statusCode == 200 {

                 self.getCustomerTypeobj = response.result.value
                 if self.getCustomerTypeobj?.responsecode == 2 || ((self.getCustomerTypeobj?.responsecode) == 1) {
//                     self.getAllProfession()
                     if let CustomerList = self.getCustomerTypeobj?.Customerdata{
                         for data in CustomerList
                         {
                             self.CustomeTypeArray.append(data.customerTypeDescr ?? "")
                         }
                         self.dropdowncustomertype.optionArray = self.CustomeTypeArray
                     }
                 
                     self.dropdowncustomertype.optionArray = self.CustomeTypeArray
                    print("api run successfully")
//                     self.getAllProfession()
                 }
                 else {
                     if let message = self.getCustomerTypeobj?.messages{
                         self.showAlert(title: "", message: message, completion:nil)
                     }
                 }
             }
             else {
        
             }
         }
     }
    private func getAccountPurpose() {

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

     
        let compelteUrl = GlobalConstants.BASE_URL + "getAccountPurpose"

        let header = ["Content-Type":"application/json",  "Authorization":"\(DataManager.instance.accessToken ?? "nil")"]


       
        print(compelteUrl)
        print(header)

        NetworkManager.sharedInstance.enableCertificatePinning()
        Alamofire.request(compelteUrl).responseObject { (response: DataResponse<getAccountPurpose>) in

            self.hideActivityIndicator()
            self.getAccountPurposeObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.getAccountPurposeObj?.responsecode == 2 || self.getAccountPurposeObj?.responsecode == 1 {
                    
                    print("api run successfully")
                    if let AccPurposeList = self.getAccountPurposeObj?.accountpurpose{
                        for data in AccPurposeList
                        {
                            
                            self.AccountPurposeArray.append(data.accountPurposeDescr ?? "")
                            
                        }
                        self.dropdownpurpose.optionArray = self.AccountPurposeArray
//                        drop.optionArray = cityNameArray
//                        self.GetDisountList()
                        
                    }
                    
                    
                    }

                else {
                    if let message = self.getAccountPurposeObj?.messages{
                        self.showAlert(title: "" , message: message, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
//
                    }

                }

        }
            else {
                if let message = self.getAccountPurposeObj?.messages{

                    self.showDefaultAlert(title: "", message: message)
                }

            }
}
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
                    self.getCityAgainstProvinceId()
                    
                }
               
                print("province id is", ProvinceId)
            }
            
            
        }
    }
    var CustomerId : Int?
    func FetchCustomerId()
    {
        
        
        if let  productlist = self.getCustomerTypeobj?.Customerdata
        {
            for data in productlist
            {
                if selectedCustomerType == data.customerTypeDescr
                {
                    self.CustomerId = data.customerTypeId
                    
                }
                self.CustomerId = data.customerTypeId
                print("CustomerIdis", CustomerId)
            }
            
            
        }
    }
    var ProfessionID : Int?
   
    func FetchProfessionID()
    {
        
        
        if let  productlist = self.getAllProfessionModelObj?.dataprofession    {
            for data in productlist
            {
                if selectedProfession == data.professionDescr
                {
                    self.ProfessionID = data.professionId
                    
                }
                self.ProfessionID = data.professionId
                print("ProfessionID is", ProfessionID)
            }
            
            
        }
    }
    var PurposeId : Int?
   
    func FetchPurposeId()
    {
        
        
        if let  productlist = self.getAccountPurposeObj?.accountpurpose   {
            for data in productlist
            {
                if selectedAccountPurpose == data.accountPurposeDescr
                {
                    self.PurposeId = data.accountPurposeId
                    
                }
                self.PurposeId = data.accountPurposeId
                print("PurposeId is", PurposeId)
            }
            
            
        }
    }
    
    
    var cityid : Int?
    func FetchCityId()
    {
        
        
        if let  productlist = self.getcityProvinceIdobj?.getCityprovinceId {
            for data in productlist
            {
                if selectedCity == data.cityDescr
                {
                    self.cityid = data.cityId
                    
                }
                self.cityid = data.cityId
                print("PurposeId is", PurposeId)
            }
            
            
        }
    }
    
    
    @IBAction func calculate(_ sender: UIButton) {
    
        if self.dropdowncustomertype.text == ""{
            self.showToast(title: "Please Select Customer Type")
            return
        }
        if self.dropdownprofession.text == ""{
            self.showToast(title: "Please Select profession")
            return
        }
        if self.dropdownpurpose.text == ""{
            self.showToast(title: "Please Select Purpose")
            return
        }
        if textfieldOther.text ==  "" {
            self.showToast(title: "Please Enter  Account Purpose")
            return
        }
        if DataManager.instance.provnicityid != "hide"
        {
            if self.DropdownProvince.text == ""{
                self.showToast(title: "Please Select Province")
                return
            }
           
            if self.dropdowncity.text == ""{
                self.showToast(title: "Please Select City")
                return
            }
        }
        
        if amountTextfiled.text == ""{
            self.showToast(title: "Please Enter Amount")
            return
        }
        
        self.calculateRiskScoreForUpdateWallet()
           
    }
   private func  calculateRiskScoreForUpdateWallet()
    
    {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()

        let compelteUrl = GlobalConstants.BASE_URL + "v2/calculateRiskScoreForUpdateWallet"
           
        var userCnic : String?
      
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
     if DataManager.instance.provnicityid == "hide"
    {
        let parameters = ["cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","monthlyTransVolume": amountTextfiled.text!,"customerTypeId": "\(CustomerId)" ?? "","professionId": "\(ProfessionID!)", "accountPurposeId" : "\(PurposeId!)", "provinceId": "" , "cityId": "", "otherAccountPurpose" : textfieldOther.text ?? ""] as [String : Any]
            

            print(parameters)
            
            let result = splitString(stringToSplit: base64EncodedString(params: parameters))

            let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
           
            
            let header = ["Content-Type":"application/json","Authorization":DataManager.instance.accessToken ?? "", "Accept": "application/json"]
            
            
            print(params)
            print(compelteUrl)
            NetworkManager.sharedInstance.enableCertificatePinning()
            
            NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
                
                self.hideActivityIndicator()
                self.genResponseObj = response.result.value

                if response.response?.statusCode == 200 {
                  
                    self.genResponseObj = response.result.value
                    if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
                        
                        if let message = self.genResponseObj?.messages{
                            self.showAlert(title: "Congratulations!!!", message: "Your wallet has been successfully upgraded to Level-1.", completion: {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                    }
                        else {
                            if let message = self.genResponseObj?.messages{
                                self.showAlert(title: "" , message: message, completion: {
                                })
      
                            }

                        }

                }
                    else {
                        if let message = self.genResponseObj?.messages{
                         
                            self.showDefaultAlert(title: "", message: message)
                        }

                    }
        }
            }

    
    else{
    
    let parameters = ["cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","monthlyTransVolume": amountTextfiled.text!,"customerTypeId": "\(CustomerId!)" ?? "","professionId": "\(ProfessionID!)", "accountPurposeId" : "\(PurposeId!)" ?? "", "provinceId": "\(ProvinceId!)" ?? "" , "cityId": "\(cityid!)", "otherAccountPurpose" : textfieldOther.text ?? ""] as [String : Any]
        

        print(parameters)
        
        let result = splitString(stringToSplit: base64EncodedString(params: parameters))

        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
       
        
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.accessToken ?? "", "Accept": "application/json"]
        
        
       
        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters:  params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            self.hideActivityIndicator()
            self.genResponseObj = response.result.value

            if response.response?.statusCode == 200 {
                
                self.genResponseObj = response.result.value
                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
                    if let message = self.genResponseObj?.messages{
                        self.showAlert(title: "Congratulations!!!", message: "Your wallet has been successfully upgraded to Level-1.", completion: {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    }
                }
                    else {
                        if let message = self.genResponseObj?.messages{
                            self.showAlert(title: "" , message: message, completion: {

                            })
 
                        }

                    }

            }
                else {
                    if let message = self.genResponseObj?.messages{
           
                        self.showDefaultAlert(title: "", message: message)
                    }

                }
    }
        }
    }

}
    

