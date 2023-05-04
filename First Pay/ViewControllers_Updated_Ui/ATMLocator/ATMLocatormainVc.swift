//
//  ATMLocatormainVc.swift
//  First Pay
//
//  Created by Irum Butt on 04/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class ATMLocatormainVc: UIViewController {
    var branchFlag : Bool = false
    var cashFlag :Bool = false
    var atmFlag : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDetail.setTitle("", for: .normal)
        buttonDetail.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var buttonDetail: UIButton!
    @IBOutlet weak var buttonATM: UIButton!
    @IBAction func buttonATM(_ sender: UIButton) {
        branchFlag = false
        cashFlag = false
        atmFlag = true
        buttonATM.backgroundColor = UIColor(hexValue: 0xF1943)
        buttonATM.setTitleColor(UIColor.white, for: .normal)
        buttonATM.borderColor = UIColor.clear
        buttonBranch.backgroundColor = UIColor.clear
        buttonBranch.borderColor = UIColor.gray
        buttonBranch.setTitleColor(UIColor.black, for: .normal)
        
        buttonCash.backgroundColor = UIColor.clear
        buttonCash.borderColor = UIColor.gray
        buttonCash.setTitleColor(UIColor.black, for: .normal)

        buttonDetail.isUserInteractionEnabled = true
        
    }
    @IBOutlet weak var buttonCash: UIButton!
    @IBAction func buttonCash(_ sender: UIButton) {
        branchFlag = false
        cashFlag = true
        atmFlag = false
        
        buttonCash.backgroundColor = UIColor(hexValue: 0xF19434)
        buttonCash.setTitleColor(.white, for: .normal)
        buttonCash.borderColor = UIColor.clear
        
        
        buttonBranch.backgroundColor = UIColor.clear
        buttonBranch.borderColor = UIColor.gray
        buttonBranch.setTitleColor(UIColor.black, for: .normal)
        
        buttonATM.backgroundColor = UIColor.clear
        buttonATM.borderColor = UIColor.gray
        buttonATM.setTitleColor(UIColor.black, for: .normal)
        buttonDetail.isUserInteractionEnabled = true
    }
    @IBOutlet weak var buttonBranch: UIButton!
    @IBAction func buttonBranch(_ sender: UIButton) {
        
        branchFlag = true
        cashFlag = false
        atmFlag = false
        buttonBranch.backgroundColor = UIColor(hexValue: 0x00CC96)
        buttonBranch.setTitleColor(.white, for: .normal)
        buttonBranch.borderColor = UIColor.clear
        
        buttonCash.backgroundColor = UIColor.clear
        buttonCash.borderColor = UIColor.gray
        buttonCash.setTitleColor(UIColor.black, for: .normal)
        
        buttonATM.backgroundColor = UIColor.clear
        buttonATM.borderColor = UIColor.gray
        buttonATM.setTitleColor(UIColor.black, for: .normal)
        buttonDetail.isUserInteractionEnabled = true
        
    }
    @IBAction func buttonDetail(_ sender: UIButton) {
        if branchFlag == true{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ATMBranchDetailViewController") as! ATMBranchDetailViewController
            self.present(vc, animated: false)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cashFlag == true{
            let vc = storyboard?.instantiateViewController(withIdentifier: "CashDetailVC") as! CashDetailVC
            self.present(vc, animated: false)
        }
        else
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ATMDetailVC") as! ATMDetailVC
            self.present(vc, animated: false)
            
        }
        
    }
    
}
