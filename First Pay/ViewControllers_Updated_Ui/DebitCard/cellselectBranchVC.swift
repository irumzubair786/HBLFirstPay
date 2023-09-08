//
//  cellselectBranchVC.swift
//  First Pay
//
//  Created by Irum Butt on 14/02/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class cellselectBranchVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        if (selected) {
            labelBranchName.textColor = UIColor(hexValue: 0x00CC96)
        } else {
            labelBranchName.textColor = UIColor.black
        }
        // Configure the view for the selected state
    }
    
    
    
    
    @IBOutlet weak var buttonSelectBranch: UIButton!
    @IBOutlet weak var labelBranchName: UILabel!
    
    

}
