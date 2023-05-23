//
//  BioMetricLoginVc.swift
//  First Pay
//
//  Created by Irum Butt on 09/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class BioMetricLoginVc: UIViewController {
    var termsAccepted:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonback.setTitle("", for: .normal)
        buttonface.setTitle("", for: .normal)
        buttonThumb.setTitle("", for: .normal)
        termsAccepted = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonTermsAndConditions(_ sender: UIButton) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier:"TermsandConditionsloginMethodsVc") as! TermsandConditionsloginMethodsVc
            self.navigationController?.pushViewController(webVC, animated: true)
    }
    @IBOutlet weak var buttonback: UIButton!
    @IBAction func buttonback(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var buttonface: UIButton!
    @IBOutlet weak var buttonThumb: UIButton!
    @IBAction func buttonThumb(_ sender: UIButton) {
        
        
        
    }
    @IBAction func buttonface(_ sender: UIButton) {
    }
    
    @IBAction func buttonContinue(_ sender: UIButton) {
        let webVC = self.storyboard?.instantiateViewController(withIdentifier:"TermsandConditionsloginMethodsVc") as! TermsandConditionsloginMethodsVc
        UserDefaults.standard.set("true", forKey: "enableTouchID")
//        KeychainWrapper.standard.set(true, forKey: "enableTouchID")
        self.present(webVC, animated: true)
//            self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    
    @IBOutlet weak var img_next: UIImageView!
    
    
}
