//
//  DebitCardAddressVC.swift
//  First Pay
//
//  Created by Irum Butt on 09/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class DebitCardAddressVC: UIViewController {
    var flag = "false"
    var fullUserName : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.dropShadow1()
    
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(Movetoback(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizers)
        buttonBranchAddress.backgroundColor = UIColor.clear
        buttonPostal.backgroundColor = UIColor.clear
    }
    
    @IBOutlet weak var blurView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @objc func Movetoback(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBOutlet weak var buttonBranchAddress: UIButton!
    @IBAction func buttonBranchAddress(_ sender: UIButton) {
        buttonBranchAddress.backgroundColor = UIColor(hexValue: 0xF19434)
        buttonBranchAddress.setTitleColor(.white, for: .normal)
        buttonBranchAddress.borderColor = UIColor(hexValue: 0xF19434)
        buttonPostal.backgroundColor = UIColor.clear
        buttonPostal.setTitleColor(UIColor(hexValue: 0xF19434), for: .normal)
        buttonPostal.borderColor = UIColor(hexValue: 0xF19434)
        FBEvents.logEvent(title: .Debit_orderdeliverybranch_click)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectBranchVC") as!  selectBranchVC
        vc.fullname = fullUserName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var buttonPostal: UIButton!
    @IBAction func buttonPostal(_ sender: UIButton) {
        FBEvents.logEvent(title: .Debit_orderdeliverypostal_click)

        buttonPostal.backgroundColor = UIColor(hexValue: 0xF19434)
        buttonPostal.setTitleColor(.white, for: .normal)
        buttonPostal.borderColor = UIColor(hexValue: 0xF19434)
        buttonBranchAddress.backgroundColor = UIColor.clear
        buttonBranchAddress.setTitleColor(UIColor(hexValue: 0xF19434), for: .normal)
        buttonBranchAddress.borderColor = UIColor(hexValue: 0xF19434)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebitCardEnterAddressVc") as!  DebitCardEnterAddressVc
        vc.fullUserName = fullUserName
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
