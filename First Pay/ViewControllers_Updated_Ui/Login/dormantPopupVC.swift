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
    var consentStatus : String?
    var loginHistoryId: Int?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var buttonyes: UIButton!
    @IBAction func buttonyes(_ sender: UIButton) {
        apicall()
    }
    @IBAction func buttonNo(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            "accountType": "\(DataManager.instance.accountType ?? "0")",
            "consentStatus": consentStatus ?? "" ,"loginHistoryId": "\(loginHistoryId ?? 0)"
            ]
            
        APIs.postAPI(apiName: .updateAccountStatus, parameters: parameters, viewController: self) { responseData, success, errorMsg in
                
                    let model : GenericModel? = APIs.decodeDataToObject(data: responseData)
                    print("response",model)
                    self.modelGeneric = model
                }
        
    }
    
    var modelGeneric : GenericModel?
    {
        didSet{
            if self.modelGeneric?.responsecode == 1  {
                print("api calling")
//                loginAction
                
//                self.appenddata()
                
            }
            else {
                //MARK: - Loan Failed Successfully
                self.showAlertCustomPopup(title: "Error!", message: modelGeneric?.messages ?? "", iconName: .iconError)
            }
      
            
        }
    }
    
    
}
