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
