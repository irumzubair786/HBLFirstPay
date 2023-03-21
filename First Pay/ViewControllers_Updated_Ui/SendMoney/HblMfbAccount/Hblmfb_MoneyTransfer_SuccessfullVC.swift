//
//  Hblmfb_MoneyTransfer_SuccessfullVC.swift
//  First Pay
//
//  Created by Irum Butt on 10/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class Hblmfb_MoneyTransfer_SuccessfullVC: BaseClassVC {
    var image :UIImage?
    var name: String?
    var number: String?
    var sourceAccount:String?
    var beneficaryAccount:String?
    var transferAmount:String?
    var accountTitle: String?
    var feeAmount: Double?
    var fedAmount: Double?
    var transPurposeCode: String?
    var otpReq: String?
    var amount: Double?
    var TransactionId: String?
    var TransactionDate: String?
    var Toaccounttitle : String?
    override func viewDidLoad() {
        super.viewDidLoad()
      
        btnCross.setTitle("", for: .normal)
        btnDownlload.setTitle("", for: .normal)
        btnShare.setTitle("", for: .normal)
        lblWalletName.isHidden = true
        lblwalletNameValue.isHidden = true
//        lblFee.isHidden = true
//        lblFeeCharged.isHidden = true
        UpdateUi()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblFeeCharged: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblSourceAccount: UILabel!
    @IBOutlet weak var lblBeneficiaryAccount: UILabel!
    @IBOutlet weak var lblTransType: UILabel!
    @IBOutlet weak var lblTransactionId: UILabel!
    @IBOutlet weak var lblwalletNameValue: UILabel!
    @IBOutlet weak var lblWalletName: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnDownlload: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblamount: UILabel!
    @IBAction func Action_Cross(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "SendMoney", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SendMoney_MainVc")
       
        self.present(vc, animated: true)
        
    }
    
    
    @IBOutlet weak var imgview: UIView!
    @IBAction func Action_Download(_ sender: UIButton) {
        imgview.snapshotView(afterScreenUpdates: true)
        
        image = imgview.convertToImage()
        print(image)
       UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        showToast(title: "Photo Saved Succussfully!")
        
    }
    
    
    
    @IBAction func Action_Share(_ sender: UIButton) {
        let image =  imgview.convertToImage()
            
        let imageShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func UpdateUi()
    
    {
        lblamount.text = "Rs \(amount!)"
        if isfromFirstPayWallet == true
        {
           
            lblTransactionId.text  = TransactionId
            lblTransType.text = "FirstPay Wallet"
            lblSourceAccount.text = Toaccounttitle!
            lblDateTime.text = TransactionDate!
            lblFee.text = "Rs 0.00"
            lblBeneficiaryAccount.text = number!
              
        }
        else if isfromHblMbfAccount == true
        {            lblTransactionId.text  = TransactionId
            lblTransType.text = "HBL MFB Transfer"
            lblSourceAccount.text = Toaccounttitle!
            lblDateTime.text = TransactionDate!
            lblFee.text = "Rs 0.00"
            lblBeneficiaryAccount.text = number!
             
        }
            
        else if isfromOtherLocalBank == true{
            
            lblWalletName.isHidden = false
            lblwalletNameValue.isHidden = false
            lblWalletName.text = "HBL MFB Transfer"
            lblTransactionId.text  = TransactionId
            lblTransType.text = "Bank Name"
            lblSourceAccount.text = Toaccounttitle!
            lblDateTime.text = TransactionDate!
            lblBeneficiaryAccount.text = number!
            lblwalletNameValue.text = GlobalData.Selected_bank
            lblFee.text = "Rs 0.00"
            
           
            
            
            
        }
        else{
            lblWalletName.isHidden = false
            lblwalletNameValue.isHidden = false
            lblTransactionId.text  = TransactionId
            lblTransType.text = "Wallet Name"
            lblBeneficiaryAccount.text = number!
            lblWalletName.text = "Wallet Transfer"
            lblwalletNameValue.text = GlobalData.Selected_bank
            lblSourceAccount.text = Toaccounttitle!
            lblDateTime.text = TransactionDate!
            lblFee.text = "Rs 0.00"
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
}
