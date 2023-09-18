//
//  TransferAmountConfirmationVc.swift
//  First Pay
//
//  Created by Irum Butt on 04/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftKeychainWrapper
import ObjectMapper

class TransferAmountConfirmationVc: BaseClassVC {
    
    @IBOutlet weak var imageViewGray: UIImageView!
    var successmodelobj : FundsTransferApiResponse?
    var amount :String?
    var phoneNumber  : String?
    
    @IBOutlet weak var viewBackgroundButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackgroundButton.circle()
        back.setTitle("", for: .normal)
        nextBtn.setTitle("", for: .normal)
        updateUi()
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissViewController), name: Notification.Name("dismissViewController"), object: nil)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true)
    }
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblRecipientPhoneNumber: UILabel!
    @IBOutlet weak var lblOperator: UILabel!
    @IBOutlet weak var lblTransactionType: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblTransationId: UILabel!
    @IBOutlet weak var lblSendTo: UILabel!
    @IBOutlet weak var lblSendBy: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    func updateUi(){
        lblAmount.text = "Rs. \(amount!)"
        lblTotalAmount.text = "Rs. \(amount!)"
        lblFee.text = "Rs. 0.00"
        lblRecipientPhoneNumber.text = phoneNumber
        lblOperator.text = GlobalData.Selected_operator
        lblTransactionType.text = GlobalData.topup
    }
    
    
    
    
    @IBOutlet weak var back: UIButton!
    @IBAction func Action_back(_ sender: UIButton) {
        dismissViewController()
    }
    
    
    @IBAction func Continue(_ sender: UIButton) {
        payTopUp()
        //
        
        
        
    }
    
    
    @IBAction func ActionFavourite(_ sender: UIButton) {
    }
    
    
    
    @IBAction func ActionDownloadShare(_ sender: UIButton) {
        
        
        
    }
    
    
    private func payTopUp() {
//        shakeel test
//        navigateToSuccessVC()
//        return
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
        //        v2
        let compelteUrl = GlobalConstants.BASE_URL + "\(transactionV1or2)/billPayment"
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["lat":"\(DataManager.instance.Latitude!)","lng":"\(DataManager.instance.Longitude!)","cnic":userCnic!,"imei":DataManager.instance.imei!,"channelId":"\(DataManager.instance.channelID)","utilityBillCompany":GlobalData.Select_operator_code,"beneficiaryAccountTitle":"","utilityConsumerNo":phoneNumber!,"accountType" : DataManager.instance.accountType!,"amountPaid":self.amount!.getIntegerValue(),"beneficiaryName":"","beneficiaryMobile":"","beneficiaryEmail":"","otp":"","addBeneficiary":"","utilityBillCompanyId":GlobalData.Select_operator_id ?? ""] as [String : Any]
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header: HTTPHeaders = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        print(params)
        print(compelteUrl)
        print(header)
        print(parameters)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).response {
            //            (response: DataResponse<FundsTransferApiResponse>) in
            response in
            self.hideActivityIndicator()
            guard let data = response.data else { return }
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                self.successmodelobj = Mapper<FundsTransferApiResponse>().map(JSONObject: json)
                
                //             self.successmodelobj = response.result.value
                if response.response?.statusCode == 200 {
                    if self.successmodelobj?.responsecode == 2 || self.successmodelobj?.responsecode == 1 {
                        self.navigateToSuccessVC()
                        //                    self.tablleview?.reloadData()
                    }
                    else {
                        if let message = self.successmodelobj?.messages{
                            self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                            self.navigateToSuccessVC()
                        }
                    }
                }
                else {
                    if let message = self.successmodelobj?.messages{
                        self.showAlertCustomPopup(title: "",message: message, iconName: .iconError)
                    }
                    //                print(response.result.value)
                    //                print(response.response?.statusCode)
                }
            }
        }
    }
    //    --------------
    
    
    private func navigateToSuccessVC(){
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "TransferAmountSuccessfulVC") as! TransferAmountSuccessfulVC
        vc.phoneNumber = phoneNumber
        vc.amount = amount!
        vc.Trascationid = successmodelobj?.data?.authIdResponse
        vc.TransactionDate = successmodelobj?.data?.transDate
        self.present(vc, animated: true)
        //        self.navigationController?.pushViewController(vc, animated: true)
        //
        
    }
    
    
}
