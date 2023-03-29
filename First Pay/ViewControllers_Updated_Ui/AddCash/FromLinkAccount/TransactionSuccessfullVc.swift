//
//  TransactionSuccessfullVc.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class TransactionSuccessfullVc: BaseClassVC {
    var transactionAmount : String?
    var transactionId : String?
    var transactionType : String?
    var beneficiaryAccount : String?
    var sourceAccount : String?
    var dateTime : String?
    var image :UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonShare.setTitle("", for: .normal)
        buttonDownload.setTitle("", for: .normal)
        buttonCross.setTitle("", for: .normal)
        updateUi()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var labelFeeCharged: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelSourceAccount: UILabel!
    @IBOutlet weak var labelBeneficiaryAccount: UILabel!
    @IBOutlet weak var labelTransationType: UILabel!
    @IBOutlet weak var labelTransactionId: UILabel!
    @IBOutlet weak var labelTransactionAmount: UILabel!
    @IBOutlet weak var buttonDownload: UIButton!
    @IBAction func buttonShare(_ sender: UIButton) {
        let image =  imgview.convertToImage()
            
        let imageShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonDownload(_ sender: UIButton) {
        imgview.snapshotView(afterScreenUpdates: true)
        
        image = imgview.convertToImage()
        print(image)
       UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        showToast(title: "Photo Saved Succussfully!")
    }
    
    func updateUi()
    {
        
        labelTransactionAmount.text = transactionAmount
        labelTransactionId.text = transactionId
        labelTransationType.text = transactionType
        labelBeneficiaryAccount.text = beneficiaryAccount
        labelSourceAccount.text = sourceAccount
        labelDateTime.text = dateTime
        labelFeeCharged.text = "0.00"
        
        
    }

    @IBOutlet weak var buttonCross: UIButton!
    
    @IBAction func buttonCross(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
    }
    
    
}

