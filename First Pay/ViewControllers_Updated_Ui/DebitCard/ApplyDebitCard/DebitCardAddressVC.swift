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
        //        blurView.isHidden = true
        let tapGestureRecognizers = UITapGestureRecognizer(target: self, action: #selector(Movetoback(tapGestureRecognizer:)))
        blurView.isUserInteractionEnabled = true
        blurView.addGestureRecognizer(tapGestureRecognizers)
        buttonBranchAddress.backgroundColor = UIColor.clear
        buttonPostal.backgroundColor = UIColor.clear
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postalAddress(tapGestureRecognizer:)))
        //        imagePostalAddress.isUserInteractionEnabled = true
        //        imagePostalAddress.addGestureRecognizer(tapGesture)
        //
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(branchAddress(tapGestureRecognizer:)))
        //        imageBranchAddress.isUserInteractionEnabled = true
        //        imageBranchAddress.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    
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
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "selectBranchVC") as!  selectBranchVC
                    vc.fullname = fullUserName
                    self.navigationController?.pushViewController(vc, animated: true)
        
                
    }
    
    
    
    
    @IBOutlet weak var buttonPostal: UIButton!
    @IBAction func buttonPostal(_ sender: UIButton) {
        
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
