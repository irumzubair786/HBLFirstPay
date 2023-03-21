//
//  DebitCardRequestVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 10/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import AlamofireObjectMapper

class DebitCardRequestVC: BaseClassVC , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var lblNameOnCard: UILabel!
    @IBOutlet weak var nameTableView: UITableView?
    @IBOutlet var dropDownOptions: UIDropDown!
    @IBOutlet var dropDownBranches: UIDropDown!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var postalAddressTextField: UITextField!
    var checkDebitCardObj : GetDebitCardCheckModel?
    var getBranchesObj : GetAllBranchesModel?
    var genericRespObj: GenericResponse?
    var arrNameList : [String]?
    var nameSelected:[String] = []
    var selectedBranch:String?
    var selectedDeliveryType: String?
    var selectedBranchCode: String?
    var arrBranchList : [String]?
    var branchList = [BranchData]()
    
    @IBOutlet weak var lblMaintiltle: UILabel!
    
    @IBOutlet weak var lblWalletNo: UILabel!
    
    @IBOutlet weak var lblcharges: UILabel!
    
    @IBOutlet weak var lblnameOn: UILabel!
    
    
    @IBOutlet weak var btnsbmt: UIButton!
    @IBOutlet weak var btnterms: UIButton!
    @IBOutlet weak var lblTermsA: UILabel!
    
    @IBOutlet weak var lblChargesTitle: UILabel!
    @IBOutlet weak var lblCharges: UILabel!
    var termsAccepted:Bool?
    @IBOutlet weak var checkboxButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Convertlanguage()
        self.getDebitCardCheck()
        self.tableViewCall()
        self.updateUI()
        termsAccepted = false
        self.nameTableView?.delegate = self
        self.nameTableView?.dataSource = self
        self.dropDownBranches.isHidden = true
        self.lblCharges.isHidden = true
        self.lblChargesTitle.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    func Convertlanguage()
    {
      
       
        lblMaintiltle.text = "Card Request".addLocalizableString(languageCode: languageCode)
        lblWalletNo.text = "Wallet No".addLocalizableString(languageCode: languageCode)
        accountNumberTextField.placeholder = "Enter 11 Digit Account Number".addLocalizableString(languageCode: languageCode)
        btnsbmt.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        lblnameOn.text = "Name on Card".addLocalizableString(languageCode: languageCode)
        lblCharges.text = "Charges".addLocalizableString(languageCode: languageCode)
        lblTermsA.text = "Please accept Terms & Conditions".addLocalizableString(languageCode: languageCode)
        btnterms.setTitle("Terms & Conditions".addLocalizableString(languageCode: languageCode),for: .normal)
        postalAddressTextField.text = "Postal Address".addLocalizableString(languageCode: languageCode)
        
    }
    //MARK: - DropDown
    
    private func methodDropDownOptions() {
        
        self.dropDownOptions.tableHeight = 100.0
        self.dropDownOptions.placeholder = "Select Delivery Type".addLocalizableString(languageCode: languageCode)
        self.dropDownOptions.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        self.dropDownOptions.options = ["Home","Branch"]
        self.dropDownOptions.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            
            if index == 1 {
                self.getBranches()
                self.dropDownBranches.isHidden = false
                self.selectedDeliveryType = "S"
                self.postalAddressTextField.text = ""
                self.lblCharges.text = self.checkDebitCardObj?.data?.dcCharges
                self.lblCharges.isHidden = false
                self.lblChargesTitle.isHidden = false
            }
            else  {
                self.postalAddressTextField.isUserInteractionEnabled = false
                self.dropDownBranches.isHidden = true
                self.postalAddressTextField.isUserInteractionEnabled = true
                self.postalAddressTextField.text = self.checkDebitCardObj?.data?.address
                if let address = self.checkDebitCardObj?.data?.address{
                    self.postalAddressTextField.text = address
                    self.postalAddressTextField.isUserInteractionEnabled = true
                    self.selectedDeliveryType = "D"
                    self.lblCharges.text = self.checkDebitCardObj?.data?.dcChargesWithDelivery
                    self.lblCharges.isHidden = false
                    self.lblChargesTitle.isHidden = false
                    self.showDefaultAlert(title: "Disclaimer", message: "For Successful home delivery, the provided address must be in reach of courier service.".addLocalizableString(languageCode: languageCode))
                 
                    
                    
                }
            }
            
            
        })
    }
    
    private func methodDropDownBranches(Branches:[String]) {
        
        self.dropDownBranches.placeholder = "Select Branch".addLocalizableString(languageCode: languageCode)
        self.dropDownBranches.tableHeight = 200.0
        self.dropDownBranches.options = Branches
        self.dropDownBranches.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.dropDownBranches.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.selectedBranch = option
            
            let title = self.selectedBranch
            for aBranch in self.branchList {
                if aBranch.branchDescr == title {
                    
                    if let address = aBranch.address1{
                        self.postalAddressTextField.text = address
                    }
                    else{
                        self.postalAddressTextField.text = aBranch.branchDescr
                    }
                    
                    self.selectedBranchCode = aBranch.branchCode
                    
                    print(aBranch)
                    
                }
            }
        })
    }
        
    // MARK: - Utility Methods
    
    func updateUI(){
        
        self.accountNumberTextField.text = DataManager.instance.accountNo
        
        self.methodDropDownOptions()
        
    }
    
    func tableViewCall(){
        nameTableView!.setEditing(true, animated: false)
        self.nameTableView!.allowsMultipleSelection = true
        self.nameTableView!.allowsMultipleSelectionDuringEditing = true
    }
    func navigateToConfirmation(){
        
        let debitCardConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "DebitCardRequestConfirmationVC") as! DebitCardRequestConfirmationVC
        
        debitCardConfirmVC.nameOnCard = self.lblNameOnCard.text
        debitCardConfirmVC.deliveryType = self.selectedDeliveryType
        debitCardConfirmVC.deliveryAddress = self.postalAddressTextField.text
        if let branchCode = self.selectedBranchCode{
            debitCardConfirmVC.branchCode = branchCode
        }
        else{
            debitCardConfirmVC.branchCode = ""
        }
        debitCardConfirmVC.otpReq = checkDebitCardObj?.data?.otpReq
        
        self.getOtpForDebitCard()
        
        self.navigationController!.pushViewController(debitCardConfirmVC, animated: true)
        
    }
    
    // MARK: - Action Method
    
    @IBAction func acceptTermsPressed(_ sender: Any) {
        termsAccepted = !termsAccepted!
        
        if termsAccepted! {
            checkboxButton.setImage(#imageLiteral(resourceName: "checkbox_state2"), for: .normal)
        }
        else {
            checkboxButton.setImage(#imageLiteral(resourceName: "checkbox_state1"), for: .normal)
        }
    }
    @IBAction func TermsAndConditionPressed(_ sender: Any) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
        webVC.forDebitCardRequest = true
        webVC.forHTML = true
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        
        
        if self.lblNameOnCard.text?.count == 0{
            self.showToast(title:"Please select name")
            return
        }
        if self.postalAddressTextField.text?.count == 0{
            self.showToast(title:"Please select address")
            return
        }
        if !self.termsAccepted!{
            self.showDefaultAlert(title: "Terms & Conditions", message: "Please accept Terms & Conditions")
            return
        }
        
        self.navigateToConfirmation()
        
    }
    
    
    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = arrNameList?.count{
            print(arrNameList)
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomCell
        
        aCell.lblNameOnCard.text = "\(arrNameList![indexPath.row])"
        return aCell
    }
    
    private func tableView(tableView: UITableView,
                           editingStyleForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell.EditingStyle {
            
            return UITableViewCell.EditingStyle.init(rawValue: 3)!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!nameSelected.contains(arrNameList![indexPath.row])){
            nameSelected.append(arrNameList![indexPath.row])
        }
        
        let stringArray = nameSelected
        let string = stringArray.joined(separator: " ")
        
        self.lblNameOnCard.text = string
        print(nameSelected)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deselected  \(arrNameList![indexPath.row])")
        nameSelected = nameSelected.filter({$0 != arrNameList![indexPath.row]})
        
        let stringArray = nameSelected
        let string = stringArray.joined(separator: " ")
        self.lblNameOnCard.text = string
        
        print(nameSelected)
        
    }
    
    
    // MARK: - Api Call
    
    private func getDebitCardCheck() {
        
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
        
        showActivityIndicator()
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "debitCardEligibilityCheck"
        
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)","dcType":""]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GetDebitCardCheckModel>) in
            
            
            self.hideActivityIndicator()
            
            self.checkDebitCardObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.checkDebitCardObj?.responsecode == 2 || self.checkDebitCardObj?.responsecode == 1 {
                    
                    let fullName = self.checkDebitCardObj?.data?.customerName
                    //     let fullNameArr = fullName?.components(separatedBy: " ")/*fullName?.split{$0 == " "}.map(String.init)*/
                    self.arrNameList = fullName?.components(separatedBy: " ")
                    self.arrNameList = self.arrNameList?.filter({ $0 != ""})
                    
                    self.nameTableView?.reloadData()
                    
                }
                else {
                    
                    if let message = self.checkDebitCardObj?.messages{
                        if message == "No Debit Card Information Found"
                        {
                            self.showToast(title: "No Debit Card Information Found")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6)  {
                                self.movetoback()
                            }

                        }

//                        self.showDefaultAlert(title: "", message: message)
//                        self.movetoback()
                    }
                    
                }
            }
            else {
                if let message = self.checkDebitCardObj?.messages{
                    
                    self.showDefaultAlert(title: "", message: message)
                    self.movetoback()
                }
                else{
                    self.showDefaultAlert(title: "", message: "Failure")
                    self.movetoback()
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                self.movetoback()
            }
        }
    }
    func movetoback()
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OtherHomeVC") as! OtherHomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getBranches() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getAllBranches"
        let header = ["Content-Type":"application/json","Authorization":"Bearer \(DataManager.instance.accessToken!)"]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetAllBranchesModel>) in
            
            self.hideActivityIndicator()
            
            self.getBranchesObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.getBranchesObj?.responsecode == 2 || self.getBranchesObj?.responsecode == 1 {
                    
                    if let branch = self.getBranchesObj?.data {
                        self.branchList = branch
                    }
                    self.arrBranchList =  self.getBranchesObj?.stringBranch
                    self.methodDropDownBranches(Branches: self.arrBranchList!)
                }
                else {
                    // self.showAlert(title: "", message: (self.shopInfo?.resultDesc)!, completion: nil)
                }
            }
            else {
                
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
    
    private func getOtpForDebitCard() {
        
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
        
        showActivityIndicator()
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "sendOtpForDebitCard"
        
        let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"channelId":"\(DataManager.instance.channelID)"]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.genericRespObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genericRespObj?.responsecode == 2 || self.genericRespObj?.responsecode == 1 {
                    
                }
                else {
                    if let message = self.genericRespObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genericRespObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
}


