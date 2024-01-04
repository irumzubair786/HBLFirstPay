//
//  ConfirmationScreen.swift
//  First Pay
//
//  Created by Irum Zubair on 08/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class ConfirmationScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    @IBOutlet weak var amountTF: UITextField!
    
    @IBOutlet weak var lblTransactionFee: UILabel!
    @IBOutlet weak var lblFromAccountNo: UILabel!
    @IBOutlet weak var lblLogoName: UILabel!
    
    @IBOutlet weak var lblTotalTransactionFee: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblAccountNo: UILabel!
    
    
    @IBAction func buttonContinue(_ sender: Any) {
        
        
    }
    
    
    
    
    

}
