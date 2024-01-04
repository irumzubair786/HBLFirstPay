//
//  SendMoney_MainVc.swift
//  First Pay
//
//  Created by Irum Butt on 10/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
var isfromFirstPayWallet: Bool = false
var isfromHblMbfAccount :Bool = false
var isfromBanktoBank : Bool = false
var isfromOtherLocalBank : Bool = false
class SendMoney_MainVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        FBEvents.logEvent(title: .SendMoney_category_selection)
        FaceBookEvents.logEvent(title: .SendMoney_category_selection)
        
        btn1.setTitle("", for: .normal)
        btn2.setTitle("", for: .normal)
        btn3.setTitle("", for: .normal)
        btn4.setTitle("", for: .normal)
        back.setTitle("", for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    
    @IBAction func Action_FirstPay_Wallet(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SendMoney_Local_Hblmfb", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navigatetoWllettowallet")
       
        self.present(vc, animated: true)
    }
    @IBAction func Action_HBLMFb_Account(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SendMoney_Local_Hblmfb", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navigatetoHblMFBAccount")
        
        self.present(vc, animated: true)
                
    }
    
    @IBAction func Action_back(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Action_otherBank_Account(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "SendMoney_Local_Hblmfb", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navigateToOtherBank")
        isfromBanktoBank = false
        isfromOtherLocalBank = true
        GlobalData.money_Reason = ""
        GlobalData.Selected_bank = ""
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true)
        
    }
    
    
    @IBAction func Action_Other_Wallet(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SendMoney_Local_Hblmfb", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navigateToOtherBank")
        isfromBanktoBank = true
//        isfromBanktoBank = false
        GlobalData.money_Reason = ""
        GlobalData.Selected_bank = ""
        self.present(vc, animated: true)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
