//
//  MiniStatementDetailsVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 01/08/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit


class MiniStatementDetailsVC: UIViewController {
    
    
    
    @IBOutlet weak var lblwithouttx: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCreditDebit: UILabel!
    @IBOutlet weak var lblSourceWallet: UILabel!
    @IBOutlet weak var lblReceiverWallet: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblTransactionType: UILabel!
    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var lblSourceBank: UILabel!
    @IBOutlet weak var lblDestinationBank: UILabel!
   
    @IBOutlet weak var lblChannel: UILabel!
    @IBOutlet weak var lblOpeningBalance: UILabel!
    @IBOutlet weak var lblClosingBalance: UILabel!
    @IBOutlet var btn_Ok: UIButton!
    @IBOutlet var btn_Dispute: UIButton!
    var strAmount:String?
    var strCreditDebit:String?
    var strSourceWallet:String?
    var strReceiverWallet:String?
    var strDateTime:String?
    var strTransactionType:String?
    var strPurpose:String?
    var strSourceBank : String?
    var strDestinationBank : String?
    var strChannel : String?
    var strOpenningBalance : String?
    var strClosingBalance: String?
    var status : String?
    var whtAmt : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btn_Ok.setTitle("Ok", for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Utility Methods
    private func updateUI() {
        
        if let amount = strAmount {
            lblAmount.text = amount
        }
        else{
            lblAmount.text = ""
        }
        if let creditDebit = strCreditDebit {
            lblCreditDebit.text = creditDebit
        }
        else{
            lblCreditDebit.text = ""
        }
        if let sourceWallet = strSourceWallet {
            lblSourceWallet.text = sourceWallet
        }
        else{
            lblSourceWallet.text = ""
        }
        if let receiverWallet = strReceiverWallet {
            lblReceiverWallet.text = receiverWallet
        }
        else{
            lblReceiverWallet.text = ""
        }
        
        if let dateTime = strDateTime {
            lblDateTime.text = dateTime
        }
        else{
            lblDateTime.text = ""
        }
        
        if let transType = strTransactionType {
            lblTransactionType.text = transType
        }
        else{
            lblTransactionType.text = ""
        }
        
        if let purpose = strPurpose {
            lblPurpose.text = purpose
        }
        else{
            lblPurpose.text = ""
        }
        
        if let sourceBank = strSourceBank {
            lblSourceBank.text = sourceBank
        }
        else{
            lblSourceBank.text = ""
            lblSourceBank.isHidden = true
          
        }
        
        if let destBank = strDestinationBank {
            lblDestinationBank.text = destBank
        }
        
        if let tax = whtAmt
        {
            lblwithouttx.text = "\(tax)"
            print("tax is:" , lblwithouttx.text)
        }
        else{
            lblDestinationBank.text = ""
            lblDestinationBank.isHidden = true
            lblwithouttx.text = "0.0"
           
        }
        
        if let channel = strChannel {
            
            if channel == "MB"{
                lblChannel.text = "BBS"
            }
            else if channel == "1LINK"{
                lblChannel.text = "IBFT"
            }
            else if channel == "CRM"{
                lblChannel.text = "Contact Centre"
            }
            else if channel == "ATM"{
                lblChannel.text = "ATM"
            }
            else {
                lblChannel.text = channel
            }
        }
        else{
            lblChannel.text = ""
        }
        
        if let strOpenBalance = strOpenningBalance {
            lblOpeningBalance.text = "Rs. \(strOpenBalance)"
        }
        else{
            lblOpeningBalance.text = ""
        }
        
        if let closeBalance = strClosingBalance {
            lblClosingBalance.text = "Rs. \(closeBalance)"
        }
        else{
            lblClosingBalance.text = ""
        }
        if let status = self.status{
            
            if status == "Y"{
                self.btn_Dispute.isUserInteractionEnabled = false
            }
                        else{
                self.btn_Dispute.isUserInteractionEnabled = true
            }
        }
        
    }
    
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func disputeButtonPressed(_ sender: UIButton) {
        
        
        let consentAlert = UIAlertController(title: "Alert", message: "Do you want to Proceed".addLocalizableString(languageCode: languageCode), preferredStyle: UIAlertControllerStyle.alert)
        
        consentAlert.addAction(UIAlertAction(title: "Yes".addLocalizableString(languageCode: languageCode), style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion:nil)
            NotificationCenter.default.post(name: Notification.Name("disputeButtonPressed"), object: nil)
        }))
        
        consentAlert.addAction(UIAlertAction(title: "Cancel".addLocalizableString(languageCode: languageCode), style: .cancel, handler: { (action: UIAlertAction!) in
            
            self.dismiss(animated: true, completion:nil)
        }))
        
        present(consentAlert, animated: true, completion: nil)
        
        //        self.dismiss(animated: true, completion:nil)
        //
        ////        let disputeVC = self.storyboard!.instantiateViewController(withIdentifier: "DisputeTransactionVC") as! DisputeTransactionVC
        ////        self.navigationController!.pushViewController(disputeVC, animated: true)
        //
        //        NotificationCenter.default.post(name: Notification.Name("disputeButtonPressed"), object: nil)
        
    }
    
}












