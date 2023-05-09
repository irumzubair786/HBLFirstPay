//
//  otherWalletTransationSuccessfullVC.swift
//  First Pay
//
//  Created by Irum Butt on 09/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class otherWalletTransationSuccessfullVC: BaseClassVC {
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
    var image :UIImage?
    var number : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCross.setTitle("", for: .normal)
        btnDownlload.setTitle("", for: .normal)
        UpdateUi()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblSourceAccount: UILabel!
    @IBOutlet weak var lblBeneficiaryAccount: UILabel!
    @IBOutlet weak var lblTransType: UILabel!
    @IBOutlet weak var lblTransactionId: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnDownlload: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblamount: UILabel!
    @IBOutlet weak var lblWalletName: UILabel!
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
       if isfromOtherLocalBank == true{
        
                   
                    lblWalletName.isHidden = false
                    lblWalletName.text = "HBL MfB Transfer"
                    lblTransactionId.text  = TransactionId
                    lblTransType.text = "Bank Name"
           var merge = "\(DataManager.instance.accountTitle!) \(DataManager.instance.accountNo!)"
                    lblSourceAccount.text = merge
                    lblDateTime.text = TransactionDate!
                    lblBeneficiaryAccount.text = number!
               lblWalletName.text = GlobalData.Selected_bank
                  
                }
                else{
                   
                  
                    lblTransactionId.text  = TransactionId
                    lblTransType.text = "Wallet Name"
                    lblBeneficiaryAccount.text = number!
                    lblWalletName.text = "Wallet Transfer"
                    lblWalletName.text = GlobalData.Selected_bank
                    var merge = "\(DataManager.instance.accountTitle!) \(DataManager.instance.accountNo!)"
                             lblSourceAccount.text = merge
                    lblDateTime.text = TransactionDate!
                    
        
        
        
                }
        
    }
}
