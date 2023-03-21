//
//  MessageChatButtonsCell.swift
//  First Pay
//
//  Created by Irum Zubair on 20/08/2021.
//  Copyright © 2021 FMFB Pakistan. All rights reserved.
//

import UIKit

class MessageChatButtonsCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
   
//    @IBOutlet weak var lbltext: UILabel!
    @IBOutlet weak var btntitle: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btntitle.setTitle("", for: .normal)
        // Initialization code
    }
//    override var isSelected: Bool {
//        didSet {
//            // set color according to state
//            self.backgroundColor = self.isSelected ? .gray : .clear
//        }
//    }
    //@IBOutlet weak var backview: UIView!
    
    
    

}
