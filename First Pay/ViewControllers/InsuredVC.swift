//
//  InsuredVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 19/04/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class InsuredVC: BaseClassVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgaction.isUserInteractionEnabled = true
        imgaction.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var firstpaylogo: UIImageView!
    
    @IBOutlet weak var imgaction: UIImageView!
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(vc, animated: true)
       
    }
    @IBAction func back_action(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
//    func checkwherefrom()
//    {
//        if (DataManager.instance.insured) == "Y"
//        {
//            lblinsured.text = "Insured"
//             viewnotinsured.isHidden = true
//            print("done")
//
//
//
//        }
//        if (DataManager.instance.insured) == "N"
//        {
//            viewnotinsured.isHidden = false
//            viewinsured.isHidden = true
//            lblinsured.text = "Not Insured"
//
//            print("not isured")
//        }
        
    }
    
    
    

