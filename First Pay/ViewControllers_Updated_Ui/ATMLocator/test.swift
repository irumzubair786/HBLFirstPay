//
//  test.swift
//  First Pay
//
//  Created by Irum Butt on 17/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class test: UIViewController {
    var flagFirstPreesed : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        buttonCross.setTitle("", for: .normal)
        buttonshowDetail.setTitle("", for: .normal)
        buttonShowcashPointDetail.setTitle("", for: .normal)
//        viewDetail.isHidden = true
        buttonShowcashPointDetail.isUserInteractionEnabled = false
        expandView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var cashpointView: UIView!
    @IBOutlet weak var expandView: UIView!
    @IBOutlet weak var buttonCross: UIButton!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var buttonShowcashPointDetail: UIButton!
    @IBAction func buttonShowcashPointDetail(_ sender: UIButton) {
    }
    @IBOutlet weak var buttonshowDetail: UIButton!
    @IBAction func buttonshowDetail(_ sender: UIButton) {
        if flagFirstPreesed == false{
            expandView.isHidden = false
            flagFirstPreesed = true
           
        }
        else
        {
            expandView.isHidden = true
            flagFirstPreesed = false
        }
       
        
       
    }
    @IBAction func buttonCross(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
}
