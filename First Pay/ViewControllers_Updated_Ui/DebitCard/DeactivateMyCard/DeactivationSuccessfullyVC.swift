//
//  DeactivationSuccessfullyVC.swift
//  First Pay
//
//  Created by Irum Butt on 15/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class DeactivationSuccessfullyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.alpha = 0.9
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Movetoback(tapGestureRecognizer:)))
        imagePopUp.isUserInteractionEnabled = true
        imagePopUp.addGestureRecognizer(tapGesture)
       
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var imagePopUp: UIImageView!
    @objc func Movetoback(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
        
    }
}
