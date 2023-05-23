//
//  Cell_CitySelectedVC.swift
//  First Pay
//
//  Created by Irum Butt on 13/12/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit

class Cell_CitySelectedVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        if (selected) {
            lblcityname.textColor = UIColor(hexValue: 0x00CC96)
        } else {
            lblcityname.textColor = UIColor.black
        }
        // Configure the view for the selected state
    }
    
  
    
    @IBOutlet weak var lblcityname: UILabel!
    
}
