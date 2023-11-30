//
//  RequestMoneyTransactionSuccessFullVC.swift
//  First Pay
//
//  Created by Irum Zubair on 08/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class RequestMoneyTransactionSuccessFullVC: BaseClassVC {
    var image :UIImage?
    var name: String?
    var Benenumber: String?
    var sourceAccount:String?
    var beneficaryAccount:String?
    var transferAmount:String?
    var accountTitle: String?
    var feeAmount: Double?
    var fedAmount: Double?
    var transPurposeCode: String?
    var otpReq: String?
    var amount: String?
    var TransactionId: String?
    var TransactionDate: String?
    var Toaccounttitle : String?
    var AccountNo : String?
    var accountUpGradeSuccessfull: (() -> ())!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCross.setTitle("", for: .normal)
        UpdateUi()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblSourceAccount: UILabel!
   
    @IBOutlet weak var lblTransType: UILabel!
    @IBOutlet weak var lblTransactionId: UILabel!
   
    @IBOutlet weak var lblbeneficiaryAccountNo: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnDownlload: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblamount: UILabel!
    @IBAction func Action_Cross(_ sender: UIButton) {
//
       
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MYApprovalVC") as! MYApprovalVC
//        self.present(vc, animated: true)
//
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
                       self.present(vc, animated: true)
//        self.dismiss(animated: false)
//        accountUpGradeSuccessfull!()
        
    }
    
    func UpdateUi()
    {
        
        
        lblamount.text = amount!
        lblTransactionId.text = TransactionId!
        lblTransType.text = "FirstPay Wallet"
        lblbeneficiaryAccountNo.text = Benenumber!
        lblSourceAccount.text = "FirstPay Account    \(AccountNo!)"
        lblDateTime.text = TransactionDate!
        
        
        
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
    

}
