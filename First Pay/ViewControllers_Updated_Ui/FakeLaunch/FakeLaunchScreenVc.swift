//
//  FakeLaunchScreenVc.swift
//  First Pay
//
//  Created by Irum Butt on 02/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class FakeLaunchScreenVc: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent // You can choose .default for dark text/icons or .lightContent for light text/icons
        }
    override func viewDidLoad() {
        super.viewDidLoad()
//                testVC()
//                return()
        print("login device",DataManager.FirstTimeLogin )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            guard let  FirsTimeLogin = UserDefaults.standard.string(forKey:  "FirstTimeLogin")else
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SplashWalkThroughPageControll") as! SplashWalkThroughPageControll
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FakeLoginVc") as! FakeLoginVc
            isfromHomwWithoutLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func testVC() {
//        InviteFriends()
        ATMLocatorVC()
    }
    func InviteFriends() {
        let vc = UIStoryboard.init(name: "InviteFriends", bundle: nil).instantiateViewController(withIdentifier: "InviteAFriends") as! InviteAFriends
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func ATMLocatorVC() {
        let vc = UIStoryboard.init(name: "ATMLocator", bundle: nil).instantiateViewController(withIdentifier: "ATMLocatormainVc") as! ATMLocatormainVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
       
}
    

   


