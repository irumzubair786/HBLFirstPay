//
//  SavingsDashboard.swift
//  First Pay
//
//  Created by Shakeel Ahmed on 15/11/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class SavingsDashboard: UIViewController {

    @IBOutlet weak var viewBackGroundPlan: UIView!
    @IBOutlet weak var viewBackGroundTwoShade: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.viewBackGroundTwoShade.bounds
        gradientLayer.colors = [UIColor.clrLightGreen.cgColor, UIColor.clrDarkGreen.cgColor] //Add different color here
        self.viewBackGroundTwoShade.layer.addSublayer(gradientLayer) //Add Layer in your View
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        DispatchQueue.main.async {
            self.viewBackGroundPlan.setShadowThin(radius: 20)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackGroundTwoShade.radius(radius: 20)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
