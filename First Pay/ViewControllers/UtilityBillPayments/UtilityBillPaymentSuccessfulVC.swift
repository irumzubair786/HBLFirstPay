//
//  UtilityBillPaymentSuccessfulVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 22/01/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit

class UtilityBillPaymentSuccessfulVC: BaseClassVC {
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblConsumerNumber: UILabel!
    @IBOutlet weak var lblTransferAmount: UILabel!
    @IBOutlet weak var lblTransReferenceNumberValue: UILabel!
    @IBOutlet weak var lblTransactionTime: UILabel!
    
    var companyName:String?
    var customerName:String?
    var consumerNumber:String?
    var transferAmount:String?
    var TransRefNumber:String?
    var TransTime:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        if let account = companyName{
            self.lblCompanyName.text = account
        }
        if let beneAccount = customerName{
            self.lblCustomerName.text = beneAccount
        }
        if let beneAccountTitle = consumerNumber{
            self.lblConsumerNumber.text = beneAccountTitle
        }
        if let Tamount = transferAmount{
            self.lblTransferAmount.text = "PKR \(Tamount).00"
        }
        if let transRef = TransRefNumber{
            self.lblTransReferenceNumberValue.text = transRef
        }
        if let transTime = TransTime {
            self.lblTransactionTime.text = transTime
        }
    }
    
    // MARK: - Action Methods
    @IBAction func okButtonPressed(_ sender: Any) {
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    
    
    
}
