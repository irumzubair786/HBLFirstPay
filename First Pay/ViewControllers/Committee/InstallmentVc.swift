//
//  InstallmentVc.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 15/06/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper

class InstallmentVc: BaseClassVC {
    var commId : String?
    var fineAmount : String?
    var instalDetailsObj : InstalmentDetailsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMaintitle.text = "Installment".addLocalizableString(languageCode: languageCode)
        btnInsPaid.setTitle("INSTALLMENT PAID".addLocalizableString(languageCode: languageCode), for: .normal)
        btnInstReceived.setTitle("INSTALLMENT RECEIVED".addLocalizableString(languageCode: languageCode), for: .normal)
        lblMaintitle.text = "Installment List".addLocalizableString(languageCode: languageCode)

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var btnInstReceived: UIButton!
    @IBOutlet weak var btnInsPaid: UIButton!
    @IBOutlet weak var lblMaintitle: UILabel!
    @IBAction func insPaid(_ sender: UIButton) {
        
        
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CommitteeInstalDetailsVC") as! CommitteeInstalDetailsVC
        vc.commId = commId!
        print("commitee id is:", commId!)
        vc.fineAmount = fineAmount
//        vc.ischecked = "true"
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
   
    @IBAction func insReceived(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ReceivedInstallmentVC") as! ReceivedInstallmentVC
        vc.commId = commId!
        print("commitee received id is:", commId!)

        vc.fineAmount = fineAmount
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func backpressed(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    @IBAction func logoutbtn(_ sender: UIButton) {
        self.logoutUser()
    }
    
    
    @IBAction func logobtn(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
   
    
    
    
}
