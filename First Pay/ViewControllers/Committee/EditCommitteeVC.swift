//
//  EditCommitteeVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 14/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class EditCommitteeVC: BaseClassVC {
    
    var commId : String?
    var installmentAmount : String?
    var committeeMemebers : String?
    var startDate : String?

    @IBOutlet var dropDownMembers: UIDropDown!
    var membersList = [String]()
    
    var selectedMembers : String?
    
    @IBOutlet  var instalAmountTextField: UITextField!
    @IBOutlet  var startTextField: UITextField!
    
    var genericResponseObj : GenericResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for n in 3...12 {
            print(n)
            self.membersList.append("\(n)")
        }
        
        self.methodDropDownMembers(Members: membersList)
        
        self.updateUI()
    }
    
    //MARK: - DropDown
    
    private func methodDropDownMembers(Members:[String]) {
        
        self.dropDownMembers.placeholder = self.committeeMemebers
        self.selectedMembers = self.committeeMemebers
     //   self.dropDownMembers.placeholder = "Select Members"
        self.dropDownMembers.tableHeight = 250.0
        self.dropDownMembers.options = Members
        self.dropDownMembers.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.dropDownMembers.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            self.selectedMembers = option
            
        })
    }
    //MARK: - Utility Methods
    
    func navigateToCommitteeListVC(){
        
        let comList = self.storyboard!.instantiateViewController(withIdentifier: "CommitteeListVC") as! CommitteeListVC
        self.navigationController!.pushViewController(comList, animated: true)
        
    }
    
    func updateUI(){
        
        if let amount = self.installmentAmount {
            self.instalAmountTextField.text = amount
        }
        if let date = self.startDate {
            self.startTextField.text = date
        }
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
           
           if self.selectedMembers == nil{
               self.showToast(title: "Please Select Members")
               return
           }
           if instalAmountTextField.text?.count == 0 {
               self.showToast(title: "Please Enter Instalment Amount")
               return
           }
           if startTextField.text?.count == 0 {
               self.showToast(title: "Please Enter Start Date")
               return
           }
           self.updateCommitteeCall()
       }
    
    
    // MARK: - API CALL
    
    private func updateCommitteeCall() {
        
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
        
        
        let compelteUrl = GlobalConstants.BASE_URL + "updateCommittee"
        
        
        let parameters = ["imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"committeeId":self.commId!,"installmentAmount":self.instalAmountTextField.text!,"committeeMemebers":self.selectedMembers!,"startDate":self.startTextField.text!]
        
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
            
            self.genericResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.genericResponseObj?.responsecode == 2 || self.genericResponseObj?.responsecode == 1 {
                    self.showAlert(title: "Success", message: (self.genericResponseObj?.messages)!, completion: {
                        self.navigateToCommitteeListVC()
                    })
                }
                else {
                    if let message = self.genericResponseObj?.messages{
                        self.showDefaultAlert(title: "Error", message: message)
                    }
                }
            }
            else {
                if let message = self.genericResponseObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//               
            }
        }
    }
    
}
