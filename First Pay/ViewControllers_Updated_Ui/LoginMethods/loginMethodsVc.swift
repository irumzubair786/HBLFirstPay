//
//  loginMethodsVc.swift
//  First Pay
//
//  Created by Irum Butt on 09/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SideMenu
var flagisEnable : Bool?
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
    override func viewWillAppear(_ animated: Bool) {
        checkIdEnable()
    }
    @IBAction func butttonEnableFaceid(_ sender: UISwitch) {
        if butttonEnableFaceid.isOn  == false{
            
            viewdisble.isHidden = false
        }
        else
        {
            
            guard let  FirsTimeLogin = UserDefaults.standard.string(forKey:  "enableTouchID")else
            {
                viewdisble.isHidden = true
                viewdisble.shadowColor = UIColor.gray
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BioMetricLoginVc") as! BioMetricLoginVc
              
                self.present(vc, animated: true)
                return
            }
        }
        
    }
    
    
    
    @IBAction func buttonChangePassowrd(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navigateToChangePassword")
        self.present(vc, animated: true)
       
        
       
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
        UserDefaults.standard.removeObject(forKey: "enableTouchID")
        buttonDisable.setTitleColor(.white, for: .normal)
        buttonDisable.backgroundColor = UIColor(hexString: "CC6801")
        let unSaveAccountPreview : Bool = KeychainWrapper.standard.set(false, forKey: "enableTouchID")
        print("Successfully Added to KeyChainWrapper \(unSaveAccountPreview)")
        self.showToast(title: "Successfully Deactivated")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "sideMenu") as? sideMenu
//            self.navigationController?.pushViewController(vc!, animated: true)
//                        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
//                        self.present(vc, animated: true)
        }
            
        
    }
    
    @IBAction func buttonNotNow(_ sender: UIButton) {
        self.dismiss(animated: true)
        
    }
    
    
    
}
