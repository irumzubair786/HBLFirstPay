//
//  DebitCardBranchAddressConfirmationVC.swift
//  First Pay
//
//  Created by Irum Butt on 10/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
class DebitCardBranchAddressConfirmationVC: BaseClassVC {
    var fullUserName : String?
    var address : String?
    var cardFee : Float?
    var totalFee: Float?
    var genericObj:GenericResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("get name", DataManager.instance.accountNo)
        buttonBack.setTitle("", for: .normal)
        blurview.alpha = 0.7
        blurview.isHidden = true
        imagePopup.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveToNext(tapGestureRecognizer:)))
        imagePopup.isUserInteractionEnabled = true
        imagePopup.addGestureRecognizer(tapGesture)
        self.updateui()
        
    }
    
    
    @IBOutlet weak var labelTotalFee: UILabel!
    @IBOutlet weak var labelCardFee: UILabel!
    @IBOutlet weak var labelMobileNumber: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageNextArrow: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var labelBranchAddress: UILabel!
    @IBOutlet weak var imagePopup: UIImageView!
    @IBOutlet weak var blurview: UIView!
    @IBAction func buttonContinue(_ sender: UIButton) {
        FBEvents.logEvent(title: .Debit_orderconfirm_attempt)

        debitCardRequest()
       
    }
    
    @IBAction func buttonback(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func moveToNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
        
    }
    func updateui()
    {
        labelName.text = GlobalData.debitCardUserFullName
        labelBranchAddress.text = GlobalData.selectedBranch
        labelAddress.text = homeAddrss
        labelCardFee.text = "\(debitCardFee!)"
        labelTotalFee.text = "\(debitCardFeeDeliveryCharges!)"
        labelMobileNumber.text = DataManager.instance.accountNo
        
        
    }
    // MARK: - Api Call
   private func debitCardRequest() {

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
       let compelteUrl = GlobalConstants.BASE_URL + "DebitCard/v1/getResponseOfDebitCardCreation"
       userCnic = UserDefaults.standard.string(forKey: "userCnic")
       let parameters = ["imei":"\(DataManager.instance.imei!)","cnic":userCnic!,"otp":"","channelId":"\(DataManager.instance.channelID )","NameonCard": GlobalData.debitCardUserName! ,"deliveryType": "S","deliveryAddress":GlobalData.selectedBranch , "branchCode":GlobalData.selectedBranchCode ?? ""]
       let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
       print(parameters)
      
       
       let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
       
       let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
       
       print(params)
       print(compelteUrl)
       
       NetworkManager.sharedInstance.enableCertificatePinning()
       
       NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
//           (response: DataResponse<GenericResponse>) in
           response in
           self.hideActivityIndicator()
           guard let data = response.data else { return }
           if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
               self.genericObj = Mapper<GenericResponse>().map(JSONObject: json)
               
               //           self.genericObj = response.result.value
               if response.response?.statusCode == 200 {
                   FBEvents.logEvent(title: .Debit_orderconfirm_success)
                   FaceBookEvents.logEvent(title: .Debit_orderconfirm_success)
                   
                   if self.genericObj?.responsecode == 2 || self.genericObj?.responsecode == 1 {
                       self.blurview.isHidden = false
                       self.imagePopup.isHidden = false
                       
                   }
                   else {
                       if let message = self.genericObj?.messages{
                           self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                       }
                   }
               }
               else {
                   FBEvents.logEvent(title: .Debit_orderconfirm_failure)
                   
                   if let message = self.genericObj?.messages{
                       self.showAlertCustomPopup(title: "", message: message, iconName: .iconError)
                   }
                   //
               }
           }
       }
   }

}
