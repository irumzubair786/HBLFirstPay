//
//  SavingPlanDescriptions.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 17/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SavingPlanDescriptions: UIViewController {

    @IBOutlet weak var viewBackGroundButtonViewSavingPlan: UIView!
    @IBOutlet weak var buttonViewSavingPlan: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewBackGroundButtonViewSavingPlan.circle()
    }
    

    @IBAction func buttonBack(_ sender: Any) {
    }
    
    @IBAction func buttonViewSavingPlan(_ sender: Any) {
    }
    
}
