//
//  RequestMoneyTransactionSuccessFullVC.swift
//  First Pay
//
//  Created by Irum Zubair on 08/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class RequestMoneyTransactionSuccessFullVC: BaseClassVC {
    var sourceAccount:String?
    var beneficaryAccount:String?
    var transferAmount:String?
    var image :UIImage?
    var transPurposeCode: String?
    var amount: Double?
    var TransactionId: String?
    var TransactionDate: String?
    var AccountNo : String?
    override func viewDidLoad() {
        super.viewDidLoad()

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
//        let storyboard = UIStoryboard(name: "SendMoney", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SendMoney_MainVc")
//
//        self.present(vc, animated: true)
        
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
