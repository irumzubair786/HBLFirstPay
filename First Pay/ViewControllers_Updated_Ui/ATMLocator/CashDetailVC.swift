//
//  CashDetailVC.swift
//  First Pay
//
//  Created by Irum Butt on 04/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class CashDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCross.setTitle("", for: .normal)
        viewDetail.isHidden = true
        buttonshowDetail.setTitle("", for: .normal)
        buttonShowcashPointDetail.setTitle("", for: .normal)
        buttonShowcashPointDetail.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonCross(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    @IBOutlet weak var buttonCross: UIButton!

    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var buttonShowcashPointDetail: UIButton!
    @IBAction func buttonShowcashPointDetail(_ sender: UIButton) {

    }
    @IBOutlet weak var buttonshowDetail: UIButton!
    @IBAction func buttonshowDetail(_ sender: UIButton) {
        viewDetail.isHidden = false
    }

    
}
