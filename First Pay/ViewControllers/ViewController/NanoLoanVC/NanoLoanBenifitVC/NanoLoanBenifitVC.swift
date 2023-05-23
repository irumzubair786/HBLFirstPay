//
//  NanoLoanBenifitVC.swift
//  First Pay
//
//  Created by Apple on 04/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class NanoLoanBenifitVC: UIViewController {

    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var viewBackGround: UIView!
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = .clrBlackWithOccupacy20
        viewBackGround.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    @IBAction func buttonCancel(_ sender: Any) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true)
    }


}
