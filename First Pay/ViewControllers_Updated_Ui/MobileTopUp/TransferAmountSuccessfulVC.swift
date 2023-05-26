//
//  TransferAmountSuccessfulVC.swift
//  First Pay
//
//  Created by Irum Butt on 05/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class TransferAmountSuccessfulVC: BaseClassVC {
    var amount :String?
    var phoneNumber  : String?
    var Trascationid : String?
    var TransactionDate : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCancel.setTitle("", for: .normal)
        btnFavourite.setTitle("", for: .normal)
        btnDownload.setTitle("", for: .normal)
        btnShare.setTitle("", for: .normal)
        updateui()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblOperator: UILabel!
    @IBOutlet weak var lblTransactionType: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblTransationId: UILabel!
    @IBOutlet weak var lblSendTo: UILabel!
    @IBOutlet weak var lblSendBy: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var mainView: UIView!
    var image :UIImage?
    @IBAction func Action_favourite(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func Action_DownLoad(_ sender: UIButton) {

                mainView.snapshotView(afterScreenUpdates: true)
                image = mainView.convertToImage()
                print(image)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        showToast(title: "Photo Saved Succussfully!")
    }
    
    
    @IBAction func Action_Share(_ sender: UIButton) {
        let image =  mainView.convertToImage()
            
        let imageShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
           
    }
    
    
    @IBAction func Action_Cancel(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
       
        
    }
    
    func updateui() {
        
        lblAmount.text = "Rs. \(Int(amount!)?.twoDecimal() ?? "0")"
        lblFee.text = "Rs. 0.00 Charged"
        lblTransationId.text = Trascationid
        lblSendTo.text = phoneNumber
        lblSendBy.text = "FirstPay Account\(DataManager.instance.accountNo!)"
      
        if GlobalData.topup == "Postpaid"
        {
            lblTransactionType.text = "Mobile Load Postpaid"
        }
        else{
            lblTransactionType.text = "Mobile Load Prepaid"
        }
       
        lblOperator.text = GlobalData.Selected_operator
        lblDateTime.text = TransactionDate
        
    }
    

}



extension UIView {
   func convertToImage() -> UIImage {
       let renderer = UIGraphicsImageRenderer(bounds: bounds)
       return renderer.image { rendererContext in
           layer.render(in: rendererContext.cgContext)
       }
   }
}
