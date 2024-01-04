//
//  SavingsLowBalance.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 21/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SavingsLowBalance: UIViewController {

    @IBOutlet weak var viewBackGroundOtherAddCashOptions: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewBackGroundOtherAddCashOptions.radius(radius: 20)
    }
    
    @IBAction func buttonBack(_ sender: Any) {
    }
    
    

}
