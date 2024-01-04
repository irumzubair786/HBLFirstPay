//
//  SentMoneyVC.swift
//  First Pay
//
//  Created by Irum Zubair on 08/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SentMoneyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBOutlet weak var mobileNoTF: UITextField!
    
    @IBOutlet weak var labelAlert: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        
        
    }
}
