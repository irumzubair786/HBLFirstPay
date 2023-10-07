//
//  MobilePackagesSucess.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 20/09/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import Toaster

class MobilePackagesSuccess: UIViewController {

    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var labelAmountTitle: UILabel!
    
    @IBOutlet weak var labelAmount: UILabel!
    
    @IBOutlet weak var labelReceivedBy: UILabel!
    @IBOutlet weak var labelOperator: UILabel!
    @IBOutlet weak var labelPackageName: UILabel!
    @IBOutlet weak var labelSentBy: UILabel!
    @IBOutlet weak var labelFeeCharges: UILabel!
    @IBOutlet weak var labelOfferDiscount: UILabel!
    
    @IBOutlet weak var buttonDownload: UIButton!
    
    @IBOutlet weak var buttonShare: UIButton!
    var modelBundleSubscription: MobilePackagesDetails.ModelBundleSubscription!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
    }
    @IBAction func buttonDownload(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let screenshot = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        self.showToast(title: "Certificate Download Successfully!")
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func buttonShare(_ sender: Any) {
        let image =  self.view.convertToImage()
        let imageShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setData() {
        if modelBundleSubscription == nil {
            return()
        }
        labelAmountTitle.text = "PKR \(modelBundleSubscription.data?.amount ?? 0)"
        labelReceivedBy.text = modelBundleSubscription.data?.receivedBy
        labelOperator.text = modelBundleSubscription.data?.dataOperator
        labelPackageName.text = modelBundleSubscription.data?.packageName
        labelSentBy.text = modelBundleSubscription.data?.sentBy
        labelAmount.text = "Rs. \(modelBundleSubscription.data?.amount ?? 0)"
        labelFeeCharges.text = "Rs. \(modelBundleSubscription.data?.fee ?? "")"
        labelOfferDiscount.text = "Rs. \(modelBundleSubscription.data?.offerDiscount ?? 0)"
    }
    private func showToast(title:String){
        Toast(text:title, duration: Delay.long).show()
    }
}
