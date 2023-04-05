//
//  NanoLoanSuccessfullVC.swift
//  First Pay
//
//  Created by Apple on 03/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class NanoLoanSuccessfullVC: UIViewController {
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonGetNewLoan: UIButton!

    @IBOutlet weak var labelAmountTitle: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelAmountDescription: UILabel!
    @IBOutlet weak var labelTransactionIdTitle: UILabel!
    @IBOutlet weak var labelTransactionId: UILabel!
    @IBOutlet weak var labelDateTimeTitle: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelLoanNumberTitle: UILabel!
    @IBOutlet weak var labelLoanNumber: UILabel!
    
    @IBOutlet weak var labelLoanAvailedAmountTitle: UILabel!
    @IBOutlet weak var labelLoanAvailedAmount: UILabel!
    @IBOutlet weak var labelRepaymentDueDateTitle: UILabel!
    @IBOutlet weak var labelRepaymentDueDate: UILabel!
    @IBOutlet weak var labelAmountRapidDueDateTitle: UILabel!
    @IBOutlet weak var labelAmountRapidDueDate: UILabel!
    
    @IBOutlet weak var buttonDownLoad: UIButton!
    @IBAction func buttonDownLoad(_ sender: Any) {
    }
    @IBOutlet weak var buttonSend: UIButton!
    
    @IBAction func buttonSend(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonGetNewLoan(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
