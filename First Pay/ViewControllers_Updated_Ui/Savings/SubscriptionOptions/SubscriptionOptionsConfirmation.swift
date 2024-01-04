//
//  SubscriptionOptionsConfirmation.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 15/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SubscriptionOptionsConfirmation: UIViewController {
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewBackGroundAmount: UIView!
    @IBOutlet weak var viewBackGroundButtonYes: UIView!
    @IBOutlet weak var viewBackGroundButtonNo: UIView!
    @IBOutlet weak var labelAmount: UILabel!
    
    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var buttonYes: UIButton!
    override func viewDidAppear(_ animated: Bool) {
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)

        viewBackGroundAmount.radiusLineDashedStroke(radius:20 , borderWidth: 3, color: .clrOrange)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewBackGroundButtonYes.circle()
        viewBackGroundButtonNo.radius(radius: viewBackGroundButtonNo.frame.height/2, color: .clrOrange, borderWidth: 1)
        
        
        
    }
    
    @IBAction func buttonYes(_ sender: Any) {
    }
    @IBAction func buttonNo(_ sender: Any) {
    }
    
    

}
