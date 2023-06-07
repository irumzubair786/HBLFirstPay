//
//  POSTPAIDCONFIRMATIONVC.swift
//  First Pay
//
//  Created by Irum Butt on 18/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class POSTPAIDCONFIRMATIONVC: BaseClassVC ,UITextFieldDelegate{
    var phoneNumber  : String?
    var DueDate : String?
    var successmodelobj : FundsTransferApiResponse?
    var status: String?
    var minValue = 1
    var maxValue = 10000
    var amount :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonContinue.isUserInteractionEnabled = true
        amounttextField.delegate = self
        buttonBack.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        
        imageNext.addGestureRecognizer(tapGestureRecognizerr)
        updateui()
        imageNext.isUserInteractionEnabled = true
        amounttextField.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
   
    @IBOutlet weak var otptextField: UITextField!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelAlert: UILabel!
    @IBOutlet weak var amounttextField: UITextField!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var imglogo: UIImageView!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true
        )
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if otptextField.text?.count != 4
        {
            let image = UIImage(named:"grayArrow")
            imageNext.image = image
            imageNext.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
        }
        else{
            let image = UIImage(named:"]greenarrow")
            imageNext.image = image
            imageNext.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true
        }
    }
    @IBAction func otptextfield(_ sender: UITextField) {
        if otptextField.text?.count != 4
        {
            let image = UIImage(named:"grayArrow")
            imageNext.image = image
            imageNext.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
        }
        else{
            let image = UIImage(named:"]greenarrow")
            imageNext.image = image
            imageNext.isUserInteractionEnabled = true
            buttonContinue.isUserInteractionEnabled = true
        }
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength:Int = (textField.text?.count)! + string.count - range.length
        
        if textField == otptextField{
            return newLength <= 4
            
            //            lbl1.textColor = UIColor.green
        }
        if textField == otptextField{
            return newLength <= 4
        }
        return newLength <= 4

    }
    
    @IBOutlet weak var imageNext: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBAction func buttonContinue(_ sender: UIButton) {
        if ((status == "U") || (status == "u") || ((status == "T") || (status == "t")))
        {
            billPyment()
        }
        
        
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if ((status == "U") || (status == "u"))
        {
            billPyment()
        }
        //        self.present(vc, animated: true)
    }
    func updateui()
    {
        if let templog = GlobalData.selected_operator_logo {
            let url = URL(string:"\(GlobalConstants.BASE_URL)\(GlobalData.selected_operator_logo!)")
            imglogo.sd_setImage(with: url)
            labelMobileNumber.text = phoneNumber
            labelDate.text = DueDate
            //        let a = DueDate?.substring(to: 11)
            //        labelDate.text = a
            
            if status == "t" || status == "T" {
                labelStatus.text = "Partial Payment"
            }
            else if status == "b" || status == "B"
            {
                labelStatus.text = "Your Customer is Blocked.Please contact your service provider."
            }
            else
            {
                labelStatus.text = status
            }
            labelAmount.text = amounttextField.text
            amounttextField.text = amount
            labelAmount.text = amount
        }
        
    }
    
    private func billPyment() {
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
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/billPayment"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","utilityBillCompany": GlobalData.Select_operator_code,"beneficiaryAccountTitle":"","utilityConsumerNo":phoneNumber!,"accountType" : DataManager.instance.accountType!,"amountPaid":amount!,"beneficiaryName":"","beneficiaryMobile":"","beneficiaryEmail":"","otp":otptextField.text!,"addBeneficiary":"","utilityBillCompanyId": GlobalData.Select_operator_id!] as [String : Any]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(parameters)
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        print(params)
        print(compelteUrl)
        print(header)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<FundsTransferApiResponse>) in
            self.hideActivityIndicator()
             self.successmodelobj = response.result.value
            if response.response?.statusCode == 200 {
                if self.successmodelobj?.responsecode == 2 || self.successmodelobj?.responsecode == 1 {
                    self.navigatezToConfirmationVC()
//                    self.tablleview?.reloadData()
                }
                else {
                    if let message = self.successmodelobj?.messages{
                        self.showAlertCustomPopup(title: "",message: message,iconName: .iconError)
//                        self.navigateToSuccessVC()
                    }
                }
            }
            else {
                if let message = self.successmodelobj?.messages{
                        self.showAlertCustomPopup(title: "",message: message,iconName: .iconError)
//                        self.navigateToSuccessVC()
                    }

                }
//                print(response.result.value)
//                print(response.response?.statusCode)
            }
        }
    
   
    func navigatezToConfirmationVC()
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TransferAmountConfirmationVc") as! TransferAmountConfirmationVc
        vc.amount = amount
        vc.phoneNumber = phoneNumber
    
        self.navigationController!.pushViewController(vc, animated: false)
    }
}
