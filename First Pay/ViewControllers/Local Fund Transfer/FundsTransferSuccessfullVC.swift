//
//  FundsTransferSuccessfullVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/12/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import UIKit
import SCLAlertView
class FundsTransferSuccessfullVC: BaseClassVC {
    var mainTitle = ""
    @IBOutlet weak var lblSourceAccountValue: UILabel!
     @IBOutlet weak var lblSourceAccountTitleName: UILabel!
    @IBOutlet weak var lblBeneficaryAccountValue: UILabel!
    @IBOutlet weak var lblBeneAccountTitleValue: UILabel!
    @IBOutlet weak var lblAmountValue: UILabel!
    @IBOutlet weak var lblTransReferenceNumberValue: UILabel!
    @IBOutlet weak var lblTransactionTime: UILabel!
    
    
    @IBOutlet weak var lblSourceAccountValue2: UILabel!
    @IBOutlet weak var lblBeneficaryAccountValue2: UILabel!
    @IBOutlet weak var lblBeneAccountTitleValue2: UILabel!
    @IBOutlet weak var lblAmountValue2: UILabel!
    @IBOutlet weak var lblTransReferenceNumberValue2: UILabel!
    @IBOutlet weak var lblTransactionTime2: UILabel!
    @IBOutlet weak var btnOk: UIButton!
 func ChangeLanguage()
  {
//      lblMainTitle.text = "Local Funds Transfer Successful".addLocalizableString(languageCode: languageCode)
      btnOk.setTitle("OK".addLocalizableString(languageCode: languageCode), for: .normal)
//    lblSourceAccountValue2.text = "Source Account".localizeString()
//    lblBeneficaryAccountValue2.text = "Beneficiary Account".localizeString()
//    lblBeneAccountTitleValue2.text = "Beneficiary Account Title".localizeString()
//    lblAmountValue2.text = "Transfer Amount".localizeString()
//    lblTransReferenceNumberValue2.text = "Transaction Reference Number".localizeString()
//    lblTransactionTime2.text = "Transaction Time".localizeString()
//    btnOk.setTitle("OK".localizeString(), for: .normal)
    
    
  }
    
    
    @IBOutlet weak var lblMainTitle: UILabel!
    
    var sourceAccount:String?
    var beneficaryAccount:String?
    var beneficaryAccountTitle:String?
    var transferAmount:String?
    var TransRefNumber:String?
    var TransTime:String?
    var accounttype: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeLanguage()
        self.updateUI()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Utility Methods
    
    private func updateUI(){
        if isFromDonations == true{
            lblMainTitle.text = mainTitle
        }
        else
        {
            lblMainTitle.text = "Local Funds Transfer Successful".addLocalizableString(languageCode: languageCode)
        }
        if let account = sourceAccount{
            self.lblSourceAccountValue.text = account
        }
        if let sourceAccount = DataManager.instance.serverAccountTitile  {
            self.lblSourceAccountTitleName.text = sourceAccount
        }
        if let beneAccount = beneficaryAccount{
            self.lblBeneficaryAccountValue.text = beneAccount
        }
        if let beneAccountTitle = beneficaryAccountTitle{
            self.lblBeneAccountTitleValue.text = beneAccountTitle
        }
        if let Tamount = transferAmount{
            self.lblAmountValue.text = "PKR \(Tamount).00"
        }
        if let transRef = TransRefNumber{
            self.lblTransReferenceNumberValue.text = transRef
        }
        if let transTime = TransTime {
            self.lblTransactionTime.text = transTime
        }
//        if let title = self.mainTitle{
//            self.lblMainTitle.text = "\(title) Successfull"
//        }
    }
    
    // MARK: - Action Methods
    @IBAction func okButtonPressed(_ sender: Any) {
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    @IBAction func shareButtonPressed(_ sender: Any) {
        captureScreen()
    }
   

    func captureScreen() {
            
            var image :UIImage?
            let currentLayer = UIApplication.shared.keyWindow!.layer
            let currentScale = UIScreen.main.scale
            UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale);
            guard let currentContext = UIGraphicsGetCurrentContext() else {return}
            currentLayer.render(in: currentContext)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            guard let img = image else { return }
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false // if you dont want the close button use false
            )
            let alertView = SCLAlertView(appearance: appearance)
            let button = alertView.addButton("Ok") {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                                              
                self.navigationController?.pushViewController(vc, animated: true)
            }
                                   
        button.backgroundColor = UIColor(red:18/255, green:94/255, blue: 157/255, alpha: 1.0)
                                   
            alertView.showCustom("", subTitle: ("Saved to Gallery"), color: UIColor(red:18/255, green:94/255, blue: 157/255, alpha: 1.0), icon: #imageLiteral(resourceName: "local_fund_transfer"))
           // UtilManager.showAlertMessage(message: "Saved to Gallery", viewController: self)
           
            
            
        }
}


