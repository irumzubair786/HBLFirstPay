//
//  InstalmentDetailsTableViewCell.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 21/07/2020.
//  Copyright © 2020 FMFB Pakistan. All rights reserved.
//

import UIKit

class InstalmentDetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblPayTo: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblFineAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
