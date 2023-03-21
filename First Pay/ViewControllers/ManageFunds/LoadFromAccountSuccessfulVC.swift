//
//  LoadFromAccountSuccessfulVC.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 23/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit

class LoadFromAccountSuccessfulVC: BaseClassVC {

    @IBOutlet weak var lblMainTitle: UILabel!
    var mainTitle: String?
    
    @IBOutlet weak var lblSourceAccount: UILabel!
    var sourceAccountNo: String?
    @IBOutlet weak var lblBeneAccount: UILabel!
    var beneAccountNo : String?
    @IBOutlet weak var lblBeneAccountTitle: UILabel!
    var beneAccountTitle: String?
    @IBOutlet weak var lblTransferAmount: UILabel!
    var amount: String?
    @IBOutlet weak var lblTransferRefNumber: UILabel!
    var transferRefNumber: String?
    @IBOutlet weak var lblTransferTime: UILabel!
    var transferTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
             
          self.lblMainTitle.text = self.mainTitle
         }
    
    // MARK: - Utility Methods
    
    private func updateUI(){
        
        if let account = sourceAccountNo{
            self.lblSourceAccount.text = account
        }
        if let beneAccount = beneAccountNo{
            self.lblBeneAccount.text = beneAccount
        }
        if let beneAccountTitle = beneAccountTitle{
            self.lblBeneAccountTitle.text = beneAccountTitle
        }
        if let Tamount = amount{
            self.lblTransferAmount.text = "PKR \(Tamount).00"
        }
        if let transRef = transferRefNumber{
            self.lblTransferRefNumber.text = transRef
        }
        if let transTime = transferTime {
            self.lblTransferTime.text = transTime
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
