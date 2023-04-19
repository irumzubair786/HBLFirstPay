//
//  HomeVc_withoutLogin.swift
//  First Pay
//
//  Created by Irum Butt on 08/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit

class HomeVc_withoutLogin: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        btnHome.setTitle("", for: .normal)
        btnmain.setTitle("", for: .normal)
        btnQuestion.setTitle("", for: .normal)
        btnProfile.setTitle("", for: .normal)
        btnNotification.setTitle("", for: .normal)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        LblLoginorsignup.isUserInteractionEnabled = true
        LblLoginorsignup.addGestureRecognizer(tapGestureRecognizer)
        btnMove.setTitle("", for: .normal)
       
        
        // Do any additional setup after loading the view.
    }
    
   
    
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var LblLoginorsignup: UILabel!
   
    @IBOutlet weak var homeView: UIView!
    

    @IBOutlet weak var notificationView: UIView!
   
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var viewQuestionmark: UIView!
    @IBOutlet weak var btnMove: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnmain: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var viewprofile: UIView!
    @IBOutlet weak var btnQuestion: UIButton!
    @IBAction func Action_Home(_ sender: UIButton) {
//        homeView.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        notificationView.backgroundColor = .clear
//        viewQuestionmark.backgroundColor = .clear
//        viewprofile.backgroundColor = .clear
//        MainView.backgroundColor = .clear
    }
    
    @IBAction func Action_Notification(_ sender: UIButton) {
//        notificationView.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        homeView.backgroundColor = .clear
//        viewQuestionmark.backgroundColor = .clear
//        viewprofile.backgroundColor = .clear
//        MainView.backgroundColor = .clear
    }
    

    @IBAction func Action_Main(_ sender: UIButton) {
//        MainView.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        notificationView.backgroundColor = .clear
//        viewQuestionmark.backgroundColor = .clear
//        viewprofile.backgroundColor = .clear
//        homeView.backgroundColor = .clear
    }
    

    @IBAction func Action_QuestionMark(_ sender: UIButton) {
//        viewQuestionmark.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        notificationView.backgroundColor = .clear
//        homeView.backgroundColor = .clear
//        viewprofile.backgroundColor = .clear
//        MainView.backgroundColor = .clear
    }
    
    
    @IBAction func Action_Profile(_ sender: UIButton) {
//        viewprofile.backgroundColor =  UIColor(hexValue: 0x00CC96)
//        notificationView.backgroundColor = .clear
//        viewQuestionmark.backgroundColor = .clear
//        homeView.backgroundColor = .clear
//        MainView.backgroundColor = .clear
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Mobile_VerificationVC") as! Mobile_VerificationVC
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
}
