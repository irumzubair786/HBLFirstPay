//
//  FakeLaunchScreenVc.swift
//  First Pay
//
//  Created by Irum Butt on 02/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class FakeLaunchScreenVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("login device",DataManager.FirstTimeLogin )
        
        guard let  FirsTimeLogin = UserDefaults.standard.string(forKey:  "FirstTimeLogin")else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "First_ScreenVc") as! First_ScreenVc
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FakeLoginVc") as! FakeLoginVc
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
        
       
}
    

   


