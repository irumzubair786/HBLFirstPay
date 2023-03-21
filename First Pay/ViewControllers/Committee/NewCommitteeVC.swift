//
//  NewCommitteeVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 07/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import WebKit
import ContactsUI
import libPhoneNumber_iOS
class NewCommitteeVC: BaseClassVC , UITextFieldDelegate,UIWebViewDelegate, CNContactPickerDelegate {
//    var contacts = [FetchedContact]()
    private let contactPicker = CNContactPickerViewController()
    @IBOutlet weak var webview: UIWebView!
    var ischecked = "true"
    var selectcontactNo = ""
    var NameArray = [String]()
    @IBOutlet var dropDownMembers: UIDropDown!
    var membersList = [String]()
    @IBOutlet var dropDownInterval: UIDropDown!
    var intervalList = ["Monthly","Weekly","Daily"]
    @IBOutlet weak var acceptcoutlet: UIButton!
    var selectedMembers : String?
    var selectedInterval : String?
   
    
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var LblComInterval: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblInstaA: UILabel!
    
    @IBOutlet weak var lblComMem: UILabel!
    @IBOutlet weak var lblComName: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    @IBOutlet weak var canceloutelet: UIButton!
    var genResponseObj : GenericResponse?
    var participantobj : ParticipantModelUpdate?
    @IBOutlet  var committeeNameTextField: UITextField!
    @IBOutlet  var instalAmountTextField: UITextField!
    @IBOutlet  var startTextField: UITextField!
    @IBOutlet  var fineAmountTextField: UITextField!
    var amount: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        ConvertLAnguage()
//        tableview.rowHeight = 50
//        tableview.isHidden = true
        webview.delegate = self
        self.showActivityIndicator()
        self.webViewHtmlMethod()
        for n in 3...12 {
            print(n)
            self.membersList.append("\(n)")
        }
        self.methodDropDownMembers(Members: membersList)
        self.methodDropDownInterval(Interval: intervalList)
    }
    func ConvertLAnguage()
    {
        committeeNameTextField.placeholder = "Enter Committee Name".addLocalizableString(languageCode: languageCode)
        instalAmountTextField.placeholder = "Enter Amount Between 100 - 10,000".addLocalizableString(languageCode: languageCode)
        startTextField.placeholder = "Committee Start Date".addLocalizableString(languageCode: languageCode)
        canceloutelet.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        acceptcoutlet.setTitle("ACCEPT".addLocalizableString(languageCode: languageCode), for: .normal)
        
        lblMainTitle.text = "New Committee".addLocalizableString(languageCode: languageCode)
        lblComName.text = "Committee Name".addLocalizableString(languageCode: languageCode)
        lblComMem.text = "Committee Members".addLocalizableString(languageCode: languageCode)
        lblInstaA.text = "Installment Amount".addLocalizableString(languageCode: languageCode)
        lblDate.text = "Start Date".addLocalizableString(languageCode: languageCode)
        LblComInterval.text = "Committee Interval".addLocalizableString(languageCode: languageCode)
        
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
        btnsubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        
        
        
    }
    
    
    
    func webViewHtmlMethod(){
         if CheckLanguage == "en" || CheckLanguage == ""
        {
             let localfilePath = Bundle.main.url(forResource: "UTCTC", withExtension: "pdf")
             let myRequest = URLRequest(url:localfilePath!)
             webview.loadRequest(myRequest)
             print("FAQs")
         }
           
        else{
            let localfilePath = Bundle.main.url(forResource: "Committee Undertaking Urdu", withExtension: "pdf")
            let myRequest = URLRequest(url:localfilePath!)
            webview.loadRequest(myRequest)
            print("FAQs")
        }
     
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideActivityIndicator()
    }
    
    @IBAction func Addmember(_ sender: UIButton) {
//        tableview.isHidden = false
//        contactPicker.delegate = self
//        self.present(contactPicker, animated: true, completion: nil)
    }
    @IBAction func backpressed(_ sender: UIButton) {
        let comMain = self.storyboard!.instantiateViewController(withIdentifier: "CommitteeMainVC") as!CommitteeMainVC
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Utility Methods
    
    func navigateToCommitteeMainVC(){
        
        let comMain = self.storyboard!.instantiateViewController(withIdentifier: "CommitteeMainVC") as! CommitteeMainVC
//        comMain.contacts = contacts
        comMain.ischecked = "false"
        self.navigationController!.pushViewController(comMain, animated: true)
        
    }
    
    
    @IBAction func accept_action(_ sender: UIButton) {
        acceptcoutlet.isHidden = true
        canceloutelet.isHidden = true
        webview.isHidden = true
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        let commListVC = self.storyboard!.instantiateViewController(withIdentifier: "CommitteeMainVC") as! CommitteeMainVC
           commListVC.ischecked = "false"
           
       self.navigationController!.pushViewController(commListVC, animated: true)
    }
    
    //MARK: - DropDown
    
    private func methodDropDownMembers(Members:[String]) {
        
        self.dropDownMembers.placeholder = "Select Members"
        self.dropDownMembers.tableHeight = 250.0
        self.dropDownMembers.options = Members
        self.dropDownMembers.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.dropDownMembers.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.selectedMembers = option
            
        })
    }
    
    private func methodDropDownInterval(Interval:[String]) {
        
        self.dropDownInterval.placeholder = "Select Interval"
        self.dropDownInterval.tableHeight = 100.0
        self.dropDownInterval.options = Interval
        self.dropDownInterval.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.dropDownInterval.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            
            if option == "Monthly"{
                self.selectedInterval = "M"
            }
            else if option == "Weekly"{
                self.selectedInterval = "W"
            }
            else{
                self.selectedInterval = "D"
            }
        })
    }
    
    //MARK: - DatePicker Methods
    
    
    @IBAction func textFieldStartDateEditing(sender: UITextField) {
        
        let datePickerObj: UIDatePicker = UIDatePicker()
        datePickerObj.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerObj
        datePickerObj.minimumDate = datePickerObj.date
        datePickerObj.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.string(from: datePickerObj.date)
        self.startTextField.text = newDate
        if #available(ios 13.4, *)
        {
            if #available(iOS 13.4, *) {
                datePickerObj.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        startTextField.text = dateFormatter.string(from: sender.date)
        //   DataManager.instance.cnicIssueDate =  sender.date as NSDate
        DataManager.instance.startDateCommittee =  startTextField.text
    }
    
    // MARK: - Actions Methods
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        self.amount = Int(self.instalAmountTextField.text!)
        
        if committeeNameTextField.text?.count == 0 {
            self.showToast(title: "Please Enter Committee Name")
            return
        }
//        if fineAmountTextField.text?.count == 0 {
//            self.showToast(title: "Please Enter Fine Amount")
//            return
//        }
        if self.selectedMembers == nil {
            self.showToast(title: "Please Select Members")
            return
        }
        
       
        if instalAmountTextField.text?.count == 0 {
            self.showToast(title: "Please Enter Instalment Amount")
            return
        }
        if self.amount! < 100 {
            self.showToast(title: "Please Enter Amount Between 100-10,000")
            print("amount is :",amount)
            return
        }
        if self.amount! > 10000 {
            self.showToast(title: "Please Enter Amount Between 100-10,000")
            print("max amount is :",amount)
            return
        }
        if startTextField.text?.count == 0 {
            self.showToast(title: "Please Enter Start Date")
            return
        }
        
        if self.selectedInterval == nil{
            self.showToast(title: "Please Select Committee Interval")
            return
        }
        
        self.addNewCommitteeCall()
        
    }
    
    
    
    // MARK: - API CALL
    
    private func addNewCommitteeCall() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "newCommittee"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeName":self.committeeNameTextField.text!,"committeeMemebers":self.selectedMembers!,"installmentAmount":self.instalAmountTextField.text!,"startDate":self.startTextField.text!,"frequency":self.selectedInterval!,"fineAmount":""] as [String : Any]
        
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
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.genResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
                    self.showAlert(title: "Success", message: (self.genResponseObj?.messages)!, completion: {
                        self.navigateToCommitteeMainVC()
                    })
                }
                else {
                    if let message = self.genResponseObj?.messages{
                        self.showDefaultAlert(title: "Error", message: message)
                    }
                }
            }
            else {
                if let message = self.genResponseObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
   
}
//extension NewCommitteeVC: UITableViewDelegate, UITableViewDataSource
//{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return contacts.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NewMembercellVc") as! NewMembercellVc
//
//         cell.lbl.text = contacts[indexPath.row].firstName + " " + contacts[indexPath.row].lastName
//
//        cell.lblnumber.text = funFormattNumberFromContact(contactNumber: contacts[indexPath.row].telephone)
//        return cell
//
//    }
//    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
//    {
//        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//            self.contacts.remove(at: indexPath.row)
//            self.tableview.deleteRows(at: [indexPath], with: .automatic)
//            success(true)
//            tableView.reloadData()
//        })
//        deleteAction.backgroundColor = .red
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
//
//}

//extension NewCommitteeVC {
//
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//
//        let phoneNumberCount = contact.phoneNumbers.count
//      //  let name = "\(contact.givenName + contact.familyName)"
//        let namelist = "\(contact.givenName)\(contact.familyName)"
//        var namearray = [namelist]
////        self.name = namelist
//        print("name is",namearray)
//        print("name list is",namelist)
//
//        guard phoneNumberCount > 0 else {
//            dismiss(animated: true)
//            //show pop up: "Selected contact does not have a number"
//            return
//        }
//        self.contacts.append(FetchedContact(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
//        if phoneNumberCount == 1 {
//            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)
//
//        } else {
//            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)
//
//            for i in 0...phoneNumberCount-1 {
//                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
//
//                alert -> Void in
//                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
//
//                })
//                self.tableview.delegate = self
//                self.tableview.dataSource = self
//                tableview.reloadData()
//
//                alertController.addAction(phoneAction)
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
//            alert -> Void in
//
//            })
//            alertController.addAction(cancelAction)
//
//            dismiss(animated: true)
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
//
//    func setNumberFromContact(contactNumber: String) {
//
//        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER
//
//        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
//        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
//        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
//        contactNumber = contactNumber.replacingOccurrences(of: "+92", with: "0")
//        self.tableview.delegate = self
//        self.tableview.dataSource = self
//        tableview.reloadData()
//                let phoneUtil = NBPhoneNumberUtil()
//
//          do {
//
//            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(contactNumber, defaultRegion: "PK")
//            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .NATIONAL)
//
//            print("Formatted String : \(formattedString)")
//            self.selectcontactNo = replaceSpaceWithEmptyString(aStr: formattedString)
//            self.getnamelist()
//          }
//          catch let error as NSError {
//              print(error.localizedDescription)
//          }
//    }
//    func funFormattNumberFromContact(contactNumber: String) -> String {
//        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
//        contactNumber = contactNumber.replacingOccurrences(of: " ", with: "")
//        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
//        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
//        contactNumber = contactNumber.replacingOccurrences(of: "+92", with: "0")
//        return contactNumber
//    }
//
//    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
//
//    }
//    func getnamelist(){
//    let store = CNContactStore()
//    store.requestAccess(for: .contacts) { granted, error in
//        guard granted else {
//            print(error?.localizedDescription ?? "Unknown error")
//            return
//        }
//
//        let request = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor, CNContactFormatter.descriptorForRequiredKeys(for: .fullName)])
//
//        let formatter = CNContactFormatter()
//        formatter.style = .fullName
//
//        do {
//            try store.enumerateContacts(with: request) { contact, stop in
//                if let name = formatter.string(from: contact) {
//                    print(name)
//                }
//            }
//        } catch let fetchError {
//            print(fetchError)
//        }
//    }
//
//    }
//}
//
//struct FetchedContact {
//    var firstName: String
//    var lastName: String
//    var telephone: String
//}
