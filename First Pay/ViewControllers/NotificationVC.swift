//
//  NotificationVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 25/08/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class NotificationVC: BaseClassVC {
    
    
    @IBOutlet weak var lblNotificationMessage : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if KeychainWrapper.standard.hasValue(forKey: "notiMessage"){
            let retrievedString: String? = KeychainWrapper.standard.string(forKey: "notiMessage")
            if let message = retrievedString{
                self.lblNotificationMessage.text = message
            }
        }
        
         let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "notiMessage")

    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "LoginPinVC") as! LoginPinVC
//        self.navigationController!.pushViewController(homePage, animated: true)
    ///    self.window?.rootViewController = homePage
        
              
       }

}
