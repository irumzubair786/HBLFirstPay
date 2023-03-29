//
//  viaBankTransferStepsVc.swift
//  First Pay
//
//  Created by Irum Butt on 23/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class viaBankTransferStepsVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
