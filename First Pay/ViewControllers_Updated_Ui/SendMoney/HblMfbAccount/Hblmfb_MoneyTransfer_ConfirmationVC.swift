//
//  Hblmfb_MoneyTransfer_ConfirmationVC.swift
//  First Pay
//
//  Created by Irum Butt on 10/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
class Hblmfb_MoneyTransfer_ConfirmationVC: BaseClassVC, UITextFieldDelegate {
    var amount: Double?
    var sourceReasonTitleForTrans : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.isEnabled = false
        back.setTitle("", for: .normal)
        updateUI()
        lblAlertAmount.isHidden = true
//        getReasonsForTrans()
//        btnnext.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    var arrReasonsList : [String]?
    var reasonsObj : GetReasonsModel?
    var reasonsList = [ReasonsData]()
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblAccName: UILabel!
    @IBOutlet weak var lblAlertAmount: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var lblMobno: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var btnnext: UIButton!
    @IBOutlet weak var btn_next_arrow: UIButton!
    @IBOutlet weak var dropDownReasons: UIDropDown!
    @IBAction func Action_back(_ sender: UIButton) {
        self.dismiss(animated: true)
        

    }
    
    
    func  updateUI()
    {
        amountTextField.text = "\(amount!)"
        
    }
    
    private func methodDropDownReasons(Reasons:[String]) {
       
            self.dropDownReasons.placeholder = Reasons[0]
            self.dropDownReasons.isUserInteractionEnabled = true
        
      
        self.dropDownReasons.tableHeight = 150.0
        self.dropDownReasons.rowBackgroundColor = #colorLiteral(red: 0.4700977206, green: 0.5852692723, blue: 0.7767686844, alpha: 1)
        self.dropDownReasons.textColor = #colorLiteral(red: 0.1286819577, green: 0.3171259165, blue: 0.6042343378, alpha: 1)
        self.dropDownReasons.optionsTextColor =  #colorLiteral(red: 0.1286819577, green: 0.3171259165, blue: 0.6042343378, alpha: 1)
        self.dropDownReasons.options = Reasons
        self.dropDownReasons.didSelect(completion: {
            (option , index) in
            print("You Just select: \(option) at index: \(index)")
            
            self.sourceReasonTitleForTrans = option
            let image = UIImage(named:"]greenarrow")
            self.btn_next_arrow.setImage(image, for: .normal)
            self.btnnext.isUserInteractionEnabled = true
            
            
            
            
            //            let transPurpose = option
            //            for aCode in self.reasonsList {
            //                if aCode.descr == transPurpose {
            //                    self.sourceReasonCodeForTrans = aCode.code
            //                }
            //            }
        })
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
//                    if reasonsObj?.reasonsData != nil{
                        self.methodDropDownReasons(Reasons:[self.sourceReasonTitleForTrans!])
                        self.arrReasonsList = self.reasonsObj?.stringReasons
                        self.methodDropDownReasons(Reasons: self.arrReasonsList!)
                    if let reasonCodes = self.reasonsObj?.reasonsData{
                        self.reasonsList = reasonCodes
                    }
                    
                    
                }
                else {
                   
                }
            }
            else {
                
                print(response.result.value)
                print(response.response?.statusCode)
            }
        }
    }
    
    
    
    
    
    
    @IBAction func Action_Next(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Hblmfb_MoneyTransfer_SuccessfullVC") as! Hblmfb_MoneyTransfer_SuccessfullVC
           self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    


}
