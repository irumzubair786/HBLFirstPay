//
//  Third_ScreenVc.swift
//  First Pay
//
//  Created by Irum Butt on 18/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class Third_ScreenVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        btn_next.setTitle("", for: .normal)
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        leftSwipeGesture.direction = .left
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(leftSwipeGesture)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btn_next: UIButton!
    @objc func handleLeftSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        guard let alreadylogin =  UserDefaults.standard.string(forKey: "AlreadyRegistered")
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Mobile_VerificationVC") as! Mobile_VerificationVC
            isfromHomwWithoutCreationAccount = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        let New_User_ProfileVC = self.storyboard!.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
        isfromHomwWithoutCreationAccount = false
        UserDefaults.standard.set("true", forKey: "FirstTimeLogin")
        
       
        print("login device",DataManager.FirstTimeLogin )
        self.navigationController!.pushViewController(New_User_ProfileVC, animated: true)
        
    }
   
    @IBAction func Next(_ sender: UIButton) {
        guard let alreadylogin =  UserDefaults.standard.string(forKey: "AlreadyRegistered")
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Mobile_VerificationVC") as! Mobile_VerificationVC
            isfromHomwWithoutCreationAccount = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        let New_User_ProfileVC = self.storyboard!.instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
        isfromHomwWithoutCreationAccount = false
        UserDefaults.standard.set("true", forKey: "FirstTimeLogin")
        
        print("login device",DataManager.FirstTimeLogin )
        self.navigationController!.pushViewController(New_User_ProfileVC, animated: true)
    }

}
