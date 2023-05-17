//
//  ATMDetailVC.swift
//  First Pay
//
//  Created by Irum Butt on 04/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class ATMDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var buttonCross: UIButton!
    @IBAction func buttonCross(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    

    
    @IBOutlet weak var buttonBack: UIButton!

}
