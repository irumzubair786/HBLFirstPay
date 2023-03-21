//
//  UtilityBillCollectionViewCell.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 17/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit

class UtilityBillCollectionViewCell: UICollectionViewCell {
    
        @IBOutlet var imageView : UIImageView!
        @IBOutlet var title : UILabel!
        @IBOutlet weak var viewForImage: UIView!
        
        
        private func updateButtonsRadius(){
            self.imageView.layer.cornerRadius = self.imageView.bounds.height / 2
        }
    }
