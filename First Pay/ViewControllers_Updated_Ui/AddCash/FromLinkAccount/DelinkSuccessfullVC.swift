//
//  DelinkSuccessfullVC.swift
//  First Pay
//
//  Created by Irum Butt on 22/03/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class DelinkSuccessfullVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.alpha = 10
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MovetoNext(tapGestureRecognizer:)))
        imagePopup.isUserInteractionEnabled = true
        imagePopup.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var imagePopup: UIImageView!
    
    @objc func MovetoNext(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainPageVC")
        self.present(vc, animated: true)
    }

}
