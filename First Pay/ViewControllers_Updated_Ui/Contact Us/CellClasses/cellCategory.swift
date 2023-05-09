//
//  cellCategory.swift
//  First Pay
//
//  Created by Irum Butt on 22/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit

class cellCategory: UICollectionViewCell {
   
    @IBOutlet weak var btnCategory: UIButton!
    
    @IBOutlet weak var backView: UIView!
   
    override var isSelected: Bool {
        didSet {
            // set color according to state
            self.backgroundColor = self.isSelected ? .blue : .clear
        }
    }
    
}
