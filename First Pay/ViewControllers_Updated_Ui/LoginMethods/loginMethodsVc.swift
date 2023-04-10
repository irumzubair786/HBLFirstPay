//
//  loginMethodsVc.swift
//  First Pay
//
//  Created by Irum Butt on 09/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
class loginMethodsVc: BaseClassVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonback.setTitle("", for: .normal)
        viewdisble.isHidden = true
        checkIdEnable()
        // Do any additional setup after loading the view.
    }
    
func checkIdEnable()
    {
        if KeychainWrapper.standard.bool(forKey: "enableTouchID") == true {
            butttonEnableFaceid.isOn
        }
        else
        {
            butttonEnableFaceid.isOn = false
        }
        
    }
    
    @IBAction func butttonEnableFaceid(_ sender: UISwitch) {
        
        
        if butttonEnableFaceid.isOn  == false{
            viewdisble.isHidden = false
        }
        else
        {
            viewdisble.isHidden = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BioMetricLoginVc") as! BioMetricLoginVc
            self.present(vc, animated: true)
            
            
        }
        
    }
    
    
    
    @IBAction func buttonChangePassowrd(_ sender: UIButton) {
    }
    
    @IBOutlet weak var buttonNotNow: UIButton!
    @IBOutlet weak var buttonDisable: UIButton!
    @IBOutlet weak var butttonEnableFaceid: UISwitch!
    @IBOutlet weak var buttonChangePassowrd: UIButton!
    @IBOutlet weak var viewdisble: UIView!
    @IBOutlet weak var buttonback: UIButton!
    @IBAction func buttonback(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func buttonDisable(_ sender: UIButton) {
        buttonDisable.setTitleColor(.white, for: .normal)
        buttonDisable.backgroundColor = UIColor(hexString: "CC6801")
        let unSaveAccountPreview : Bool = KeychainWrapper.standard.set(false, forKey: "enableTouchID")
        print("Successfully Added to KeyChainWrapper \(unSaveAccountPreview)")
        self.showToast(title: "Successfully Deactivated")
    }
    
    @IBAction func buttonNotNow(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
    
    
}
