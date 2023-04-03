//
//  NanoLoanConfirmationVC.swift
//  First Pay
//
//  Created by Apple on 03/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire

class NanoLoanConfirmationVC: UIViewController {

    @IBOutlet weak var viewBackGroundHint: UIView!
    @IBOutlet weak var viewLoanAmountBackGround: UIView!
    @IBOutlet weak var buttonTermsAndConditions: UIButton!
    
    @IBOutlet weak var buttonBack: UIButton!
    
    
    @IBOutlet weak var buttonGetLoan: UIButton!
    @IBOutlet weak var viewGetLoanButton: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewGetLoanButton.circle()
        viewLoanAmountBackGround.radius()
        viewBackGroundHint.radius()

    }
    @IBAction func buttonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonTermsAndConditions(_ sender: Any) {
    }
    
    @IBAction func buttonGetLoan(_ sender: Any) {
        applyLoan()
    }

    func applyLoan() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "amount" : "1000",
            "productId" : "2",
            "loanPurpose" : "2",
        ]
        
        APIs.postAPI(apiName: .applyLoan, parameters: parameters) { response, success, errorMsg in
            self.openNanoLoanConfirmationVC()
            if success {
                if response?["data"].count ?? 0 == 0 {
                    
                }
                else {
                    
                }
            }
        }
    }
    
    func openNanoLoanConfirmationVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanSuccessfullVC") as! NanoLoanSuccessfullVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

