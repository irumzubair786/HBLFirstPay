//
//  changeLimitVC.swift
//  First Pay
//
//  Created by Irum Butt on 12/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import PinCodeTextField
import SwiftKeychainWrapper
class changeLimitVC: BaseClassVC {
    var genResponseObj : GenericResponseModel?
    var daily :String?
    var dailyAmount :Int?
    var dailyminValue :Int?
    var dailymaxValue :Int?
    
    var monthly :String?
    var monthlyAmount :Int?
    var monthlyminValue :Int?
    var monthlymaxValue :Int?
    
    var yearly :String?
    var yearlyAmount :Int?
    var yearlyminValue :Int?
    var yearlymaxValue :Int?
    
    var dailyReceiving :String?
    var dailyReceivingAmount :Int?
    var dailyReceivingminValue :Int?
    var dailyReceivingmaxValue :Int?
    
    var monthlyReceiving :String?
    var monthlyReceivingAmount :Int?
    var monthlyReceivingminValue :Int?
    var monthlyReceivingmaxValue :Int?
    
    var yearlyReceiving :String?
    var yearlyReceivingAmount :Int?
    var yearlyReceivingminValue :Int?
    var yearlyReceivingmaxValue :Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.alpha = 0.7
        updateUI()
        // Do any additional setup after loading the view.
    }
    

    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labelMaxamount: UILabel!
    @IBOutlet weak var labelminamount: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelname: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    func updateUI()
    {
        labelname.text  = "Change\(daily!)Limit"
    }
    
    @IBAction func Action_Slider(_ sender: UISlider) {
    }
    
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        changeAcctLimits()
        
        
    }
    
    private func changeAcctLimits() {
        
        if !NetworkConnectivity.isConnectedToInternet(){
            self.showToast(title: "No Internet Available")
            return
        }
        showActivityIndicator()
     

        let compelteUrl = GlobalConstants.BASE_URL + "FirstPayInfo/v1/changeAcctLimitst"
        
        var userCnic : String?
        if KeychainWrapper.standard.hasValue(forKey: "userCnic"){
            userCnic = KeychainWrapper.standard.string(forKey: "userCnic")
        }
        else{
            userCnic = ""
        }
        userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters = ["channelId":"\(DataManager.instance.channelID)","cnic":userCnic!,"imei":DataManager.instance.imei!,"accountType": DataManager.instance.accountType!] as [String : Any]
        
        print(parameters)
        let result = (splitString(stringToSplit: base64EncodedString(params: parameters)))
        
        print(result.apiAttribute1)
        print(result.apiAttribute2)
        
        let params = ["apiAttribute1":result.apiAttribute1,"apiAttribute2":result.apiAttribute2,"channelId":"\(DataManager.instance.channelID)"]
        let header = ["Content-Type":"application/json","Authorization":"\(DataManager.instance.accessToken!)"]
        print(params)
        print(compelteUrl)
        NetworkManager.sharedInstance.enableCertificatePinning()
        NetworkManager.sharedInstance.sessionManager?.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<GenericResponseModel>) in
            
     //       Alamofire.request(compelteUrl, method: .post, parameters: params , encoding: JSONEncoding.default, headers:header).responseObject { (response: DataResponse<VerifyOTP>) in
            
            self.hideActivityIndicator()
            
            self.genResponseObj = response.result.value
            
            if response.response?.statusCode == 200 {
                if self.genResponseObj?.responsecode == 2 || self.genResponseObj?.responsecode == 1 {
//
//                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
//                    self.present(vc, animated: true)
                }
                
                else {
                    if let message = self.genResponseObj?.messages {
                        UtilManager.showAlertMessage(message: message, viewController: self)
//                        self.showAlert(title: "", message: message, completion: nil)
                    }
//                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
//                    self.present(vc, animated: true)
                }
            }
            else {
                if let message = self.genResponseObj?.messages {
                    UtilManager.showAlertMessage(message: message, viewController: self)
                }
//                print(response.result.value)
//                print(response.response?.statusCode)
                
            }
        }
    }
}
