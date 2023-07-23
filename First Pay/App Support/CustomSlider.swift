//
//  CustomSlider.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 19/10/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 12.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }

}
