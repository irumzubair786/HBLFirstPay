//
//  AccountUpgradeSuccessullVC.swift
//  First Pay
//
//  Created by Irum Butt on 11/07/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class AccountUpgradeSuccessullVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(moveTonext(tapGestureRecognizer:)))
        imgnext.isUserInteractionEnabled = true
        imgnext.addGestureRecognizer(tapGestureRecognizer3)
        buttonback.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var imgnext: UIImageView!
    @IBOutlet weak var buttonContinue: UIButton!
    
    @IBOutlet weak var buttonback: UIButton!
    @IBAction func buttonback(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @objc func moveTonext(tapGestureRecognizer: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
}
