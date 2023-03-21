//
//  SelectLimitMangamnetLovVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 23/12/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class SelectLimitMangamnetLovVC: BaseClassVC {
    var selectedlist : String?
    var descrptionlist = [String]()
    var ATMIdget = ""
    var MBidget = ""
    var genericOBj : LimitChangeModel?
    @IBOutlet weak var lblSelectAccountLimit: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    
    
    @IBOutlet weak var dropdownLimit: DropDown!
    @IBOutlet weak var btnChangeLimit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        methodDropDownOptions()
        print("ATMIdget" ,ATMIdget)
        lblMain.text = "LimitManagement".addLocalizableString(languageCode: languageCode)
        btnChangeLimit.setTitle("Change Limit".addLocalizableString(languageCode: languageCode), for: .normal)
        lblSelectAccountLimit.text = "Select Account Limit".addLocalizableString(languageCode: languageCode)
        // Do any additional setup after loading the view.
    }
//

    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        self.popUpLogout()
        
    }
    
    
    @IBAction func changeLimit(_ sender: UIButton) {
        if dropdownLimit.text?.count == 0{
            showToast(title: "Please Select Account Limit")
        }
        else
        {
           
            sendOtpCardChannelLimits()

            
        }
    }
    
    
    private func methodDropDownOptions() {
        
        self.dropdownLimit.rowHeight = 30.0
        self.dropdownLimit.selectedRowColor = UIColor.gray
        self.dropdownLimit.isSearchEnable = true
        self.dropdownLimit.placeholder = "Select Account Limit".addLocalizableString(languageCode: languageCode)
        self.dropdownLimit.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        self.dropdownLimit.optionArray = ["25000","50000","100000","200000","250000","300000","350000","400000","450000","500000"]
        self.dropdownLimit.didSelect{(b , index ,id) in
            print("You Just select: \(b) at index: \(index)")
            self.selectedlist = b
        }
    }
    private func sendOtpCardChannelLimits() {
        
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
        
        //        let compelteUrl = "http://bbuat.fmfb.pk/nanoloan/getLoanPurpose"
        let compelteUrl  = GlobalConstants.BASE_URL + "sendOtpCardChannelLimits"
        let parameters = ["cnic": userCnic!, "imei": DataManager.instance.imei!, "channelId": DataManager.instance.channelID]
        
        
        //
        print(parameters)
        
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["ApiAttribute1":result.apiAttribute1,"ApiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken ?? "nil")"]
        
        
        print(compelteUrl)
        print(header)
        
       NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { [self] (response: DataResponse<LimitChangeModel>) in
//        Alamofire.request(compelteUrl, method: .post, parameters: parameters , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<LimitChangeModel>) in
      
            self.hideActivityIndicator()
            
            self.genericOBj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genericOBj?.responsecode == 2 || self.genericOBj?.responsecode == 1 {
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "OTPLimitMangmntVC") as! OTPLimitMangmntVC
                    VC.ATMId = self.ATMIdget
                    VC.MBid = self.MBidget
                    VC.selectAmount = self.selectedlist
                    self.navigationController?.pushViewController(VC, animated: true)
                    
                }
                else {
                    if let message = self.genericOBj?.messages{
                        self.showDefaultAlert(title: "", message: message)
                    }
                }
            }
            else {
                if let message = self.genericOBj?.messages{
                    self.showDefaultAlert(title: "", message: message)
                }
                //                print(response.result.value)
                //                print(response.response?.statusCode)
            }
        }
    }
    
    
}
    

