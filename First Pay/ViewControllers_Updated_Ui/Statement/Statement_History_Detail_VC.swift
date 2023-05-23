//
//  Statement_History_Detail_VC.swift
//  First Pay
//
//  Created by Irum Butt on 06/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class Statement_History_Detail_VC: BaseClassVC {
    var images :UIImage?
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
    var image :UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        btnshare.setTitle("", for: .normal)
        btndownload.setTitle("", for: .normal)
        btnreport.setTitle("", for: .normal)
        btnCancel.setTitle("", for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedDownload(tapGestureRecognizer:)))
        ViewDownload.isUserInteractionEnabled = true
        ViewDownload.addGestureRecognizer(tapGestureRecognizer)

        let tapGestureRecognizerr = UITapGestureRecognizer(target: self, action: #selector(imageTappedShare (tapGestureRecognizer:)))
        ViewShare.isUserInteractionEnabled = true
        ViewShare.addGestureRecognizer(tapGestureRecognizerr)
//        self.btnreport.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }


    @IBOutlet weak var ViewDownload: UIView!
    @IBOutlet weak var ViewShare: UIView!
    @IBOutlet weak var btnCancel: UIButton!

    @IBOutlet weak var btnshare: UIButton!
    @IBOutlet weak var imgview: UIView!
    @IBOutlet weak var btndownload: UIButton!
    @IBOutlet weak var btnreport: UIButton!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblwithouttx: UILabel!
    @IBOutlet weak var lblSourceWallet: UILabel!
    @IBOutlet weak var lblReceiverWallet: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblTransactionType: UILabel!
    @IBOutlet weak var lblChannel: UILabel!
    @IBOutlet weak var lblOpeningBalance: UILabel!
    @IBOutlet weak var lblClosingBalance: UILabel!

    private func updateUI() {
      
        if let amount = strAmount {
            
            let concate = "\(strAmount!)" + "  \(strCreditDebit!)"
            lblAmount.text = concate
        }

        else{
            lblAmount.text = ""
        }
//        if let creditDebit = strCreditDebit {
//            lblCreditDebit.text = creditDebit
//        }
//        else{
//            lblCreditDebit.text = ""
//        }
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
        
//        if let purpose = strPurpose {
//            lblPurpose.text = purpose
//        }
//        else{
//            lblPurpose.text = ""
//        }
        
        if let sourceBank = strSourceBank {
            lblSourceWallet.text = sourceBank
        }
        else{
            lblSourceWallet.text = ""
            lblSourceWallet.isHidden = true
          
        }
        
        if let destBank = strDestinationBank {
            lblReceiverWallet.text = destBank
        }
        
        if let tax = whtAmt
        {
            lblwithouttx.text = "\(tax)"
            print("tax is:" , lblwithouttx.text)
        }
        else{
            lblReceiverWallet.text = ""
            lblReceiverWallet.isHidden = true
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
//        if let status = self.status{
//
//            if status == "Y"{
//                self.btnreport.isUserInteractionEnabled = false
//            }
//                        else{
//                self.btnreport.isUserInteractionEnabled = true
//            }
//        }
        
        
        
        
    }


    @IBAction func Action_Download(_ sender: UIButton) {
        let image =  imgview.convertToImage()

        let imageShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated:true, completion: nil)
      


    }






    @IBAction func Action_Share(_ sender: UIButton) {
                
            imgview.snapshotView(afterScreenUpdates: true)
            image = imgview.convertToImage()
            print(image)
            showToast(title: "Photo Saved Successfully!")
           UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)

    }
    @objc func imageTappedDownload(tapGestureRecognizer: UITapGestureRecognizer)
    {
        imgview.snapshotView(afterScreenUpdates: true)
        image = imgview.convertToImage()
        print(image)
       UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)

   }
    @objc func imageTappedShare(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let image =  imgview.convertToImage()

        let imageShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)

   }

    @IBAction func Action_Report(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Statement_ReportVC") as! Statement_ReportVC

        self.navigationController!.pushViewController(vc, animated: false)


    }


    @IBAction func ActionCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

//
}

