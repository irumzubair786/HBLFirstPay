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
    var fundsTransSuccessObj: TopUpApiResponse?
    var status: String?
    var minValue = 1
    var maxValue = 10000
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonContinue.isUserInteractionEnabled = false
        amounttextField.delegate = self
        buttonBack.setTitle("", for: .normal)
        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))

        imageNext.addGestureRecognizer(tapGestureRecognizerr)
        updateui()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var labelAlert: UILabel!
    @IBOutlet weak var amounttextField: UITextField!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var imglogo: UIImageView!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true
        )
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if amounttextField?.text ?? "" < "\(minValue)" ||  amounttextField?.text  ?? "" > "\(maxValue)"
        {
            let image = UIImage(named:"grayArrow")
            imageNext.image = image
            imageNext.isUserInteractionEnabled = false
            buttonContinue.isUserInteractionEnabled = false
            labelAlert.textColor = UIColor(hexValue: 0xFF3932)
            amounttextField.textColor = UIColor(hexValue: 0xFF3932)
            
        }
        else{
            let image = UIImage(named:"]greenarrow")
            imageNext.image = image
            imageNext.isUserInteractionEnabled = true
            labelAlert.textColor =  UIColor(red: 241/255, green: 147/255, blue: 0/255, alpha: 1)
            amounttextField.textColor = .gray
            
            buttonContinue.isUserInteractionEnabled = true
        }

    }
    @IBAction func amountTextField(_ sender: UITextField) {
       
            if amounttextField?.text ?? "" < "\(minValue)" ||  amounttextField?.text  ?? "" > "\(maxValue)"
            {
                let image = UIImage(named:"grayArrow")
                imageNext.image = image
                imageNext.isUserInteractionEnabled = false
                buttonContinue.isUserInteractionEnabled = false
                
                labelAlert.textColor = UIColor(hexValue: 0xFF3932)
                amounttextField.textColor = UIColor(hexValue: 0xFF3932)

            }
            else{
                let image = UIImage(named:"]greenarrow")
                imageNext.image = image
                imageNext.isUserInteractionEnabled = true
                labelAlert.textColor =  UIColor(red: 241/255, green: 147/255, blue: 0/255, alpha: 1)
                amounttextField.textColor = .gray
                buttonContinue.isUserInteractionEnabled = true
        
            }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength:Int = (textField.text?.count)! + string.count - range.length
 
        if textField == amounttextField{
            return newLength <= 5
            
//            lbl1.textColor = UIColor.green
        }
        if textField == amounttextField{
            return newLength <= 5
        }
        return newLength <= 5
        
    
}

    @IBOutlet weak var imageNext: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBAction func buttonContinue(_ sender: UIButton) {
        initiateTopUp()
    }
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        initiateTopUp()
//        self.present(vc, animated: true)
    }
    func updateui()
    {
        
        let url = URL(string:"\(GlobalConstants.BASE_URL)\(GlobalData.selected_operator_logo!)")
        imglogo.sd_setImage(with: url)
        labelMobileNumber.text = phoneNumber
        labelDate.text = DueDate
        let a = DueDate?.substring(to: 10)
        labelDate.text = a
        labelStatus.text = status
        labelAmount.text = amounttextField.text
    }
    
    
    private func initiateTopUp() {
        
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
        
        
//        let compelteUrl = GlobalConstants.BASE_URL + "topUp"
        let compelteUrl = GlobalConstants.BASE_URL + "Transactions/v1/topUp"
        
       
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude)","lng":"\(DataManager.instance.Longitude)","channelId":"\(DataManager.instance.channelID)","imei":DataManager.instance.imei!,"cnic":userCnic!,"utilityBillCompany":   GlobalData.Select_operator_code,"utilityConsumerNo":self.phoneNumber!, "accountType": DataManager.instance.accountType!]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        print(params)
        print(compelteUrl)
        print(header)
                NetworkManager.sharedInstance.enableCertificatePinning()
        
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<TopUpApiResponse>) in
            
            
            self.hideActivityIndicator()
            
            self.fundsTransSuccessObj = response.result.value
            if response.response?.statusCode == 200 {
                
                if self.fundsTransSuccessObj?.responsecode == 2 || self.fundsTransSuccessObj?.responsecode == 1 {
                    self.navigatezToConfirmationVC()
                }
                else {
                    if let message = self.fundsTransSuccessObj?.messages{
                        self.showDefaultAlert(title: "", message: "\(message) \(self.fundsTransSuccessObj?.messages ?? "") ")
                    }
                }
            }
            else {
                if let message = self.fundsTransSuccessObj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    func navigatezToConfirmationVC()
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TransferAmountConfirmationVc") as! TransferAmountConfirmationVc
        vc.amount =  amounttextField.text!
        vc.phoneNumber = phoneNumber
        
        self.navigationController!.pushViewController(vc, animated: false)
    }
}
