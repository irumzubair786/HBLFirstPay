//
//  InviteFriendVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 11/03/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS


class InviteFriendVC: BaseClassVC , UITextFieldDelegate{
    
    @IBOutlet weak var walletNoTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    var genResObj : GenericResponse?
    var invitorDetailObj : InviteFriendModelz?
    private let contactPicker = CNContactPickerViewController()
    
    @IBOutlet weak var btnSubmit: UIButton!
   
    @IBOutlet weak var btninvite: UIButton!
    @IBOutlet weak var lblEnterName: UILabel!
    @IBOutlet weak var lblEnterPhoneNo: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLanguage()
        walletNoTextField.delegate = self
        tableview.isHidden = true
    }
     func changeLanguage()
     {
        lblMainTitle.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblEnterName.text = "Enter Name".addLocalizableString(languageCode: languageCode)
        lblEnterPhoneNo.text = "Enter Phone Number".addLocalizableString(languageCode: languageCode)
        btnSubmit.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
         btninvite.setTitle("InviteFriend Show".addLocalizableString(languageCode: languageCode), for: .normal)
        
     }
    
    @IBAction func invitefriend(_ sender: UIButton) {
//     email+invitefriends
        inviteFriendDetail()
    }
    
    // MARK: - Actions Method
    
    @IBAction func submitPressed(_ sender: Any) {
        
        if walletNoTextField.text?.count == 0 {
            self.showDefaultAlert(title: "", message: "Please enter wallet number")
            return
        }
        if nameTextField.text?.count == 0 {
            self.showDefaultAlert(title: "", message: "Please enter name")
            return
        }
        
        self.inviteFriendCall()
        
    }
    
    @IBAction func getContactsPressed(_ sender: Any) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    // MARK: - UITextfield Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == walletNoTextField{
            return newLength <= 11
        }
        else {
            return newLength <= 30
        }
    }
    
    // MARK: - API call
    
    public func inviteFriendCall(){
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "inviteFriends"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"mobileNo":self.walletNoTextField.text!,"name":self.nameTextField.text!]
        
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
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<MiniStatementModel>) in
            
            self.hideActivityIndicator()
            
            self.genResObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genResObj?.responsecode == 2 || self.genResObj?.responsecode == 1 {
                    if let message = self.genResObj?.messages{
                        self.showAlert(title: "", message: message, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
                else {
                    if let message = self.genResObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genResObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
//    invitordetailmode
    
    public func inviteFriendDetail(){
        
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
        
        let compelteUrl = GlobalConstants.BASE_URL + "getInvitorFriendsDetails"
        
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"mobileNo":self.walletNoTextField.text!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<InviteFriendModelz>) in
            
            //        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<MiniStatementModel>) in
            
            self.hideActivityIndicator()
            
            self.invitorDetailObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.invitorDetailObj?.responsecode == 2 || self.invitorDetailObj?.responsecode == 1 {
                    self.tableview.isHidden = false
                    self.tableview.delegate = self
                    self.tableview.rowHeight = 200
                    self.tableview.dataSource = self
                    self.tableview.reloadData()
                }
                else {
                    if let message = self.invitorDetailObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.invitorDetailObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    
//    end
    
    

}

extension InviteFriendVC: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count
      //  let name = "\(contact.givenName + contact.familyName)"
        let name = "\(contact.givenName) \(contact.familyName)"
        
        self.nameTextField.text = name

        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }

        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)

        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)

            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
            alert -> Void in

            })
            alertController.addAction(cancelAction)

            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func setNumberFromContact(contactNumber: String) {

        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER

        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        

        
        let phoneUtil = NBPhoneNumberUtil()

          do {
            
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(contactNumber, defaultRegion: "PK")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .NATIONAL)

            print("Formatted String : \(formattedString)")
            self.walletNoTextField.text = replaceSpaceWithEmptyString(aStr: formattedString)
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
      
    }
}

extension InviteFriendVC: UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitorDetailObj?.dataInvitee?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableview.dequeueReusableCell(withIdentifier: "InviteFriendCell") as! InviteFriendCell

        let aRequest = self.invitorDetailObj?.dataInvitee?[indexPath.row]
        aCell.backview.dropShadow1()
        aCell.lblname.text = aRequest?.name
        aCell.lblnumer.text = aRequest?.mobNo
        aCell.lblincentvieamount.text = "PKR:\(aRequest?.inVitorIncentiveAmount! ?? -1)"
        aCell.lblInvitorCrdt.text = aRequest?.isInvitorCredited
        aCell.lblInviteeCerdt.text = aRequest?.isInviteeCredited
        if aRequest?.isAccepted == "Accepted"
        {
            aCell.status.text = aRequest?.isAccepted
            aCell.status.textColor = UIColor.green
        }
        else{
            aCell.status.textColor = UIColor.red
            aCell.status.text = aRequest?.isAccepted
        }
        
        
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
}


