//
//  IBFTSuccessVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 26/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit

class IBFTSuccessVC: BaseClassVC {
    
    @IBOutlet weak var lblSourceAccountValue: UILabel!
    @IBOutlet weak var lblSourceAccountTitle: UILabel!
    @IBOutlet weak var lblBeneficaryAccountValue: UILabel!
    @IBOutlet weak var lblBeneAccountTitleValue: UILabel!
    @IBOutlet weak var lblAmountValue: UILabel!
    @IBOutlet weak var lblTransReferenceNumberValue: UILabel!
    @IBOutlet weak var lblTransactionTime: UILabel!
    @IBOutlet weak var lblBeneficaryBankValue: UILabel!
    @IBOutlet weak var lblPurposeValue: UILabel!
    
    var sourceAccount:String?
    var beneficaryAccount:String?
    var beneficaryBank:String?
    var beneficaryAccountTitle:String?
    var transferAmount:String?
    var TransRefNumber:String?
    var TransTime:String?
    var purposeTrans:String?
    var accounttilte: String?
    var transactionRefferenceno: String?
    var Transactiontime: String?
    var mainTitle = ""

    @IBOutlet weak var btnok: UIButton!
    @IBOutlet weak var maintitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        maintitle.text = "IBFT Successful".addLocalizableString(languageCode: languageCode)
        btnok
            .setTitle("OK".addLocalizableString(languageCode: languageCode), for: .normal)
         self.updateUI()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Utility Methods
    
    private func updateUI(){
        if isFromDonations == true
        {
            maintitle.text = mainTitle
        }
        else
        {
            maintitle.text = "IBFT Successful".addLocalizableString(languageCode: languageCode)
        }
        if let account = sourceAccount{
            self.lblSourceAccountValue.text = account
        }
        if let sourceAccount = DataManager.instance.serverAccountTitile  {
            self.lblSourceAccountTitle.text = sourceAccount
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
        if let beneBank = beneficaryBank {
            self.lblBeneficaryBankValue.text = beneBank
        }
        if let purposeTrans = purposeTrans {
            self.lblPurposeValue.text = purposeTrans
        }
    }
    
    // MARK: - Action Methods
    @IBAction func okButtonPressed(_ sender: Any) {
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    @IBAction func shareButtonPressed(_ sender: Any) {
        
    }

}
