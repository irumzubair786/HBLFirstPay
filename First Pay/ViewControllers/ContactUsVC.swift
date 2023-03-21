//
//  ContactUsVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 07/05/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import AlamofireObjectMapper

class ContactUsVC: BaseClassVC , MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet var dropDownInquiries: UIDropDown!
    @IBOutlet  var nameTextField: UITextField!
   
    @IBOutlet weak var lblhome: UILabel!
    @IBOutlet weak var lblContactus: UILabel!
    @IBOutlet weak var lblBookme: UILabel!

    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet weak var btnsend: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblHelpline: UILabel!
    @IBOutlet weak var lblOfficeAddress: UILabel!
    
    
    @IBOutlet weak var lblInvitesFriend: UILabel!
    @IBOutlet weak var messageTextView: UITextField!
    var selectedCategory:String?
    var genericObj:GenericResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        ConvertLanguage()
//        self.methodDropDownInquiries()
        messageTextView.delegate = self
        self.messageTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.messageTextView.layer.borderWidth = 1
        lblhome.text = "Home".addLocalizableString(languageCode: languageCode)
        lblInvitesFriend.text = "Invite Friends".addLocalizableString(languageCode: languageCode)
        lblBookme.text = "Tickets".addLocalizableString(languageCode: languageCode)
        lblContactus.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        messageTextView.text = "Enter Text Here..".addLocalizableString(languageCode: languageCode)
        self.methodDropDownInquiries()
        
    }
    
    //MARK: - Send a message
    func ConvertLanguage()
    {
        lblContactUs.text = "Contact Us".addLocalizableString(languageCode: languageCode)
        nameTextField.placeholder = "Name".addLocalizableString(languageCode: languageCode)
//        messageTextView.placeholder = "Enter Text Here..".addLocalizableString(languageCode: languageCode)
        dropDownInquiries.placeholder = "Select Category".addLocalizableString(languageCode: languageCode)
        btnsend.setTitle("SEND".addLocalizableString(languageCode: languageCode), for: .normal)
        lblHelpline.text = "HELPLINE".addLocalizableString(languageCode: languageCode)
        lblAddress.text = "ADDRESS".addLocalizableString(languageCode: languageCode)
        lblOfficeAddress.text  = "HBL MICROFINANCE BANK(The First MicroFinance Bank Pakistan) Digital Headquarters, 3rd Floor, Fortune Plaza, Blue Area Islamabad - Pakistan.".addLocalizableString(languageCode: languageCode)
        
        
    }
    
    
    
    
    
    
    func sendMessage() {
        
        let messageVC = MFMessageComposeViewController()
        if let category = self.selectedCategory {
            messageVC.body = "\(String(describing: self.nameTextField.text!)) \n\(category) \n\n\(messageTextView.text!)"
        }
        messageVC.recipients = ["6969"]
        messageVC.messageComposeDelegate = self
        present(messageVC, animated: true, completion: nil)
    }
    
    // MARK: - Message Delegate method
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue :
            self.showToast(title: "Message canceled")
            print("message canceled")
        case MessageComposeResult.failed.rawValue :
            self.showToast(title: "Message failed")
            print("message failed")
        case MessageComposeResult.sent.rawValue :
            self.showToast(title: "Message sent")
            print("message sent")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.rangeOfCharacter(from: .letters) != nil || string == " " {
            return true
        }
        else if !(string == "" && range.length > 0) {
        return false
        
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text.rangeOfCharacter(from: .letters) != nil || text == " " {
                   return true
               }
               else if !(text == "" && range.length > 0) {
               return false
               }
        if text == "\n"
        {
            messageTextView.resignFirstResponder()
        }
  
        
               return true
        
    }
func textViewDidBeginEditing(_ textView: UITextView) {
 
        messageTextView.text = ""
        
   }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if messageTextView.text != ""
//        {
//            messageTextView.text = ""
//        }
//       
//        messageTextView.resignFirstResponder()
//    }
    
    //MARK: - DropDown
    
    private func methodDropDownInquiries() {
           
        self.dropDownInquiries.placeholder = "Select Category".addLocalizableString(languageCode: languageCode)
      
            self.dropDownInquiries.options = ["Inquiry","Complaint","Suggestion","Feedback"]
            self.dropDownInquiries.rowBackgroundColor = #colorLiteral(red: 0.4700977206, green: 0.5852692723, blue: 0.7767686844, alpha: 1)
            self.dropDownInquiries.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.dropDownInquiries.optionsTextColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.dropDownInquiries.didSelect(completion: {
                (option , index) in
                print("You Just select: \(option) at index: \(index)")
                self.selectedCategory = option
                
                
            })
    
    }
    @IBOutlet weak var imgarrow: UIImageView!
    
    //MARK: - Action Methods
    
    @IBAction func actionUANPressed(_ sender: Any) {
//        UIApplication.shared.openURL(NSURL(string: "tel:080034778")! as URL)
        UIApplication.shared.open(URL(string: "tel:080042563")!)
    }
    
    @IBAction func action_fmfb(_ sender: Any) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier:"WebViewVC") as! WebViewVC
        webVC.fileURL = "www.hblmfb.com"
        self.navigationController?.pushViewController(webVC, animated: true)
        
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
    @IBAction func sendButtonPressed(_ sender: Any) {
        //     print("\(String(describing: self.nameTextField.text!)) \n\(self.selectedCategory!) \n\n\(messageTextView.text!)")
        //        if (MFMessageComposeViewController.canSendText()) {
        //            print("SMS services are not available")
        //            self.sendMessage()
        //        }
        if (self.nameTextField.text?.isEmpty)!{
            self.showDefaultAlert(title: "", message: "Please Enter Name")
            return
        }
        if self.messageTextView.text == ""{
            self.showDefaultAlert(title: "", message: "Please Enter Message")
            return
        }
        if self.selectedCategory == nil{
            self.showDefaultAlert(title: "", message: "Please Select Category")
            return
        }
        self.sendComplaint()
    }
    
   
    private func sendComplaint(){

        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }

        showActivityIndicator()

//        let compelteUrl = GlobalConstants.BASE_URL + "bbscontactUs"
//
        
        let compelteUrl = GlobalConstants.BASE_URL + "v2/bbscontactUs"
        let parameters = ["channelId":"\(DataManager.instance.channelID)","name":self.nameTextField.text!,"category":self.selectedCategory!,"message":self.messageTextView.text!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]

        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        print(params)
        print(compelteUrl)

        NetworkManager.sharedInstance.enableCertificatePinning()

        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in
            
//        Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponse>) in

            self.hideActivityIndicator()
            self.genericObj = response.result.value
            if response.response?.statusCode == 200 {
                if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                  
                    if let message = self.genericObj?.messages{
                        self.showDefaultAlert(title: "", message:message)
                    }
                }
                else {
                    if let message = self.genericObj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genericObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }

    }
    
}
