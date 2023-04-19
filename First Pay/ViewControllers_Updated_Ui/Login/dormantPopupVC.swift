//
//  dormantPopupVC.swift
//  First Pay
//
//  Created by Irum Butt on 19/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire
import AlamofireObjectMapper
class dormantPopupVC: BaseClassVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var buttonyes: UIButton!
    @IBAction func buttonyes(_ sender: UIButton) {
    }
    @IBAction func buttonNo(_ sender: UIButton) {
    }
    
    
//    "cnic":"3520220233345",
//        "imei":"529114003911485",
//        "channelId":3
//        "consentStatus":"Y"  Possible values are: 'Y' for 'YES' and 'N' for 'NO'
//        "loginHistoryId":"10200"
    
    func apicall()
    {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imeiNo" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "accountType": "\(DataManager.instance.accountType ?? "0")"
            ]
            
        APIs.postAPI(apiName: .getAccLimits, parameters: parameters, viewController: self) { responseData, success, errorMsg in
                
                    let model : GetAccLimits2? = APIs.decodeDataToObject(data: responseData)
                    print("response",model)
                    self.modelGetAccount = model
                }
        
    }
    
    var modelGetAccount : GetAccLimits2?
    {
        didSet{
            if self.modelGetAccount?.responsecode == 1  {
                
                
//                self.appenddata()
                
            }
            else {
                //MARK: - Loan Failed Successfully
                self.showAlertCustomPopup(title: "Error!", message: modelGetAccount?.messages ?? "", iconName: .iconError)
            }
      
            
        }
    }
    
    
}
