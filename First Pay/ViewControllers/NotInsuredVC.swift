//
//  NotInsuredVC.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 20/04/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class NotInsuredVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        firstpaylogo.isUserInteractionEnabled = true
        firstpaylogo.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func crossACTIOn(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var firstpaylogo: UIImageView!
 
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
}
