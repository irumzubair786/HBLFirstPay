//
//  Pay_BillPayment_VC.swift
//  First Pay
//
//  Created by Irum Butt on 30/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import ContactsUI
import libPhoneNumber_iOS
class Pay_BillPayment_VC: BaseClassVC, UITextFieldDelegate {
    var BillComapnyid : Int?
    var billtransactionOBj : BillAPiResponse?
    var utilityBillCompany:String?
    var otpReq : String?
    override func viewDidLoad() {
        FBEvents.logEvent(title: .PayBills_successrecept_landing)
        FaceBookEvents.logEvent(title: .PayBills_successrecept_landing)
        super.viewDidLoad()
        blurView.isHidden = true
        back.setTitle("", for: .normal)
//        btn_Continue.setTitle("", for: .normal)
        lblMainTitle.text = GlobalData.SelectedCompanyname ?? ""
        lbl_SubTitle.text = GlobalData.SelectedCompanyname ?? ""
        
        lblTitle.text = "Refference / Consumer Number"
        btn_Continue.isUserInteractionEnabled = false
        btn_img_next.setTitle("", for: .normal)
        enterconsumerNo.delegate = self
        img_Button.setTitle("", for: .normal)
        blurView.isHidden = true
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(PopUpHide(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizerr)
        self.enterconsumerNo.addTarget(self, action: #selector(changeTextInTextField), for: .editingChanged)
//
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbl_SubTitle: UILabel!
    @IBOutlet weak var enterconsumerNo: UITextField!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var img_Button: UIButton!
    @IBOutlet weak var lblViewImg: UILabel!
    @IBOutlet weak var img_next: UIImageView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var btn_Continue: UIButton!
    @IBOutlet weak var btn_img_next: UIButton!
    @IBAction func Continue(_ sender: UIButton) {
  print ("bill text", utilityBillCompany)
        getBillInquiry(utilityBillCompany: utilityBillCompany!)
        
    }
    
    @IBAction func action_billImage(_ sender: UIButton) {
        blurView.isHidden = false
        popupView.isHidden = false
        
    }
    @objc func PopUpHide(tapGestureRecognizer: UITapGestureRecognizer)
    {
        popupView.isHidden = true
        blurView.isHidden = true
    }
    
    @IBAction func Action_back(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Billpayment_MainVC") as! Billpayment_MainVC
       self.navigationController!.pushViewController(vc, animated: true)
        
//        self.navigationController?.popViewController(animated: true)
    }
    
    private func getBillInquiry(utilityBillCompany:String?) {
        
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
        
  //      let compelteUrl = GlobalConstants.BASE_URL + "billInquiry"
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v2/billInquiry"
        
//        v2
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"utilityBillCompany":utilityBillCompany!,"utilityConsumerNo":self.enterconsumerNo.text!,"accountType": DataManager.instance.accountType!]
        
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
//        print(result.apiAttribute1)
//        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
         let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
        
        NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//            (response: DataResponse<BillAPiResponse>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            self.billtransactionOBj = Mapper<BillAPiResponse>().map(JSONObject: json)
            
//            self.billtransactionOBj = response.result.value
            if response.response?.statusCode == 200 {
                if self.billtransactionOBj?.responsecode == 2 || self.billtransactionOBj?.responsecode == 1 {
                    self.navigateToDetailsVC(code: utilityBillCompany!)
                }
                else {
                    if let message = self.billtransactionOBj?.messages{
                        self.showAlertCustomPopup(title: "",message: message,iconName: .iconError)
//                        self.showAlert(title: "", message: message, completion: nil)
                    }
                }
            }
            else {
                if let message = self.billtransactionOBj?.messages{
                    self.showAlertCustomPopup(title: "",message: message,iconName: .iconError)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    }
    
    //    after
        private func navigateToDetailsVC(code:String){
            
            if let imdComp = self.billtransactionOBj?.data?.utilityCompanyId{
 
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "BillPayment_ConfirmationVC") as! BillPayment_ConfirmationVC
                vc.refferenceNumber = self.billtransactionOBj?.data?.transactionLogId
                vc.company = GlobalData.Selected_bil_Company
                vc.billingMonth = self.billtransactionOBj?.data?.billingMonth
                vc.amountDue = self.billtransactionOBj?.data?.actualDueAmount
                vc.dueDate = self.billtransactionOBj?.data?.paymentDueDate
                let statusCheck = self.billtransactionOBj?.data?.billStatus
                vc.otpReq = self.billtransactionOBj?.data?.oTPREQ
                print("otp req value",vc.otpReq)
                if statusCheck == "P"
                {
                    vc.status = "Paid"
                }
                else
                {
                    vc.status = "Unpaid"
                }
                
                vc.consumerNumber = enterconsumerNo.text!
               
                self.navigationController!.pushViewController(vc, animated: true)
                
            }
//        }
            
        }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = (textField.text?.count)! + string.count - range.length
        
        if  GlobalData.Selected_Company_code == "MBP"{
            
            if textField == enterconsumerNo{
                return newLength <= 11
            }
        }
        else if  GlobalData.Selected_Company_code == "IESCO"{
            if textField == enterconsumerNo
            {
                return newLength <= 11
            }
            return newLength <= 18
        }
        return newLength <= 18
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if enterconsumerNo.text?.count != 0
        {
            let image = UIImage(named: "]greenarrow")
            img_next.image = image
            btn_Continue.isUserInteractionEnabled = true
        }
        else
        {
            let image = UIImage(named: "grayArrow")
            img_next.image = image
            btn_Continue.isUserInteractionEnabled = false
        }
    }
    @objc func changeTextInTextField() {
        if enterconsumerNo.text?.count == 11 || enterconsumerNo.text?.count == 18
        {
            let image = UIImage(named: "]greenarrow")
            img_next.image = image
            btn_Continue.isUserInteractionEnabled = true
        }
        else
        {
            let image = UIImage(named: "grayArrow")
            img_next.image = image
            btn_Continue.isUserInteractionEnabled = false
        }
    }
    
    
}
extension Pay_BillPayment_VC
{
    func AnimIn(Popview:UIView)
    {
       
       
        view.addSubview(Popview)
        
        Popview.center = self.view.center
        Popview.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
        Popview.alpha=0
        //  blurView.alpha = 0
        UIView.animate(withDuration: 0.6)
        {
            //   self.blurView.alpha = 1
            Popview.alpha = 1
            Popview.transform = CGAffineTransform.identity
        }
    }
    
    func Animout(Popview:UIView)
    {
       
        
        Popview.alpha = 1
        //   blurView.alpha = 1
        UIView.animate(withDuration: 0.6)
        {
            //   self.blurView.alpha = 0
            Popview.alpha=0
            Popview.transform = CGAffineTransform.identity
        }
        
    }
    
}
