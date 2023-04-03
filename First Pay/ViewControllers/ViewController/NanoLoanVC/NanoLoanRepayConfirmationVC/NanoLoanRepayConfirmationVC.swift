//
//  NanoLoanRepayConfirmationVC.swift
//  First Pay
//
//  Created by Apple on 03/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire

class NanoLoanRepayConfirmationVC: UIViewController {

    @IBOutlet weak var viewBackGroundRepayNowButton: UIView!
    @IBOutlet weak var viewBackGroundTotalAmount: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonRepayNow: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGroundTotalAmount.radius()
        viewBackGroundRepayNowButton.circle()
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonRepayNow(_ sender: Any) {
        payActiveLoan()
    }
    
    func payActiveLoan() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "nlDisbursementId" : "304"
        ]
        
        APIs.postAPI(apiName: .payActiveLoan, parameters: parameters) { response, success, errorMsg in
            self.openNanoLoanRepaySucessfullVC()
            if success {
                if response?["data"].count ?? 0 == 0 {
                    self.openNanoLoanRepaySucessfullVC()
                }
                else {
                    
                }
            }
        }
    }
    
    func openNanoLoanRepaySucessfullVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanRepaySucessfullVC") as! NanoLoanRepaySucessfullVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
