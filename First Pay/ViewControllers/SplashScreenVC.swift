//
//  SplashScreenVC.swift
//  First Pay
//
//  Created by Arsalan Amjad on 04/07/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit

class SplashScreenVC: UIViewController {
    var timer : Timer?
        var ary = [UIImage(named: "WalkThrough 8"),UIImage(named: "WalkThrough 7"),UIImage(named: "WalkThrough 9")]
        var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       print("appear ")
        imgsplash.image = ary[counter]
             DispatchQueue.main.async {
                 self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
             }
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(movetonext))
               print("fgnythnfgnfgg")
        imgsplash.isUserInteractionEnabled = true
        imgsplash.addGestureRecognizer(tap1)
        
        // Do any additional setup after loading the view.
    }
    @objc func changeImage() {
              
           if counter < 3 {
           
               imgsplash.image = ary[counter]
               print("counter", counter)
               
                counter += 1
            } else {
                 timer?.invalidate()
                 timer = nil
               //naviagete to your view controler
//                logicAlreadyRegistered
                DataManager.instance.forgotPassword
                
                
                guard let alreadylogin =  UserDefaults.standard.string(forKey: "AlreadyRegistered")
                else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVc_withoutLogin") as! HomeVc_withoutLogin
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                let New_User_ProfileVC = self.storyboard!.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
                UserDefaults.standard.set("true", forKey: "FirstTimeLogin")
                
               
                print("login device",DataManager.FirstTimeLogin )
                self.navigationController!.pushViewController(New_User_ProfileVC, animated: true)
                
            }
    }
                
                
                
//                if DataManager.instance.AlreadtLogin == true{
//                    let New_User_ProfileVC = self.storyboard!.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
//                    self.navigationController!.pushViewController(New_User_ProfileVC, animated: true)
//                }
//                else{
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVc_withoutLogin") as! HomeVc_withoutLogin
//                    self.navigationController?.pushViewController(vc, animated: true)
//
//                }
      


    @IBOutlet weak var imgsplash: UIImageView!
    @objc func movetonext()
    {
        
//        if DataManager.instance.AlreadtLogin == true{
//            let New_User_ProfileVC = self.storyboard!.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
//            self.navigationController!.pushViewController(New_User_ProfileVC, animated: true)
//        }
//        else{
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVc_withoutLogin") as! HomeVc_withoutLogin
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
        
    }
    
    
    
}
