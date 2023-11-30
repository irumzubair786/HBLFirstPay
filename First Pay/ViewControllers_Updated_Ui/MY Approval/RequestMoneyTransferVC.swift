//
//  RequestMoneyTransferVC.swift
//  First Pay
//
//  Created by Irum Zubair on 29/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
var isFromPurpose : Bool?
class RequestMoneyTransferVC: BaseClassVC, UITextFieldDelegate {
    
    var ComaSepAmount : String?
    var harcodePurpose :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDropDown.setTitle("", for: .normal)
        buttonTf.setTitle("", for: .normal)
        buttonBack.setTitle("", for: .normal)
        buttonLine.setTitle("", for: .normal)
        
        tfAmount.delegate = self
        updateUI()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        img_next_arrow.isUserInteractionEnabled = true
        img_next_arrow.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonTf: UIButton!
    
    func updateUI()
    {
       
        lblTitle.text = accountName!
        lblWallet.text = "FirstPay Wallet"
        lblAccountNo.text = accountNo!
        if isFromPurpose == true{
            PurposeTf.text = GlobalData.money_Reason
          
        }
        else{
            
            GlobalData.moneyTransferReasocCode = "0350"
            GlobalData.money_Reason = "Miscellaneous Payments"
            PurposeTf.text = "Miscellaneous Payments"
        }
      
        CommaSepration()
        lblFromAccountNo.text = DataManager.instance.accountNo!
        lbltransactionFee.text = "Rs. 0.00"
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if isFromPurpose == true{
            PurposeTf.text = GlobalData.money_Reason
          
        }
        else{
            
            GlobalData.moneyTransferReasocCode = "0350"
            GlobalData.money_Reason = "Miscellaneous Payments"
            PurposeTf.text = "Miscellaneous Payments"
        }
    }
    
    func CommaSepration()
    {
        var number = (Amount!)
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en_US")
        ComaSepAmount = (formatter.string(from: NSNumber(value: number)))!
        tfAmount.text = "Rs. \(ComaSepAmount!).00"
        totalAmount.text = "Rs. \(ComaSepAmount!).00"
    }
    
    
    
    @IBAction func buttonBackl(_ sender: UIButton) {
        isFromPurpose = false
        self.dismiss(animated: true)
        
    }
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var buttonDropDown: UIButton!
    @IBOutlet weak var lblAlert: UILabel!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var lblFromAccountNo: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var PurposeTf: UITextField!
    @IBOutlet weak var btn_Next: UIButton!
    @IBOutlet weak var lbltransactionFee: UILabel!
    @IBOutlet weak var img_next_arrow: UIImageView!
    
    @IBOutlet weak var buttonLine: UIButton!
    
    
    @IBOutlet weak var buttonBack: UIButton!
    
    
    
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)    {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ConfirmationScreen") as! ConfirmationScreen
        vc.TotalAmount = "Rs. \(ComaSepAmount!).00"
        
 
        self.present(vc, animated: true)
        
    }
    @IBAction func buttonContinue(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ConfirmationScreen") as! ConfirmationScreen
        vc.TotalAmount = "Rs. \(ComaSepAmount!).00"
        self.present(vc, animated: true)
    }
    @IBAction func ReasonDropdown(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PurposeSelectionVC") as! PurposeSelectionVC
        isFromPurpose = true
        self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    

}
