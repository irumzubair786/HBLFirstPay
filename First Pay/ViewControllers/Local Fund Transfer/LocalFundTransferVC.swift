//
//  LocalFundTransferVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 05/12/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS
import SCLAlertView
class LocalFundTransferVC: BaseClassVC, UITextFieldDelegate {
    
    @IBOutlet var dropDownReasons: UIDropDown!
    @IBOutlet weak var btncontactlist: UIButton!
    var sourceReasonCodeForTrans: String?
    var sourceReasonTitleForTrans : String?
    @IBOutlet weak var sourceAccountNumberTextField: UITextField!
    @IBOutlet weak var beneAccountNumberTextField: UITextField!
    @IBOutlet weak var ammountTextField: UITextField!
    @IBOutlet weak var lblCurrentBalance: UILabel!
    var mainTitle : String?
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblWalletAccountTitle: UILabel!
    var walletAccountTitle : String?
    var transactionApiResponseObj : FTApiResponse?
    var reasonsObj : GetReasonsModel?
    var reasonsList = [ReasonsData]()
    var isFromQuickPay:Bool = false
    var isFromRequestMoney:Bool = false
    var beneficiaryAccount:String?
    var requestedAmount : String?
    var requesterMoneyId : String?
    
    var arrReasonsList : [String]?
    var isFromDonations:Bool = false
    
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!
    @IBOutlet weak var lblInviteFriend: UILabel!
    @IBOutlet weak var lblLocalFundsTransfer: UILabel!
    @IBOutlet weak var lblSourceAccount: UILabel!
    @IBOutlet weak var lblBeneficiaryWALLETACCOUNT: UILabel!
    @IBOutlet weak var lblTransferAmount: UILabel!
    @IBOutlet weak var LblPurposePayment: UILabel!
    @IBOutlet weak var btnSubmitt: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
   
    private let contactPicker = CNContactPickerViewController()
    
    override func viewDidLoad() {
        Changelanguagex()
        beneAccountNumberTextField.delegate = self
        if isFromQuickPay == true{
            self.beneAccountNumberTextField.isUserInteractionEnabled = false
        }
        if isFromRequestMoney == true{
            self.beneAccountNumberTextField.isUserInteractionEnabled = false
            self.ammountTextField.isUserInteractionEnabled = true
            DataManager.instance.requesterMoneyId = self.requesterMoneyId
        }
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    
    
    private func updateUI(){
        
        self.getReasonsForTrans()
        self.sourceAccountNumberTextField.text = DataManager.instance.accountNo
        self.sourceAccountNumberTextField.isUserInteractionEnabled = false
        
        if let beneAccount = self.beneficiaryAccount{
            self.beneAccountNumberTextField.text = beneAccount
        }
        if let reqAmount = self.requestedAmount{
            self.ammountTextField.text = reqAmount
        }
        if let title = self.mainTitle{
            if title == "Wallet to Conventional".addLocalizableString(languageCode: languageCode)
            {
                btncontactlist.isHidden = true
                beneAccountNumberTextField.placeholder = "Enter 16 digit account no".addLocalizableString(languageCode: languageCode)
                ammountTextField.placeholder  = "Enter Amount".addLocalizableString(languageCode: languageCode)
            }
            else
            {
                beneAccountNumberTextField.placeholder = "Enter 11 digit Mobile no".addLocalizableString(languageCode: languageCode)
                ammountTextField.placeholder = "Enter Amount".addLocalizableString(languageCode: languageCode)
                btncontactlist.isHidden = false
            }
            if isFromDonations == true{
                self.lblMainTitle.text = mainTitle
            }
            else
            {
                self.lblMainTitle.text = title
            }
            
            
        }
        
        if let walletAccount = self.walletAccountTitle{
            self.lblWalletAccountTitle.text = walletAccount
        }
       
        
    }
    
    // MARK: - MethodDropDown Reasons
    
    private func methodDropDownReasons(Reasons:[String]) {
        
        //        if self.isFromHome == true {
        //            self.dropDownReasons.placeholder = "Select Reasons"
        //        }
        //        else if self.isFromDonations == true {
        //            self.dropDownReasons.placeholder = Reasons[0]
        //        }
        //        else if self.isFromQuickPay == true{
        //            self.dropDownReasons.placeholder = "Select Reasons"
        //        }
        //        else{
        //            self.dropDownReasons.placeholder = Reasons[0]
        //        }
        
        if self.isFromDonations == true {
            self.dropDownReasons.isUserInteractionEnabled = false
            self.beneAccountNumberTextField.isUserInteractionEnabled = false
            btncontactlist.isHidden = true
            self.dropDownReasons.placeholder = Reasons[0]
        }
        else{
            self.dropDownReasons.placeholder = "Select Reasons"
            self.dropDownReasons.isUserInteractionEnabled = true
        }
      
        self.dropDownReasons.tableHeight = 150.0
        self.dropDownReasons.rowBackgroundColor = #colorLiteral(red: 0.4700977206, green: 0.5852692723, blue: 0.7767686844, alpha: 1)
        self.dropDownReasons.textColor = #colorLiteral(red: 0.1286819577, green: 0.3171259165, blue: 0.6042343378, alpha: 1)
        self.dropDownReasons.optionsTextColor =  #colorLiteral(red: 0.1286819577, green: 0.3171259165, blue: 0.6042343378, alpha: 1)
        self.dropDownReasons.options = Reasons
        self.dropDownReasons.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            
            self.sourceReasonTitleForTrans = option
            
            //            let transPurpose = option
            //            for aCode in self.reasonsList {
            //                if aCode.descr == transPurpose {
            //                    self.sourceReasonCodeForTrans = aCode.code
            //                }
            //            }
        })
    }
    
    
    // MARK: - UITextfield Delegate Methods
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let newLength = (textField.text?.count)! + string.count - range.length
//
//        if textField == beneAccountNumberTextField{
//            return newLength <= 11
//        }
//        else {
//            return newLength <= 16
//        }
//    }
    
    // MARK: - Action Method
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func invitefriend(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "InviteFriendVC") as! InviteFriendVC
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func golootlo(_ sender: UIButton) {
        UtilManager.showAlertMessage(message: "Coming Soon", viewController: self)
//        let vc = UIStoryboard(name: "Messages", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesChat") as! MessagesChat
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactus(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func tickets(_ sender: UIButton) {
        
       let  vc = self.storyboard!.instantiateViewController(withIdentifier: "BookMeVC") as! BookMeVC
       self.navigationController!.pushViewController(vc, animated: true)
    }
    func captureScreen() {
            
            var image :UIImage?
            let currentLayer = UIApplication.shared.keyWindow!.layer
            let currentScale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale);
            guard let currentContext = UIGraphicsGetCurrentContext() else {return}
            currentLayer.render(in: currentContext)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let img = image else { return }
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false // if you dont want the close button use false
            )
            let alertView = SCLAlertView(appearance: appearance)
            let button = alertView.addButton("Ok") {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                              
                self.present(vc,animated:  true)
            }
                                   
            button.backgroundColor = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1.0)
                                   
            alertView.showCustom("", subTitle: ("Saved to Gallery"), color: UIColor(red: 0.8, green: 0, blue: 0, alpha: 1), icon: #imageLiteral(resourceName: "tick80px"))
           // UtilManager.showAlertMessage(message: "Saved to Gallery", viewController: self)
           
            
            
        }
   
    @IBAction func submitPressed(_ sender: Any) {
        
        let transPurpose = self.sourceReasonTitleForTrans
        for aCode in self.reasonsList {
            if aCode.descr == transPurpose {
                self.sourceReasonCodeForTrans = aCode.code
            }
        }
        
        if (beneAccountNumberTextField.text?.count)! < 11 {
            self.showToast(title:"Please enter valid account number")
            return
        }
        if ammountTextField.text?.count == 0 {
            self.showToast(title: "Please enter amount")
            return
        }
                if Double(ammountTextField.text!)! < 1 || Double(ammountTextField.text!)! > 500000 {
                    self.showToast(title: "Invalid Amount")
                    return
                }
        
        if self.sourceReasonCodeForTrans == nil || (self.sourceReasonCodeForTrans!.isEmpty){
            self.showToast(title: "Please select reason")
            return
        }
        
        self.initiateFundTrasnfer()
    }
    
    @IBAction func getContactsPressed(_ sender: Any) {
           contactPicker.delegate = self
           self.present(contactPicker, animated: true, completion: nil)
    }
    
    

    // MARK: - Utility Method
    
    private func navigateToConfirmation(){
        
        let fundTransConfirmVC = self.storyboard!.instantiateViewController(withIdentifier: "FundsTransferConfirmationVC") as! FundsTransferConfirmationVC
        fundTransConfirmVC.sourceAccount = DataManager.instance.accountNo
        fundTransConfirmVC.beneficaryAccount = self.beneAccountNumberTextField.text
        fundTransConfirmVC.accountTitle = self.transactionApiResponseObj?.data?.accountTitle?.trimmingCharacters(in: .whitespacesAndNewlines)
        fundTransConfirmVC.transferAmount = self.ammountTextField.text
        fundTransConfirmVC.transPurposeCode = self.sourceReasonCodeForTrans
        fundTransConfirmVC.otpReq = self.transactionApiResponseObj?.data?.oTPREQ
        if isFromDonations == true{
            fundTransConfirmVC.mainTitle = "Donations".addLocalizableString(languageCode: languageCode)
        }
       
   
//        if( self.transactionApiResponseObj?.data?.lastTransactions) != nil
//        {
//            fundTransConfirmVC.lsttrsc = transactionApiResponseObj?.data?.lastTransactions
//        }
//
// 
        self.navigationController!.pushViewController(fundTransConfirmVC, animated: true)
    }
    
    // MARK: - APi Call
    
    
    private func getReasonsForTrans() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        
        showActivityIndicator()
        
        let compelteUrl = GlobalConstants.BASE_URL + "getAllTransPurPose"
        let header = ["Accept":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(header)
        print(compelteUrl)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, headers:header).responseObject { (response: DataResponse<GetReasonsModel>) in
            self.hideActivityIndicator()
            
            if response.response?.statusCode == 200 {
                
                self.reasonsObj = response.result.value
                if self.reasonsObj?.responsecode == 2 || self.reasonsObj?.responsecode == 1 {
                    
                    if self.isFromDonations == true{
                        self.methodDropDownReasons(Reasons:[self.sourceReasonTitleForTrans!])
                    }
                    else{
                        self.arrReasonsList = self.reasonsObj?.stringReasons
                        self.methodDropDownReasons(Reasons: self.arrReasonsList!)
                    }
                    
                    if let reasonCodes = self.reasonsObj?.reasonsData{
                        self.reasonsList = reasonCodes
                    }
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
    
    private func initiateFundTrasnfer() {
        
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
        
        
        if (ammountTextField.text?.isEmpty)!{
            ammountTextField.text = ""
        }
        if (beneAccountNumberTextField.text?.isEmpty)!{
            beneAccountNumberTextField.text = ""
        }
        
//        let compelteUrl = GlobalConstants.BASE_URL + "initiateLocalFT"
//5
        let compelteUrl = GlobalConstants.BASE_URL + "v2/initiateLocalFT"
             
        let parameters = ["lat":"\(DataManager.instance.Latitude)","lng":"\(DataManager.instance.Longitude)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"accountNo":self.beneAccountNumberTextField.text!,"amount":self.ammountTextField.text!,"transPurpose":self.sourceReasonCodeForTrans!,"accountType": DataManager.instance.accountType!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
//        let header = ["Content-Type":"application/json","Authorization":DataManager.instance.clientSecretReg]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(parameters)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FTApiResponse>) in
            
            //         Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FundInitiateModel>) in
            self.hideActivityIndicator()
            
            self.transactionApiResponseObj = response.result.value
            if response.response?.statusCode == 200 {
                
                                if self.transactionApiResponseObj?.responsecode == 2 || self.transactionApiResponseObj?.responsecode == 1 {
                    self.navigateToConfirmation()
                }
                else {
                    if let message = self.transactionApiResponseObj?.messages{
                        self.showDefaultAlert(title: "", message: "\(message) \(self.transactionApiResponseObj?.messages ?? "")")
                    }
                }
            }
            else {
                if let message = self.transactionApiResponseObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if textField == beneAccountNumberTextField
        { beneAccountNumberTextField.isUserInteractionEnabled = true
            return newLength <= 16
       
    }
        return newLength <= 16
    }
    
    func Changelanguagex()
    {
        
        
        if let title = self.mainTitle{
            if title == "Wallet to Conventional".addLocalizableString(languageCode: languageCode)
            {
              
                lblMainTitle.text = "Wallet to Conventional".addLocalizableString(languageCode: languageCode)
                beneAccountNumberTextField.placeholder = "Enter 16 digit account no".addLocalizableString(languageCode: languageCode)
                
            }
            else
            {
                lblMainTitle.text = "Local Funds Transfer".addLocalizableString(languageCode: languageCode)
                beneAccountNumberTextField.placeholder = "Enter 11 Digit Mobile No".addLocalizableString(languageCode: languageCode)
            }
            
        }
   
      
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInviteFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        lblLocalFundsTransfer.text = "Local Funds Transfer".addLocalizableString(languageCode: languageCode)
        lblSourceAccount.text = "Source Account".addLocalizableString(languageCode: languageCode)
        lblBeneficiaryWALLETACCOUNT.text = "Beneficairy Wallet/ Accounts".addLocalizableString(languageCode: languageCode)
        lblTransferAmount.text = "Transfer Amount".addLocalizableString(languageCode: languageCode)
        LblPurposePayment.text = "Purpose of Payment".addLocalizableString(languageCode: languageCode)
        btnSubmitt.setTitle("SUBMIT".addLocalizableString(languageCode: languageCode), for: .normal)
        btnCancel.setTitle("CANCEL".addLocalizableString(languageCode: languageCode), for: .normal)
    }
}

extension LocalFundTransferVC: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let phoneNumberCount = contact.phoneNumbers.count

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
            self.beneAccountNumberTextField.text = replaceSpaceWithEmptyString(aStr: formattedString)
          }
          catch let error as NSError {
              print(error.localizedDescription)
          }
    }

    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
}
