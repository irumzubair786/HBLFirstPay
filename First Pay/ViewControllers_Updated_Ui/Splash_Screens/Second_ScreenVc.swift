//
//  Second_ScreenVc.swift
//  First Pay
//
//  Created by Irum Butt on 18/01/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class Second_ScreenVc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    @IBOutlet weak var btn_next: UIButton!
    @IBAction func Next(_ sender: UIButton) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Third_ScreenVc") as!  Third_ScreenVc
              
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func handleLeftSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "Third_ScreenVc") as!  Third_ScreenVc
              
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
