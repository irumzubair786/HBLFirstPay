//
//  cellDebitCardNameSelection.swift
//  First Pay
//
//  Created by Irum Butt on 14/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class cellDebitCardNameSelection: UICollectionViewCell {
    @IBOutlet weak var buttonName: UIButton!
//    override var isSelected: Bool  {
    @IBOutlet weak var labelName: UILabel!
    //           didSet {
    @IBOutlet weak var backView: UIView!
    //
//               if isSelected  == true{
////
////                   // Set button selected state
////                   buttonName.backgroundColor = UIColor(red: 241/255, green: 147/255, blue: 52/255, alpha: 1)
////                   buttonName.cornerRadius = 12
////                   buttonName.setTitleColor(.white, for: .normal)
////                   let a = UIImage(named: "")
////                   buttonName.setBackgroundImage(a, for: .normal)
//               } else {
//                   // Set button deselected state
////                    isSelected = false
//
////                   buttonName.backgroundColor = .clear
////                   buttonName.setTitleColor(.gray, for: .normal)
//
//               }
//           }
//}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.backView.radiusLineDashedStroke(radius: self.backView.frame.size.height ,color: .clrGray)
        }
    }
}
