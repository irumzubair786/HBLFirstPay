//
//  DiscountCollectionviewcell.swift
//  First Pay
//
//  Created by Syed Uzair Ahmed on 26/05/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class DiscountCollectionviewcell: UICollectionViewCell{
    
    @IBOutlet weak var btntext: UIButton!
    
    override func awakeFromNib() {


        }
    override var isSelected: Bool {
        didSet {
            // set color according to state
            self.backgroundColor = self.isSelected ? .gray : .clear
        }
    }

    
}
