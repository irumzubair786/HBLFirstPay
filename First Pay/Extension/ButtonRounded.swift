//
//  ButtonRounded.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 13/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import UIKit


class ButtonRounded: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.bounds.height/2
        self.titleLabel?.textColor = UIColor(hexString: "#0079B8")
    }
}
