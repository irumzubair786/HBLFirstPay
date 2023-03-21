//
//  PrepaidTopUpSuccessfulVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 11/12/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit

class PrepaidTopUpSuccessfulVC: BaseClassVC {
    
    @IBOutlet weak var lblCompanyNameValue: UILabel!
    @IBOutlet weak var lblMobileNumberValue: UILabel!
    @IBOutlet weak var lblTransferAmountValue: UILabel!
    @IBOutlet weak var lblTransReferenceNumberValue: UILabel!
    @IBOutlet weak var lblTransactionTime: UILabel!
    
    var companyName:String?
    var mobileNumber:String?
    var transferAmount:String?
    var transRefNumber:String?
    var transTime:String?
    var lsttrsc : [LastTransactionsResponse]?
    var otpReq: String?
    var amount : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.updateUI()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Utility Methods
       
       private func updateUI(){
           
           if let companyName = self.companyName{
               self.lblCompanyNameValue.text = companyName
           }
           if let mobilenumber = self.mobileNumber{
               self.lblMobileNumberValue.text = mobilenumber
           }
           if let amount = self.transferAmount{
               self.lblTransferAmountValue.text = amount
           }
           if let transRef = self.transRefNumber{
               self.lblTransReferenceNumberValue.text = transRef
           }
           if let transTime = self.transTime {
               self.lblTransactionTime.text = transTime
           }
        
           
       }
    
    // MARK: - Action Methods
    @IBAction func okButtonPressed(_ sender: Any) {
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
   

}
