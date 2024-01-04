//
//  CashDetailVC.swift
//  First Pay
//
//  Created by Irum Butt on 04/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class CashDetailVC: UIViewController {
    var flagFirstPreesed : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //        add swipe Gesture
        buttonCross.setTitle("", for: .normal)
        viewDetail.isHidden = true
//        buttonshowDetail.setTitle("", for: .normal)
        self.view.backgroundColor = .clear
        buttonDepositByBranch.setTitle("", for: .normal)
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonCross(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    @IBOutlet weak var buttonCross: UIButton!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var buttonshowDetail: UIButton!
    
    @IBOutlet weak var buttonDepositByBranch: UIButton!
    @IBAction func buttonshowDetail(_ sender: UIButton) {
        if flagFirstPreesed == false{
            viewDetail.isHidden = false
            flagFirstPreesed = true
        
        }
        else
        {
            viewDetail.isHidden = true
            flagFirstPreesed = false
        }
        
    }
    
}
