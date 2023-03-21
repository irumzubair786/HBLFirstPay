//
//  PersonalDataVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 13/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import iOSDropDown

class PersonalDataVC: BaseClassVC , UITextFieldDelegate {
    let encryptionkey = "65412399991212FF65412399991212FF65412399991212FF"
    
    @IBOutlet weak var viewBottomButtons: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var refferdropdown: DropDown!
    @IBOutlet  var firstNameTextField: UITextField!
    @IBOutlet  var middleNameTextField: UITextField!
    @IBOutlet  var lastNameTextField: UITextField!
    @IBOutlet  var motherNameTextField: UITextField!
    @IBOutlet  var emailAddressTextField: UITextField!
    @IBOutlet weak var mothernamelistview: UIView!
    @IBOutlet weak var radiobtn1: UIButton!
    @IBOutlet weak var radiobtn2: UIButton!
    @IBOutlet weak var radiobtn4: UIButton!
    @IBOutlet weak var radiobtn3: UIButton!
    @IBOutlet weak var lblmotherN1: UILabel!
    @IBOutlet weak var lblMotherName2: UILabel!
    @IBOutlet weak var lblMotherName3: UILabel!
    @IBOutlet weak var lblMotherName4: UILabel!
    
    @IBOutlet weak var InviteFriendTextField: DropDown!
    
    var isFor:String?
    @IBOutlet var dropDownCities: DropDown!
    var cityListObj : CitiesList?
    var InviteFriendOBj : InvitationFriendModel?
    var arrCitiesList : [String]?
    var selectedInvitdeFriend: String?
    var InviteArray = [String]()
    var cityID: Int?
    var cityDescr: String?
    var custAllID : Int?
   
    var my_arry2  = [my_list]()
  
    var personalDataObj : PersonalData?
//    reffered by id
    var refferdListobj : RefferedList?
    var reffrID : Int?
    var Descrffr : String?
    var arrRefferList : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InviteFriendTextField.isHidden = true
        self.dismissKeyboard()
        self.getCities()
        self.InviteFriend()
//       UtilityBillPaymentOneBillVC
        self.updateUI()
      
        InviteFriendTextField.delegate  = self
        self.refferdropdown.placeholder = "How Did You Hear About Us?"
        refferdropdown.isSearchEnable = true
      
        self.dropDownCities.placeholder = "Select City Of Residence"
        
        InviteFriendTextField.dropShadow1()
        InviteFriendTextField.placeholder = "Select Friend"
        self.InviteFriendTextField.didSelect{(b , index ,id) in
                    self.selectedInvitdeFriend = b
            self.FetchInviteFriend()
            self.InviteFriendTextField.rowHeight = 30

            self.InviteFriendTextField.isSelected = true
            self.InviteFriendTextField.selectedRowColor = UIColor.gray
            self.InviteFriendTextField.isSearchEnable = true
            
        }
        
        // Do any additional setup after loading the view.
    }
//    dropdown refferby
    private func dropdownrefferby(List:[String]){
        self.refferdropdown.optionArray = List
        self.refferdropdown.placeholder = "How Did You Hear About Us?"
        refferdropdown.isSearchEnable = true
        self.refferdropdown.didSelect{(selectedText , index , id ) in
            print("you select: \(selectedText) at index:\(index) ")
            let refr = selectedText
            for arfr in (self.refferdListobj?.data)! {
                if arfr.descr == refr{
                    self.reffrID = arfr.referredById
                    self.Descrffr = arfr.descr
//                    self.InviteFriend()
                    print("\(String(describing: self.reffrID))")
                    print("\(String(describing: self.Descrffr))")  
                }
        }
    }
        refferdropdown.selectedRowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.refferdropdown.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.refferdropdown.textColor = UIColor.black
        self.refferdropdown.isSearchEnable = true
    }                                          
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCities()
       
       self.updateUI()
    }
//    end
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (self.viewBottomButtons.frame.origin.y) + (self.viewBottomButtons.frame.size.height) + 50)
    }
//    ---------radiobuttonactions
   
    @IBAction func Radiobtn1_mothername(_ sender: UIButton) {
        radiobtn1.setImage(#imageLiteral(resourceName: "checkbtn"), for: .normal)
        radiobtn2.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
        radiobtn3.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
        radiobtn4.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
        motherNameTextField.text = lblmotherN1.text!
    }
    
    @IBAction func Radiobutton2_mothername(_ sender: UIButton) {
                radiobtn2.setImage(#imageLiteral(resourceName: "checkbtn"), for: .normal)
                radiobtn1.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
                radiobtn3.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
                radiobtn4.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
        motherNameTextField.text = lblMotherName2.text!
    }
    
    @IBAction func Radiobutton3_mothername(_ sender: UIButton) {
                       radiobtn3.setImage(#imageLiteral(resourceName: "checkbtn"), for: .normal)
                       radiobtn1.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
                       radiobtn2.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
                       radiobtn4.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
        motherNameTextField.text = lblMotherName3.text!
    }
    
    @IBAction func Radiobutton4_mothername(_ sender: UIButton) {
                       radiobtn4.setImage(#imageLiteral(resourceName: "checkbtn"), for: .normal)
                       radiobtn1.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
                       radiobtn3.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
                       radiobtn2.setImage(#imageLiteral(resourceName: "uncheckbtn"), for: .normal)
        motherNameTextField.text = lblMotherName4.text!

    }
    
    
    //MARK: - DropDown
    
    private func methodDropDownCities(Cities:[String]) {
        
        
        self.dropDownCities.optionArray = Cities
        dropDownCities.isSearchEnable = true
        self.dropDownCities.placeholder = "Select City Of Residence"
        self.dropDownCities.didSelect{(selectedText , index ,id) in
        //    self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
            print("You Just select: \(selectedText) at index: \(index)")
            let city = selectedText
            for aCity in (self.cityListObj?.citiesList)! {
                if aCity.cityDescr == city {
                    self.cityID = aCity.cityID
                    self.cityDescr = aCity.cityDescr
                    print("\(self.cityID)")
                    print("\(self.cityDescr)")
                }
            }
        }
        
        
     //   self.dropDownCities.tableHeight = 150.0
        self.dropDownCities.rowBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.dropDownCities.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.dropDownCities.selectedRowColor = UIColor.gray
        self.dropDownCities.isSearchEnable = true
        
   //     self.dropDownCities.optionsTextColor =  #colorLiteral(red: 0.1286819577, green: 0.3171259165, blue: 0.6042343378, alpha: 1)
  //      self.dropDownCities.options = Cities
//        self.dropDownCities.didSelect(completion: {
//            (option , index) in
//            print("You Just select: \(option) at index: \(index)")
//            //            self.sourceAccount = option
//
//            let city = option
//            for aCity in (self.cityListObj?.citiesList)! {
//                if aCity.cityDescr == city {
//                    self.cityID = aCity.cityID
//                    self.cityDescr = aCity.cityDescr
//                    print("\(self.cityID)")
//                    print("\(self.cityDescr)")
//                }
//            }
//        })
    }

   
    
    //MARK: - Utility Methods
    
    private func updateUI(){
        
        self.firstNameTextField.text = my_arry2[0].firstname
        self.middleNameTextField.text = my_arry2[0].mddlname
        self.lastNameTextField.text = my_arry2[0].lstname
       
        if(my_arry2[0].mothrname.isEmpty == false){
            if (my_arry2[0].mothrname.count == 4 ){
               
               self.lblmotherN1.text = my_arry2[0].mothrname[0]
               self.lblMotherName2.text = my_arry2[0].mothrname[1]
               self.lblMotherName3.text =  my_arry2[0].mothrname[2]
               self.lblMotherName4.text =  my_arry2[0].mothrname[3]
            }
        }else{
            
            mothernamelistview.isHidden = true
        }
        
        
        
    }
    
    private func navigateToNextScreen(){
        
   //     let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "PersonalDataCnicPhotoVC") as! PersonalDataCnicPhotoVC
        
//        if firstNameTextField.text != nil {
//            nextVC.firstName = firstNameTextField.text
//        }
//        if middleNameTextField.text != nil {
//            nextVC.middleName = middleNameTextField.text
//        }
//        if lastNameTextField.text != nil {
//            nextVC.lastName = lastNameTextField.text
//        }
//        if motherNameTextField.text != nil {
//            nextVC.motherName = motherNameTextField.text
//        }
//        if emailAddressTextField.text != nil {
//            nextVC.emailAddress = emailAddressTextField.text
//        }
//        if cityID != nil {
//            nextVC.cityID = cityID
//        }
        
   //     self.navigationController!.pushViewController(nextVC, animated: true)
//
        let EmailSaved = UserDefaults.standard.object(forKey: "EmailVerification")
        print("emailAddressTextField", EmailSaved)

        if DataManager.instance.InviteFriendResponse == self.InviteFriendOBj?.messages
        {
           
            self.proceesToPin()
        }
        else
        {
            proceesToPinInviteFriend()
        }
       
    }
    
    //MARK: - Action Methods

    
    @IBAction func nextButtonPressed(_ sender: Any)  {
        
        if firstNameTextField.text?.count == 0{
            self.showToast(title: "Please Enter First Name")
            return
           
        }
        if lastNameTextField.text?.count == 0{
            self.showToast(title: "Please Enter Last Name")
            return
        }
        if motherNameTextField.text?.count == 0{
            self.showToast(title: "Please Enter Mother Name")
            return
        }
        if self.cityID == nil {
            self.showToast(title: "Please Select City Of Residence")
            return
        }
       
        
        if isValidEmail(testStr: emailAddressTextField.text!)
        {
           
            print("Valid Email ID")
//            muhammad.kashif6@hblmfb.com
//            DataManager.instance.UserEmail = "muhammad.kashif6@hblmfb.com"
//            DataManager.instance.UserEmail = emailAddressTextField.text
//            let EmailSaved = UserDefaults.standard.set(forKey: "EmailVerification")
            let EmailSaved = UserDefaults.standard.setValue(emailAddressTextField.text, forKey: "EmailVerification")
            print("emailAddressTextField", EmailSaved)
            // self.showToast(title: "Validate EmailID")
        }
        else
        {
            print("Invalid Email ID")
            self.showDefaultAlert(title: "Error", message: "Invalid Email ID")
            return
        }
//        if emailAddressTextField.text?.count == 0{
//            self.showToast(title: "Please Enter Email")
//            return
//        }
        if reffrID == nil
        {
            self.showToast(title: "Please Select Reffer")
            return
        }
        if InviteFriendTextField.isHidden == false
        {
            if InviteFriendId == nil
            {
                self.showToast(title: "Please Select Invitor")
                return
            }
        }
        self.navigateToNextScreen()
        
    }
    
    //MARK: - API CALL
    
    private func getCities(){
        
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getAllLocations"
        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecret]
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CitiesList>) in
     //       Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CitiesList>) in
            
            self.hideActivityIndicator()
            
            self.cityListObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.cityListObj?.responsecode == 2 || self.cityListObj?.responsecode == 1 {
                    
                    self.arrCitiesList = self.cityListObj?.stringCities
                    self.methodDropDownCities(Cities: self.arrCitiesList!)
                    self.getRefferID()
                }
                else{
                    if let message = self.cityListObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                       
                    }
                }
            }
            else {
                if let message = self.cityListObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                   
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
//    MARK:- INVITE FRIEND API
    private func InviteFriend(){
        
        
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
       
        let compelteUrl = GlobalConstants.BASE_URL + "getInvitorFriendsList"
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"mobileNo": DataManager.instance.mobile_number!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        
//        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<InvitationFriendModel>) in
            Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<InvitationFriendModel>) in

            
            self.hideActivityIndicator()
            
            self.InviteFriendOBj = response.result.value
            if self.InviteFriendOBj?.responsecode == 0
            {   self.InviteFriendTextField.isHidden = true
                DataManager.instance.InviteFriendResponse = self.InviteFriendOBj?.messages
            }
            if response.response?.statusCode == 200 {
                
              
                
                if self.InviteFriendOBj?.responsecode == 2 || self.InviteFriendOBj?.responsecode == 1 {
                    self.InviteFriendTextField.placeholder = "Select the invitor".addLocalizableString(languageCode: languageCode)
                    self.InviteFriendTextField.isHidden = false
                    if let InviteList = self.InviteFriendOBj?.Invitedata{
                        for data in InviteList
                        {
                            
                            
                            self.InviteArray.append(data.invitorName ?? "")
//
                        }
                        self.InviteFriendTextField.optionArray = self.InviteArray
                      
                      
                    }
                    
                }
                else{
                    if let message = self.InviteFriendOBj?.messages{
//                        self.showDefaultAlert(title: "", message: message)
                       
                    }
                }
            }
            else {
                if let message = self.InviteFriendOBj?.messages{
//                    self.showDefaultAlert(title: "", message: message)
                   
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
//    END
    
    
    var InviteFriendId : Int?
    func FetchInviteFriend()
    {
        
        
        if let  productlist = self.InviteFriendOBj?.Invitedata       {
            for data in productlist
            {
                if selectedInvitdeFriend == data.invitorName
                {
                    InviteFriendId = data.friendInviteId
//                    self.getCityAgainstProvinceId()
                    
                }
               
                print("InviteFriend Id is", InviteFriendId)
            }
            
            
        }
    }


//     MARK: - Api Call
    
    private func proceesToPin() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        if (firstNameTextField.text!.isEmpty){
            firstNameTextField.text = ""
        }
        if (middleNameTextField.text!.isEmpty){
            middleNameTextField.text = ""
        }
        if (lastNameTextField.text?.isEmpty)!{
            lastNameTextField.text? = ""
        }
        if (motherNameTextField.text?.isEmpty)!{
            motherNameTextField.text = ""
        }
        if (emailAddressTextField.text?.isEmpty)!{
            emailAddressTextField.text = ""
        }
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        if emailAddressTextField.text?.count == 0{
            emailAddressTextField.text = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "customerKyc"
       
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"email":emailAddressTextField.text!,"firstName":firstNameTextField.text!,"lastName":lastNameTextField.text!,"middleName":middleNameTextField.text!,"motherName":motherNameTextField.text!,"custselfie":"","custcnicF":"","custcnicB":"","createuser":"1","cnicIssueDate":DataManager.instance.cnicIssueDate!,"lkpCity":["cityId":"\(self.cityID!)"],"friendInviteeId": ""] as [String : Any]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)","custselfie":"","custcnicF":"","custcnicB":""]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<PersonalData>) in
            
     //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<PersonalData>) in
            
            
            
            self.hideActivityIndicator()
            
            self.personalDataObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.personalDataObj?.responsecode == 2 || self.personalDataObj?.responsecode == 1 {
                    let EmailSaved = UserDefaults.standard.setValue(self.emailAddressTextField.text, forKey: "EmailVerification")
                    print("emailAddressTextField", EmailSaved)
                    let enterPinVC = self.storyboard!.instantiateViewController(withIdentifier: "EnterPinVC") as! EnterPinVC
                    if let custID = self.personalDataObj?.customerId{
                        enterPinVC.customerID = custID
                    }
                    self.navigationController!.pushViewController(enterPinVC, animated: true)
                }
                else {
                    if let message = self.personalDataObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.personalDataObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
//    +=====================proceestopin for invitefreirnd
    private func proceesToPinInviteFriend() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        if (firstNameTextField.text!.isEmpty){
            firstNameTextField.text = ""
        }
        if (middleNameTextField.text!.isEmpty){
            middleNameTextField.text = ""
        }
        if (lastNameTextField.text?.isEmpty)!{
            lastNameTextField.text? = ""
        }
        if (motherNameTextField.text?.isEmpty)!{
            motherNameTextField.text = ""
        }
        if (emailAddressTextField.text?.isEmpty)!{
            emailAddressTextField.text = ""
        }
        
        var userCnic : String?
        
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        
        if emailAddressTextField.text?.count == 0{
            emailAddressTextField.text = ""
        }
        
        let compelteUrl = GlobalConstants.BASE_URL + "customerKyc"
       
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"email":emailAddressTextField.text!,"firstName":firstNameTextField.text!,"lastName":lastNameTextField.text!,"middleName":middleNameTextField.text!,"motherName":motherNameTextField.text!,"custselfie":"","custcnicF":"","custcnicB":"","createuser":"1","cnicIssueDate":DataManager.instance.cnicIssueDate!,"lkpCity":["cityId":"\(self.cityID!)"],"friendInviteeId": InviteFriendId!] as [String : Any]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)","custselfie":"","custcnicF":"","custcnicB":""]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<PersonalData>) in
            
     //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<PersonalData>) in
            
            
            
            self.hideActivityIndicator()
            
            self.personalDataObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.personalDataObj?.responsecode == 2 || self.personalDataObj?.responsecode == 1 {
                    let EmailSaved = UserDefaults.standard.setValue(self.emailAddressTextField.text, forKey: "EmailVerification")
                    print("emailAddressTextField", EmailSaved)
                    let enterPinVC = self.storyboard!.instantiateViewController(withIdentifier: "EnterPinVC") as! EnterPinVC
                    if let custID = self.personalDataObj?.customerId{
                        enterPinVC.customerID = custID
                    }
                    self.navigationController!.pushViewController(enterPinVC, animated: true)
                }
                else {
                    if let message = self.personalDataObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.personalDataObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
//    ======================end
//============refferedby getid
    private func getRefferID()
    {
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
        
        let compelteRefUrl = GlobalConstants.BASE_URL + "getAllReferredBy"
//        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecret]
        
//        print(header)
        print(compelteRefUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteRefUrl).responseObject { (response: DataResponse<RefferedList>) in
     //       Alamofire.request(compelteUrl, headers:header).responseObject { (response: DataResponse<CitiesList>) in
            
            self.hideActivityIndicator()
        
            self.refferdListobj = response.result.value
            
            if response.response?.statusCode == 200 {
                
                if self.refferdListobj?.responsecode == 1
                {
                    self.arrRefferList = self.refferdListobj?.stringlist
                    self.dropdownrefferby(List: self.arrRefferList!)
                  
                }
                else{
                    if let message = self.cityListObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
                
        
        else {
                    if let message = self.refferdListobj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                   
                    }
//                    print(response.result.value)
//                    print(response.response?.statusCode)
                }
                
            }
     
    }
    
    @IBAction func backpressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
        
}



