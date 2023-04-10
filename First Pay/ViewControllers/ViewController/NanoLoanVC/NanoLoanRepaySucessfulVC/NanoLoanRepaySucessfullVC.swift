//
//  NanoLoanRepaySucessfulVC.swift
//  First Pay
//
//  Created by Apple on 03/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class NanoLoanRepaySucessfullVC: UIViewController {

    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTransactionId: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    
    @IBOutlet weak var labelFee: UILabel!
    @IBOutlet weak var buttonGetNewLoan: UIButton!
    @IBOutlet weak var buttonDownLoad: UIButton!
    
    @IBOutlet weak var buttonShare: UIButton!
    
    var modelPayActiveLoan: NanoLoanRepayConfirmationVC.ModelPayActiveLoan? {
        didSet {
            labelAmount.text = "Rs. \((modelPayActiveLoan?.data?.payableTotalAmount ?? 0).twoDecimal())"
            labelTransactionId.text = "\(modelPayActiveLoan?.data?.transRefNum ?? 0)"
            labelDateTime.text = modelPayActiveLoan?.data?.dateTime ?? ""
            labelFee.text = "Rs. \((modelPayActiveLoan?.data?.processingFee ?? 0).twoDecimal())"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonCancel(_ sender: Any) {
        dismissToViewController(viewController: AddCashMainVc.self)
    }
    @IBAction func buttonGetNewLoan(_ sender: Any) {
        dismissToViewController(viewController: AddCashMainVc.self)
    }
    
    @IBAction func buttonDownLoad(_ sender: Any) {
        let myImageScreenShot: UIImage? = self.view.getScreenshot()
        print(myImageScreenShot)
        myImageScreenShot?.shareScreenShot(viewController: self)
    }
    @IBAction func buttonShare(_ sender: Any) {
        let myImageScreenShot: UIImage? = self.view.getScreenshot()
        print(myImageScreenShot)
        myImageScreenShot?.shareScreenShot(viewController: self)
    }
}
