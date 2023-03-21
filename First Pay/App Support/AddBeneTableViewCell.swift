//
//  AddBeneTableViewCell.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 24/10/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import UIKit

class AddBeneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet var btn_Delete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
