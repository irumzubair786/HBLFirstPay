//
//  BillPayment_SuccessfullVC.swift
//  First Pay
//
//  Created by Irum Butt on 30/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class BillPayment_SuccessfullVC: BaseClassVC {
    var refferenceNumber:String?
    var company : String?
    var billingMonth : String?
    var amountDue : String?
    var status:String?
    var totalAmount:String?
    var dueDate :String?
    var image :UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCross.setTitle("", for: .normal)
        buttonShare.setTitle("", for: .normal)
        buttonDownload.setTitle("", for: .normal)
        updateui()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var buttonCross: UIButton!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelFeeCharged: UILabel!
    @IBOutlet weak var labelBillingMonth: UILabel!
    @IBOutlet weak var labelCompany: UILabel!
    @IBOutlet weak var labelRefferenceNumber: UILabel!
    @IBOutlet weak var buttonDownload: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    @IBAction func buttonCross(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
    }
    @IBAction func buttonDownload(_ sender: UIButton) {
        imgview.snapshotView(afterScreenUpdates: true)
        
        image = imgview.convertToImage()
        print(image)
       UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        showToast(title: "Photo Saved Succussfully!")
    }
    @IBAction func buttonShare(_ sender: UIButton) {
        let image =  imgview.convertToImage()
            
        let imageShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    func updateui()
    {
        
        labelTotalAmount.text = totalAmount
        labelRefferenceNumber.text = refferenceNumber
        labelCompany.text = company
        labelAmount.text = totalAmount
        labelDateTime.text = dueDate
        labelFeeCharged.text = "0.0"
        labelBillingMonth.text = billingMonth
        
    }
}
