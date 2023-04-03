//
//  NanoLoanRepayViewController.swift
//  HBLFMB
//
//  Created by Apple on 24/03/2023.
//

import UIKit
import Alamofire

class NanoLoanRepayViewController: UIViewController {
    
    @IBOutlet weak var viewApplyButton: UIView!
    @IBOutlet weak var viewBenifitRepaying: UIView!
    
    @IBOutlet weak var buttonRepayNow: UIButton!
    @IBOutlet weak var buttonBenifits: UIButton!
    @IBOutlet weak var buttonMarkupCalendar: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBenifitRepaying.circle()
        viewApplyButton.circle()

    }
    @IBAction func buttonMarkupCalendar(_ sender: Any) {
    }
    @IBAction func buttonBenifits(_ sender: Any) {
        openNanoLoanBenifitVC()
    }
    @IBAction func buttonRepayNow(_ sender: Any) {
        getActiveLoanToPay()
    }
    
    func getActiveLoanToPay() {
        let userCnic = UserDefaults.standard.string(forKey: "userCnic")
        
        let parameters: Parameters = [
            "cnic" : userCnic!,
            "imei" : DataManager.instance.imei!,
            "channelId" : "\(DataManager.instance.channelID)",
            "nlDisbursementId" : "1"
        ]
        
        APIs.postAPI(apiName: .getActiveLoanToPay, parameters: parameters) { response, success, errorMsg in
            if success {
                self.openNanoLoanRepayConfirmationVC()
                if response?["data"].count ?? 0 == 0 {
                    
                }
                else {
                    
                }
            }
        }
    }
    
    func openNanoLoanRepayConfirmationVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanRepayConfirmationVC") as! NanoLoanRepayConfirmationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openNanoLoanBenifitVC() {
        let vc = UIStoryboard.init(name: "NanoLoan", bundle: nil).instantiateViewController(withIdentifier: "NanoLoanBenifitVC") as! NanoLoanBenifitVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}
